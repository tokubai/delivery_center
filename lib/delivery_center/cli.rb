require 'thor'

class DeliveryCenter::Cli < Thor
  require 'delivery_center/cli/database'
  require 'delivery_center/cli/revision'
  require 'delivery_center/cli/application'

  desc 'db SUBCOMMAND ...ARGS', 'manage db'
  subcommand 'db', DeliveryCenter::Cli::Database

  desc 'revision SUBCOMMAND ...ARGS', 'manage db'
  subcommand 'revision', DeliveryCenter::Cli::Revision

  desc 'application SUBCOMMAND ...ARGS', 'manage db'
  subcommand 'application', DeliveryCenter::Cli::Application

  desc 'server', 'run delivery center web application'
  option 'port',  desc: 'listen port', default: 8080, aliases: 'p', type: :numeric
  option 'address',  desc: 'listen address', default: 'localhost', aliases: 'b', type: :string
  def server
    DeliveryCenter::App.run!(options)
  end

  desc 'deploy [application name]', 'deploy latest revision'
  def deploy(application_name)
    application = find_application(application_name)
    application.deploy!
    puts "current revision: #{application.current_revision.value}"
  end

  desc 'rollback [application name]', 'rollback previous revision'
  def rollback(application_name)
    application = find_application(application_name)
    application.rollback!
    puts "current revision: #{application.current_revision.value}"
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
