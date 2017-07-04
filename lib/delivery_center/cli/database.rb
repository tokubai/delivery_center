require 'ridgepole'

class DeliveryCenter::Cli::Database < Thor
  namespace 'db'

  desc 'migrate', 'migrate delivery center database schema'
  option 'apply',  desc: 'apply', default: false, aliases: 'a', type: :boolean
  def migrate
    ridgepole.diff(schemafile.read, path: schemafile.to_s).migrate
  end

  desc 'create', 'create delivery center database'
  def create
    ActiveRecord::Base.clear_all_connections!
    ActiveRecord::Base.establish_connection(DeliveryCenter.database_config(excludes: [:database]))
    ActiveRecord::Base.connection.create_database(DeliveryCenter.database_config[:database])
    DeliveryCenter.logger.info("create #{DeliveryCenter.database_config[:database]} database.")
  end

  desc 'drop', 'drop delivery center database'
  def drop
    ActiveRecord::Base.clear_all_connections!
    ActiveRecord::Base.establish_connection(DeliveryCenter.database_config(excludes: [:database]))
    ActiveRecord::Base.connection.drop_database(DeliveryCenter.database_config[:database])
    DeliveryCenter.logger.info("drop #{DeliveryCenter.database_config[:database]} database.")
  end

  private

  def ridgepole
    @ridgepole ||= Ridgepole::Client.new(
      DeliveryCenter.database_config,
      dry_run: !options[:apply],
      debug: false,
    )
  end

  def schemafile
    DeliveryCenter.root.join('schema', 'Schemafile')
  end
end
