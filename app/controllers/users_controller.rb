class UsersController < ApplicationController
  load_and_authorize_resource

  respond_to :json

  def get_events
    date = Date.today
    start_date = date.at_beginning_of_week
    end_date = date.at_end_of_week
    @leaves = if current_user.role? :admin
                LeaveRequest.all
              elsif current_user.role? :employee
                current_user.leave_requests
              end
    @events = []
    @leaves.each do |leave|
      @events << {:id => leave.id, :title => "#{leave.leave_type.camelize}-#{leave.status.camelize} #{leave.user.name}", :description => '', 
      :start => "#{leave.leave_date.to_date}", :className => "#{leave.status}Leave"}
    end
    render :text => @events.to_json
  end
end
