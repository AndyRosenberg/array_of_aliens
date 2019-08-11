class UserController < ApplicationController
  @user = User.new

  before_action do
    only [:confirm, :confirmation] { get_current_user }
  end

  def new
    render("new.ecr")
  end

  def create
    if User.create_with_bcrypt(params[:name], params[:email], params[:password])
      user = User.find_by(email: params[:email])
      if user && user.update_token
        session[:user_id] = user.id
        host = Amber.env.production? ? "#{request.host}" : "localhost:3000"
        WelcomeMailer.new(user.email_string, user.token.to_s, host).deliver
        flash[:success] = "We just sent a confirmation link to your email. The link will expire in one hour."
        redirect_to "/users/new"
      else
        failure_flash_new
      end
    else
      failure_flash_new
    end
  end

  def confirm
    truth = get_truth(@user)
    genders = ["man", "woman", "trans-man", "trans-woman", "fluid", "other"]
    states = ["AL", "AK", "AZ", "AR", "CA", "CO"]
    render("confirm.ecr")
  end

  def confirmation
    if successful_confirmation?
      flash[:success] = "Account creation successful."
      redirect_to "/"
    else
      failure_flash_confirm
    end
  end

  def matches
    dist = params[:dist]?.try(&.to_i) || 25
    matches = User.first!.available_matches(dist).map do |match|
      {
        :name => match.name,
        :pic => match.profile_pic,
        :gender => match.gender,
        :location => match.location
      }
    end

    respond_with do
      json matches.to_json
      html render("matches.ecr")
    end
  end

  def show
    user = User.find(params[:id]) || User.new
    redirect_to "/" if user.new_record?
    render("show.ecr")
  end

  private def get_truth(user : User)
    !user.new_record? && (params[:token] == user.token || user.sent_time? > 1.hour.ago)
  end

  private def failure_flash_new
    generic_failure_flash
    redirect_to "/users/new"
  end

  private def failure_flash_confirm
    generic_failure_flash
    redirect_to "/confirm/#{params[:token]}"
  end

  private def generic_failure_flash
    flash[:danger] = "Something went wrong. Please try again."
  end

  private def get_current_user
    @user = User.find(session[:user_id]) || @user
    redirect_to "/" if @user.new_record?
  end

  private def successful_confirmation?
    no_blanks? && update_user_from_confirmation && image_successful? && @user.update(accepted: true)
  end

  private def no_blanks?
    !(get_preferences.blank? || params[:city].blank?)
  end

  private def get_preferences
    params.fetch_all("preferences[]").join(",")
  end

  private def update_user_from_confirmation
    @user.update(
      gender: params[:gender],
      preference: get_preferences,
      city: params[:city],
      state: params[:state]
    )
  end

  private def image_successful?
    image = Image.upload(params[:filepath], params[:imgbody], true) || Image.new
    !image.new_record? && image.update(user_id: @user.id)
  end
end