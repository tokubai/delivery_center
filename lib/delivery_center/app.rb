require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/json'

class DeliveryCenter::App < Sinatra::Base
  register Sinatra::Reloader if ENV['RACK_ENV'] == 'development'

  not_found do
    'not found'
  end

  get '/applications.json' do
    applications = DeliveryCenter::Application.all
    applications = applications.where("name LIKE '%#{params[:name]}%'") unless params[:name].nil?
    json applications
  end

  post '/applications.json' do
    json DeliveryCenter::Application.find_or_create_by(name: params[:name])
  end

  get '/:name.json' do
    json find_application
  end

  post '/:name/deploy.json' do
    begin
      json find_application.deploy!
    rescue DeliveryCenter::AlreadyDeployedError => e
      json({ error_code: e.code, message: 'already deployment latest revision' })
    end
  end

  post '/:name/rollback.json' do
    begin
      json find_application.rollback!
    rescue DeliveryCenter::PreviousDeployNotExistError => e
      json({ error_code: e.code, message: 'not found previous revision' })
    end
  end

  get '/:name/revisions.json' do
    json find_application.revisions.order(id: :desc)
  end

  post '/:name/revisions.json' do
    json find_application.revisions.find_or_create_by!(value: params[:revision])
  end

  get '/:name/revisions/current' do
    find_application.current_revision.value
  end

  get '/:name/revisions/current.json' do
    json find_application.current_revision
  end

  private

  def find_application
    application = DeliveryCenter::Application.find_by(name: params[:name])
    raise Sinatra::NotFound if application.nil?
    application
  end
end
