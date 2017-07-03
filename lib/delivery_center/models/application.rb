require 'delivery_center/errors'

class DeliveryCenter::Application < DeliveryCenter::ApplicationRecord
  has_many :revisions, class_name: 'DeliveryCenter::Revision'
  has_many :deploys, class_name: 'DeliveryCenter::Deploy'

  class AlreadyDeployedError < StandardError; end

  def can_deploy?
    current_revision != recent_revision
  end

  def deploy!
    self.class.transaction do
      raise DeliveryCenter::AlreadyDeployedError unless can_deploy?
      deploy = deploys.find_or_create_by!(revision: recent_revision)
      deploy.mark_current!
      deploys.reload # invalidate older current status has object cache
      deploy
    end
  end

  def can_rollback?
    current = deploys.find_by(current: true)
    return false if current.nil?
    deploys.where('id < :current_id', current_id: current.id).order(id: :desc).exists?
  end

  def rollback!
    self.class.transaction do
      current = deploys.find_by(current: true)
      raise DeliveryCenter::PreviousDeployNotExistError if current.nil?
      previous = deploys.where('id < :current_id', current_id: current.id).order(id: :desc).first
      raise DeliveryCenter::PreviousDeployNotExistError if previous.nil?
      previous.mark_current!
      deploys.reload # invalidate older current status has object cache
      previous
    end
  end

  def current_revision
    deploys.find_by(current: true)&.revision
  end

  def recent_revision
    revisions.last
  end
end
