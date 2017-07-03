require 'thor'

class DeliveryCenter::Cli < Thor
  require 'delivery_center/cli/database'

  desc 'db SUBCOMMAND ...ARGS', 'manage db'
  subcommand 'db', DeliveryCenter::Cli::Database

  desc 'server', 'run delivery center web application'
  option 'port',  desc: 'listen port', default: 8080, aliases: 'p', type: :numeric
  option 'address',  desc: 'listen address', default: 'localhost', aliases: 'b', type: :string
  def server
    DeliveryCenter::App.run!(options)
  end
end
