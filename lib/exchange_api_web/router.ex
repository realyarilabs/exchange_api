defmodule ExchangeApiWeb.Router do
  use ExchangeApiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ExchangeApiWeb do
    pipe_through(:browser)

    live "/", DashboardLive, :index

    scope "/ticker/:ticker" do
      scope "/orders" do
        get "/open", OrderController, :index_open
        get "/buy_side", OrderController, :count_buy_side
        get "/sell_side", OrderController, :count_sell_side
        get "/spread", OrderController, :spread
        get "/highest_bid_price", OrderController, :highest_bid_price
        get "/highest_bid_volume", OrderController, :highest_bid_volume
        get "/lowest_ask_price", OrderController, :lowest_ask_price
        get "/highest_ask_volume", OrderController, :highest_ask_volume
      end

      scope "/traders/:trader_id" do
        resources "/orders", TraderOrdersController, only: [:index, :create, :delete] do
          delete "/delete", TraderOrdersController, :delete
          get "/completed", TraderOrdersController, :index_completed
        end
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExchangeWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: ExchangeApiWeb.Telemetry)
    end
  end
end
