class DeliveryCenter::Cli::Application < Thor
  namespace 'application'

  desc 'add [application name]', 'register application'
  def add(name)
    if DeliveryCenter::Application.where(name: name).exists?
      DeliveryCenter.logger.info("already exists #{name}.")
    else
      DeliveryCenter::Application.create!(name: name)
      DeliveryCenter.logger.info("added #{name} application.")
    end
  rescue => e
    DeliveryCenter.logger.error(e)
  end
end
