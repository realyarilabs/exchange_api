defmodule ExchangeApiWeb.HomeController do
  use ExchangeApiWeb, :controller
  plug :put_root_layout, false
  plug :put_layout, false

  action_fallback ExchangeApiWeb.FallbackController

  def home(conn, _params) do
    render(conn, "home.html")
  end
end
