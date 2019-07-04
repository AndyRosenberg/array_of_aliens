class HomeController < ApplicationController
  def index
    render("index.ecr")
  end

  def upload
    Image.upload(params[:filepath], params[:imgbody])
  end
end
