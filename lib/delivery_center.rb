require 'active_record'

module DeliveryCenter
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.root
    Pathname.new(File.join(__dir__, 'delivery_center'))
  end

  def self.database_config(excludes: [])
    config = _database_config
    excludes.each { |key| config.delete(key) }
    config
  end

  def self._database_config
    if ENV['RACK_ENV'] == 'test'
      {
        adapter: 'mysql2',
        username: ENV['DELIVERY_CENTER_DATABASE_USERNAME'],
        password: ENV['DELIVERY_CENTER_DATABASE_PASSWORD'],
        database: 'delivery_center_test',
        host: ENV['DELIVERY_CENTER_DATABASE_HOST'],
        port: ENV['DELIVERY_CENTER_DATABASE_PORT'],
      }
    else
      {
        adapter: 'mysql2',
        username: ENV['DELIVERY_CENTER_DATABASE_USERNAME'],
        password: ENV['DELIVERY_CENTER_DATABASE_PASSWORD'],
        database: ENV['DELIVERY_CENTER_DATABASE_DATABASE'],
        host: ENV['DELIVERY_CENTER_DATABASE_HOST'],
        port: ENV['DELIVERY_CENTER_DATABASE_PORT'],
      }
    end
  end

  require 'delivery_center/app'
  require 'delivery_center/cli'
  require 'delivery_center/models'
  require "delivery_center/version"
end
