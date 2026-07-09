class UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.order(:name)
  end

  def new
    @user = User.new(role: "abogado")
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "Usuario #{@user.name} creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = user_params
    attrs = attrs.except(:password) if attrs[:password].blank?
    if @user.update(attrs)
      redirect_to users_path, notice: "Usuario #{@user.name} actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == Current.user
      redirect_to users_path, alert: "No puede eliminar su propio usuario."
    else
      @user.destroy
      redirect_to users_path, notice: "Usuario eliminado.", status: :see_other
    end
  end

  private

  def require_admin
    redirect_to root_path, alert: "Acceso restringido a administradores." unless Current.user&.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :role)
  end
end
