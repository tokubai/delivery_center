require 'delivery_center/application_record'

Dir.glob(DeliveryCenter.root.join('models', '*.rb')).each do |f|
  require f
end

ActiveRecord::Base.establish_connection(DeliveryCenter.database_config)
