defmodule ExchangeApiWeb.PageController do
  use ExchangeApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: "** shrug **"})
  end

  def init(_foo) do
    IO.inspect("page controller", [])
  end
end
