class UserController < ApplicationController
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
    user = User.find(session[:user_id]) || User.new
    truth = get_truth(user)
    genders = ["man", "woman", "trans-man", "trans-woman", "fluid", "other"]
    states = ["AL", "AK", "AZ", "AR", "CA", "CO"]
    render("confirm.ecr")
  end

  private def get_truth(user : User)
    !user.new_record? && (params[:token] == user.token || user.sent_time? > 1.hour.ago)
  end

  private def failure_flash_new
    flash[:error] = "Something went wrong. Please try again."
    redirect_to "/users/new"
  end
end