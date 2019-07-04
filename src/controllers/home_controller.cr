class HomeController < ApplicationController
  def index
    render("index.ecr")
  end

  def upload
    Image.new().upload(params[:filepath], params[:imgbody])
  end
end
