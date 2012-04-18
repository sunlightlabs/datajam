class Admin::UsersController < AdminController

  def index
    @users = filter_and_sort User.all
    @user = User.new
    render_if_ajax 'admin/users/_table'
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "User saved."
      redirect_to admin_users_path
    else
      flash[:error] = "There was a problem saving the user."
      redirect_to admin_users_path
    end
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?

    if @user.update_attributes(params[:user])
      flash[:success] = "User updated."
      redirect_to admin_users_path
    else
      flash[:error] = "There was a problem saving the user."
      redirect_to admin_users_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

end
