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
end
