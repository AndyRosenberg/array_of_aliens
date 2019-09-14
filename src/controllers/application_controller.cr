require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  LAYOUT = "application.ecr"
  @current_user : User | Nil

  def current_user
    return @current_user if @current_user
    return false unless session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end
