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
    begin
      leave_date = Date.strptime(params[:leave_date].to_s, "%m/%d/%Y")
      user = User.find_by_id(params[:id])
      leave_type = params[:leave_type]
      status = current_user.role?('admin') ? 'accepted' : 'pending'
      params_for_leave_request = { leave_type: leave_type ||= 'normal', status: status, leave_date: leave_date, duration: 'full_day' }
      leave_request = user.leave_requests.new(params_for_leave_request) if user.present?
      if leave_request && current_user.can_create?(leave_request)
        date_is_valid, message = date_valid?(leave_date, user)
        if date_is_valid
          leave_request.save!
          send_mail(leave_request)
        end
      else
        message = 'Invalid request.'
      end
    rescue ArgumentError
      message = 'Sorry unable to process.'
    end
    flash[:notice] = message

    redirect_to leave_requests_path
  end

  def update
    leave_request = LeaveRequest.find(params[:id])
    leave_request.update_attributes(status: params[:status])

    redirect_to leave_requests_path
  end

  private

  def date_valid?(date, user)
    day = date.strftime('%A')
    if date < Date.today
      message = "You cannot request for the date '#{date}'. The date has already gone."
      return false, message
    elsif (day == 'Sunday' || day == 'Saturday')
      message = "You have selected public holiday: '#{day}'."
      return false, message
    elsif user.leave_requests.map(&:leave_date).map(&:to_date).include?(date)
      message = "Sorry. Your leave request for the date '#{date}' has already been recorded earlier." 
      return false, message
    else
      message = "You cannot request for the date '#{date}'. The date has already gone."
      return true, message
    end
  end

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
