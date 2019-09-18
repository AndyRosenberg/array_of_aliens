Amber::Server.configure do
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
  end

  pipeline :api do
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CORS.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
  end

  routes :web do
    get "/", HomeController, :index
    post "/upload", HomeController, :upload
    get "/login", LoginController, :log_in
    post "/login", LoginController, :authenticate
    get "/logout", LoginController, :log_out
    resources "/users", UserController, only: [:new, :create, :show]
    get "/confirm/:token", UserController, :confirm
    post "/confirmation/:token", UserController, :confirmation
    get "/matches", UserController, :matches
    resources "/conversations", ConversationController, only: [:create, :show, :destroy]
  end

  routes :web, "/conversations/:conversation_id" do
    resources "/messages", MessageController, only: [:create, :destroy]
  end

  routes :api do
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", Amber::Controller::Static, :index
  end
end
