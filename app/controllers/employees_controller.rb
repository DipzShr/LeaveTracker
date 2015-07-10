class EmployeesController < ApplicationController

  def index
    @users = Array.wrap(User.all) - Array.wrap(current_user)
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
      user = User.find(params[:user_id])
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
    if current_user.valid_password?(params['password0'])
      current_user.update_attributes(password: params['password1'], password_confirmation: params['password1'])
      sign_in(current_user, :bypass => true)
      flash[:success] = 'Password successfully changed.'
    else
      flash[:error] = 'You provided wrong old password.'
    end

    redirect_to employee_path(current_user.id)
  end

  def upload_cv
    if upload = params[:upload]
      datafile = upload[:datafile]
      if File.extname(datafile.original_filename) == '.pdf'
        user = User.find(params[:employee_id])
        user.upload_cv(params[:upload])
        flash[:notice] = 'CV successfully updated.'
      else
        flash[:notice] = 'Wrong extension.'
      end
    else
      flash[:notice] = 'No pdf found.'
    end

    redirect_to employee_path(current_user.id)
  end

end
