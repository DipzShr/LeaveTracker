class LeaveRequestsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :new
  
  def new
    if current_user.role? :admin
      @employee = User.all
    else
      @employee = Array.wrap(current_user)
    end
  	render layout: false
  end

  def index
    @leaves = LeaveRequest.all.group_by(&:user)
    unless current_user.role? :admin
      @leaves = @leaves.select{ |user, leave_requests| user == current_user }
      @count = @leaves.map{|user, leave_requests| leave_requests.count }.first
    end
  end

  def create
  	user = User.find(params[:id])
    leave_type = params[:leave_type]
    leave_date = Date.strptime(params[:leave_date], "%m/%d/%Y")
    status = current_user.role?('admin') ? 'accepted' : 'pending'
    if leave_date >= Date.today
      day = leave_date.strftime('%A')
      if (day == 'Sunday' || day == 'Saturday')
        message = "You have selected public holiday: '#{day}'"
      else
        if user.leave_requests.map(&:leave_date).map(&:to_date).include?(leave_date)
          message = "Sorry. Your leave request for the date '#{leave_date}' has already been recorded."
        else
          leave_request = user.leave_requests.create(leave_type: leave_type, status: status, leave_date: leave_date, duration: 'full_day')
          send_mail(leave_request)
          message = "Your leave request has been successfully recorded for date '#{leave_date}'."
        end
      end
    else
      message = "You cannot request for the date '#{leave_date}'. The date has already gone."
    end
    flash[:notice] = message
    redirect_to leave_requests_path
  end


  private

  def send_mail(leave)
    Mail.defaults do
      delivery_method :smtp, Rails.configuration.action_mailer.smtp_settings
    end
    mail = Mail.new do
      to 'dipz.shr@gmail.com'
      from 'do-not-reply@hims.com'
      subject 'Leave Request'
      body "#{leave.user.name} is requesting leave on date #{leave.leave_date.to_date}."
    end
    mail.deliver!
  end

end
