defmodule ExchangeApiWeb.OrderController do
  use ExchangeApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: "** shrug das orders **"})
  end

  def init(_foo) do
    IO.inspect("order controller", [])
  end
end
