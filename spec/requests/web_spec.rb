require 'web_spec_helper'

describe 'DeliveryCenter::Web' do
  describe 'GET /applications.json' do
    let!(:application) { FactoryGirl.create(:application) }

    it 'returns application json' do
      get "/applications.json"
      expect(last_response).to be_ok
      expect(last_response.body).to be_json_as([
        {
          'id'         => application.id,
          'name'       => application.name,
          'created_at' => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
          'updated_at' => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
        }
      ])
    end
  end

  describe 'POST /applications.json' do
    let!(:application_name) { 'deploy-application' }

    it 'returns application list json' do
      post "/applications.json", { name: application_name }
      expect(last_response).to be_ok
      expect(last_response.body).to be_json_as({
          'id'         => Fixnum,
          'name'       => application_name,
          'created_at' => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
          'updated_at' => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
      })
    end
  end

  describe 'GET /:name.json' do
    let!(:application) { FactoryGirl.create(:application) }

    it 'returns application json' do
      get "/#{application.name}.json"
      expect(last_response).to be_ok
      expect(last_response.body).to be_json_as({
          'id'         => application.id,
          'name'       => application.name,
          'created_at' => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
          'updated_at' => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
      })
    end
  end

  describe 'POST /:name/deploy.json' do
    let!(:application) { FactoryGirl.create(:application) }

    context 'has one revision' do
      let!(:revision) { FactoryGirl.create(:revision, application_id: application.id) }

      context 'do not have deploys' do
        it 'deploy success' do
          expect {
            post "/#{application.name}/deploy.json"
            expect(last_response).to be_ok
            expect(last_response.body).to be_json_as({
                'id'             => Fixnum,
                'application_id' => application.id,
                'revision_id'    => revision.id,
                'current'        => true,
                'created_at'     => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
                'updated_at'     => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
            })
          }.to change {
            application.current_revision
          }.from(nil).to(revision)
        end
      end

      context 'have already deployed revision deploy' do
        let!(:deploy) { FactoryGirl.create(:deploy, application_id: application.id, revision_id: revision.id, current: true) }

        it 'deploy success' do
          expect {
            post "/#{application.name}/deploy.json"
            expect(last_response).to be_ok
            expect(last_response.body).to be_json_as({
              'error_code' => 1,
              'message'    => String,
            })
          }.not_to change {
            application.current_revision
          }
        end
      end
    end

    context 'has some revision' do
      let!(:old_revision) { FactoryGirl.create(:revision, application_id: application.id) }
      let!(:new_revision) { FactoryGirl.create(:revision, application_id: application.id) }

      context 'do not have deploys' do
        it 'switch new revision' do
          expect {
            post "/#{application.name}/deploy.json"
            expect(last_response).to be_ok
            expect(last_response.body).to be_json_as({
                'id'             => Fixnum,
                'application_id' => application.id,
                'revision_id'    => new_revision.id,
                'current'        => true,
                'created_at'     => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
                'updated_at'     => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
            })
          }.to change {
            application.current_revision
          }.from(nil).to(new_revision)
        end
      end

      context 'have already deployed revision deploy' do
        let!(:deploy) { FactoryGirl.create(:deploy, application_id: application.id, revision_id: old_revision.id, current: true) }

        it 'switch new revision' do
          expect {
            post "/#{application.name}/deploy.json"
            expect(last_response).to be_ok
            expect(last_response.body).to be_json_as({
                'id'             => deploy.id + 1,
                'application_id' => application.id,
                'revision_id'    => new_revision.id,
                'current'        => true,
                'created_at'     => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
                'updated_at'     => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
            })
          }.to change {
            application.current_revision
          }.from(old_revision).to(new_revision)
        end
      end
    end
  end

  describe 'POST /:name/rollback.json' do
    let!(:application) { FactoryGirl.create(:application) }

    context 'has one revision' do
      let!(:revision) { FactoryGirl.create(:revision, application_id: application.id) }

      context 'do not have deploy' do
        it 'returns error' do
          post "/#{application.name}/rollback.json"
          expect(last_response).to be_ok
          expect(last_response.body).to be_json_as({
            'error_code' => 2,
            'message'    => String,
          })
        end
      end

      context 'have one deploy' do
        let!(:deploy) { FactoryGirl.create(:deploy, application_id: application.id, revision_id: revision.id, current: true) }

        it 'returns error' do
          expect {
            post "/#{application.name}/rollback.json"
            expect(last_response).to be_ok
            expect(last_response.body).to be_json_as({
              'error_code' => 2,
              'message'    => String,
            })
          }.not_to change {
            application.current_revision
          }
        end
      end
    end

    context 'has some revision' do
      let!(:old_revision) { FactoryGirl.create(:revision, application_id: application.id) }
      let!(:new_revision) { FactoryGirl.create(:revision, application_id: application.id) }

      context 'has some deploy' do
        let!(:old_deploy) { FactoryGirl.create(:deploy, application_id: application.id, revision_id: old_revision.id, current: false) }
        let!(:deploy) { FactoryGirl.create(:deploy, application_id: application.id, revision_id: new_revision.id, current: true) }

        it 'switch old revision' do
          expect {
            post "/#{application.name}/rollback.json"
            expect(last_response).to be_ok
            expect(last_response.body).to be_json_as({
                'id'             => old_deploy.id,
                'application_id' => application.id,
                'revision_id'    => old_revision.id,
                'current'        => true,
                'created_at'     => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
                'updated_at'     => /^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d.\d\d\dZ/,
            })
          }.to change {
            [deploy.reload.current, old_deploy.reload.current]
          }.from([true, false]).to([false, true])
        end
      end
    end
  end

  describe 'GET /:name/revisions/current' do
    let!(:application) { FactoryGirl.create(:application) }

    context 'has deploy' do
      let!(:revision) { FactoryGirl.create(:revision, application_id: application.id) }
      let!(:old_deploy) { FactoryGirl.create(:deploy, application_id: application.id, revision_id: revision.id, current: false) }
      let!(:deploy) { FactoryGirl.create(:deploy, application_id: application.id, revision_id: revision.id, current: true) }

      it 'returns current revision' do
        post "/#{application.name}/revisions/current"
        expect(last_response).to be_ok
        expect(last_response.body).to eq(revision.value)
      end
    end
  end
end
