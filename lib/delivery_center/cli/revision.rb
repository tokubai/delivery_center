class DeliveryCenter::Cli::Revision < Thor
  namespace 'revision'

  desc 'switch [application name] [revision]', 'add revision'
  def add(application_name, revision)
    application = find_application(application_name)
    if application.revisions.where(value: revision).exists?
      DeliveryCenter.logger.info("already created #{application.name} - #{revision}")
    else
      application.revisions.create!(value: revision)
      DeliveryCenter.logger.info("create #{application.name} - #{revision}")
    end
  end

  desc 'current [application name]', 'fetch current revision'
  def current(application_name)
    print find_application(application_name).current_revision.value
  end

  private

  def find_application(name)
    application = DeliveryCenter::Application.find_by(name: name)
    if application.nil?
      DeliveryCenter.logger.error("notfound #{application}")
      exit 1
    end
    application
  end
end
