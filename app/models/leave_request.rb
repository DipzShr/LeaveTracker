class LeaveRequest < ActiveRecord::Base
  validates :type, :status, :start_at, :end_at, presence: true

	belongs_to :user
end
