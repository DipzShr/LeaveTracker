class UsersController < ApplicationController
  load_and_authorize_resource

  respond_to :json

  def get_events
    date = Date.today
    start_date = date.at_beginning_of_week
    end_date = date.at_end_of_week
    @leaves = if current_user.role? :admin
                LeaveRequest.where('leave_date BETWEEN ? AND ?', start_date, end_date)
              elsif current_user.role? :employee
                current_user.leave_requests.where('leave_date BETWEEN ? AND ?', start_date, end_date)
              end
    @events = []
    @leaves.each do |leave|
      @events << {:id => leave.id, :title => "#{leave.leave_type.camelize + '-' + leave.status.camelize + ' ' + leave.user.name}", :description => '', 
      :start => "#{leave.leave_date.to_date}",:end => ""}
    end
    render :text => @events.to_json
  end
end
