require "quartz_mailer"

class ApplicationMailer < Quartz::Composer
  def sender
    address email: "admin@po-it.com", name: "Array of Aliens"
  end
end
