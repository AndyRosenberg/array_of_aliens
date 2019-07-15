class UserController < ApplicationController
  def new
    render("new.ecr")
  end

  def create
    if User.create_with_bcrypt(params[:name], params[:email], params[:password])
      user = User.find_by(email: params[:email])
      if user && user.update_token
        WelcomeMailer.new(user.email_string, user.token.to_s).deliver
        flash[:success] = "We just sent a confirmation link to your email. The link will expire in one hour."
      else
        failure_flash_new
      end
    else
      failure_flash_new
    end
  end

  private def failure_flash_new
    flash[:error] = "Something went wrong. Please try again."
    redirect_to "/users/new"
  end
end