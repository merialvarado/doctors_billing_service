class ActivityLog < ApplicationRecord
  belongs_to :user

  ACTIONS = {
    :create => "Create New Record",
    :edit => "Edit Record"
  }

  def self.record_activity(user, action, object, object_id, notes = nil)
    log = ActivityLog.new
    log.user = user
    log.action = action
    log.object_name = object
    log.object_id = object_id
    log.notes = notes

    log.save
  end
end
