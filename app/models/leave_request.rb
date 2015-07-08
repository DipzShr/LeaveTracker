class LeaveRequest < ActiveRecord::Base
  validates :leave_type, :status, :leave_date, presence: true

	belongs_to :user
end
