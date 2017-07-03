class DeliveryCenter::Deploy < DeliveryCenter::ApplicationRecord
  belongs_to :application, class_name: 'DeliveryCenter::Application'
  belongs_to :revision, class_name: 'DeliveryCenter::Revision'

  def mark_current!
    self.class.transaction do
      self.class.where(application_id: application_id).update_all(current: false)
      self.current = true
      self.save!
    end
  end
end
