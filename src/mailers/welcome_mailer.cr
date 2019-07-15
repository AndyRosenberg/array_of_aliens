class WelcomeMailer < Quartz::Composer
  def sender
    address email: "admin@po-it.com", name: "Array of Aliens"
  end

  def initialize(email : String, token : String)
    to email: email

    subject "Confirm your account with Array of Aliens"

    html render("mailers/welcome_mailer.html.ecr", "mailer.ecr")
  end
end
