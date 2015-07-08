class UsersController < ApplicationController
  respond_to :json
	def index
		
	end

	def get_events
    @leaves = current_user.leave_requests
    events = []
    @leaves.each do |leave|
      events << {:id => leave.id, :title => "#{leave.leave_type}", :start => "#{leave.leave_date}",:end => "" }
    end
    render :text => events.to_json
  end
end
