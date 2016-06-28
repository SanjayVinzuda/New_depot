class UsersController < ApplicationController
  http_basic_authenticate_with name: "sanjay", password: "sanjay"
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :cartid


  # GET /users
  # GET /users.json
  def index
    # @users = User.all
    @users = User.order(:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully created." }
        # format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json

  def update
    current_password = params[:user].delete(:current_password) # Return and simultaneously delete value
    respond_to do |format|
      if @user.update(user_params) && @user.authenticate(current_password)
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else
        @user.errors.add(:current_password, "for user is incorrect") unless @user.authenticate(current_password)
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  # def update
  #   @user = User.find_by(name: params[:name])
  #   # pass = Digest::MD5.hexdigest("#{:password}");
  #   # puts "----------------------#{params[:current_password]}"
  #   # puts "----------------------#{params[:password_digest]}"
  #   # puts "----------------------#{ Digest::MD5.hexdigest("#{:password_confirmation}")}"
  #   # puts "----------------------#{ Digest::MD5.hexdigest("#{:current_password}")}"
  #   # puts "----------------------#{pass}"
  #   # puts "----------------------#{@user.authenticate(params[:current_password])}"
  #   puts "----------------------#{@user.name}"
  #   puts "----------------------#{@user.password_digest}"
  #   @a=params[:current_password]

  #   @cpp = request.params[:current_password]
  #   puts "----------------------#{@cpp}"


  #   if @user.name ==  params[:name] && @user.password_digest == params[:current_password]
  #     cp = params[:user].delete('current_password')
  #     @user.errors.add(:password, 'is not correct') unless @user.authenticate(cp)
  #     respond_to do |format|
  #       if @user.errors.empty? and  @user.update_with_password(user_params)

  #         format.html { redirect_to users_url, notice: "User  #{@user.name} was successfully updated." }
  #         # format.html { redirect_to @user, notice: 'User was successfully updated.' }
  #         format.json { render :show, status: :ok, location: @user }
  #       else
  #         format.html { render :edit }
  #         format.json { render json: @user.errors, status: :unprocessable_entity }
  #       end
  #     end
  #   else
  #     render 'edit'
  #   end
  # end
  #=============================================================================
  # def update
  #   respond_to do |format|
  #     if @user.update(user_params)
  #       format.html { redirect_to users_url, notice: "User  #{@user.name} was successfully updated." }
  #       # format.html { redirect_to @user, notice: 'User was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @user }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      @user.destroy
      session[:user_id] = nil
      flash[:notice] = "User #{@user.name} deleted."
    rescue  StandardError=>e
      flash[:notice] = e.message
    end
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User #{@user.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end


end
