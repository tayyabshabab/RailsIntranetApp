class UsersController < ApplicationController
  before_action :signed_in_user, except: :show
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:index, :new, :create, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

	def show
		@user = User.find(params[:id])
	end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:success] = "New user created successfully!"
      #sign_in @user
  		redirect_to users_url
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.documents.each do |d|
      path = "public/documents/#{d.file}"
      File.delete(path) if File.exist?(path)
    end
    @user.destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def documents
    @user = User.find(params[:id])
    @documents = @user.documents.order('created_at desc').paginate(page: params[:page])
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  	end

    def correct_user
      @user = User.find(params[:id])
      unless current_user.admin?
        redirect_to root_url unless current_user?(@user)
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
