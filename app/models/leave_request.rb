class LeaveRequest < ActiveRecord::Base
  validates :leave_type, presence: true
  validates :status, presence: true
  validates :leave_date, presence: true

	belongs_to :user
end
