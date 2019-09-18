class LoginController < ApplicationController
  def log_in
    render("login.ecr")
  end

  def authenticate
    user = User.find_by(email: params[:email]) || User.new
    if !user.new_record? && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Login successful."
      redirect_to "/users/#{user.id}"
    else
      flash[:danger] = "Login attempt failed."
      render("login.ecr")
    end
  end

  def log_out
    session.delete(:user_id)
    flash[:success] = "Successfully logged out."
    redirect_to "/"
  end
end