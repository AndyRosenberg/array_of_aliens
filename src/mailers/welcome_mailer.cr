class WelcomeMailer < ApplicationMailer
  def initialize(email : String, token : String, host : String)
    to email: email

    subject "Confirm your account with Array of Aliens"

    html render("mailers/welcome_mailer.html.ecr", "mailer.ecr")
  end
end
