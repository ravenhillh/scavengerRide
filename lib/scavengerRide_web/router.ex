defmodule ScavengerRideWeb.Router do
  use ScavengerRideWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ScavengerRideWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ScavengerRideWeb do
    pipe_through :browser

    live "/points", PointLive.Index, :index
    live "/points/new", PointLive.Index, :new
    live "/points/:id/edit", PointLive.Index, :edit

    live "/points/:id", PointLive.Show, :show
    live "/points/:id/show/edit", PointLive.Show, :edit

    live "/stops", StopLive.Index, :index
    live "/stops/new", StopLive.Index, :new
    live "/stops/:id/edit", StopLive.Index, :edit

    live "/stops/:id", StopLive.Show, :show
    live "/stops/:id/show/edit", StopLive.Show, :edit

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", ScavengerRideWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:scavengerRide, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ScavengerRideWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
