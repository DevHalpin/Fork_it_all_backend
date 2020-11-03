class UsersController < ApplicationController
  include CurrentUserConcern

  def myTwists
    # @myTwists = Recipe.joins("JOIN twists ON twists.recipe_id = recipes.id AND twists.user_id = ?", @user)
    @myTwists = Recipe.joins(:twists).where(twists: {user_id: @current_user.id}).select("recipes.id as recipe_id, recipes.name, recipes.meal_image, twists.id as twist_id, twists.content")
    render json: @myTwists
  end

  def index
    @users = User.order("created_at DESC")
    render json: @users.to_json
  end

  def show
    @user = User.find params[:id]
    render json: @user.to_json
  end

  def create
    @user = User.create(user_param)
    session[:user_id] = @user.id
    #redirect after login
    redirect_to '/'
    render json: @user
  end

  def update
    @user = User.find(params[:id])
    puts(user_param)
    if @user.update_attributes(user_param)
      render json: @user
    else
      puts @user.errors.full_messages
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    head :no_content, status: :ok
  end
  
  private
    def user_param
      params.require(:user).permit(:email, :profile_picture, :handle, :name, :bio, :password, :password_confirmation)
    end
end