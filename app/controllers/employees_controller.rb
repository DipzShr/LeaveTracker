class EmployeesController < ApplicationController
  authorize_resource :class => :false
  skip_authorize_resource :only => [:update, :download_pdf, :upload_cv]

  def index
    @users = User.where.not(id: current_user.id)
    respond_to do |format|                                                                                                                                                                                                                                                                                                                                                                     
      format.html
      format.js
    end
  end

  def create
    name = params[:name]
    email = params[:email]
    role_name = params[:role]
    if params[:user_id].present?
      user = User.find_by_id(params[:user_id])
      user.update_attributes(email: email, name: name)
      unless user.roles.first.name == role_name
        role = Role.where(name: role_name).first_or_create
        user.roles.delete_all
        user.roles << role
      end
      flash[:notice] = 'Updated.'
    else
      user = User.create(email: email, password: 'hetauda04', password_confirmation: 'hetauda04', name: name)
      user.roles << Role.where(name: role_name).first_or_create
      flash[:notice] = 'Saved.'
    end

    redirect_to employees_path
  end

  def show
    unless @user = User.find_by_id(params[:id])
      flash[:notice] = 'Wrong parameter.'
      redirect_to employee_path(current_user.id)
    end
  end

  def destroy
    user = User.find(params[:id])
    user.roles.delete_all
    user.delete

    return redirect_to employees_path
  end

  def update
    user = User.find_by_id(params['id'])
    if current_user.is_valid?(user)
      if user.valid_password?(params['password0'])
        user.update_attributes(password: params['password1'], password_confirmation: params['password1'])
        sign_in(user, :bypass => true)
        message = 'Password successfully changed.'
      else
        message = 'You provided wrong old password.'
      end
    else
      message = 'Invalid Request.'
    end
    flash[:notice] = message

    redirect_to employee_path(current_user.id)
  end

  def upload_cv
    if upload = params[:upload]
      datafile = upload[:datafile]
      if File.extname(datafile.original_filename) == '.pdf'
        user = User.find(params[:employee_id])
        user.upload_cv(params[:upload])
        flash[:notice] = 'CV successfully uploaded.'
      else
        flash[:notice] = 'Wrong file type.'
      end
    else
      flash[:notice] = 'No pdf found.'
    end

    redirect_to employee_path(current_user.id)
  end

  def download_pdf
    authorize! :download_pdf, :employee
    user = User.find(params[:employee_id])
    send_file("#{Rails.root}/public/CVs/#{user.filename}",
              filename: "#{user.name}.pdf",
              type: "application/pdf")
  end

end
