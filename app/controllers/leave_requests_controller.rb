class LeaveRequestsController < ApplicationController

  def new
  	@employee = User.all
  	render layout: false
  end

  def index
  	@leaves = LeaveRequest.all.group_by(&:user)
  	# @leaves = LeaveRequest.all
  end

  def create
  	user = User.find(params[:id])
    leave_type = params[:leave_type]
    leave_date = Date.strptime(params[:leave_date], "%m/%d/%Y")
    binding.pry
    leave_request = user.leave_requests.create(leave_type: leave_type, status: 'pending', leave_date: leave_date, duration: 'full_day')
  	redirect_to leave_requests_path
  end

end
