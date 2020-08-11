defmodule ExchangeApiWeb.PageController do
  use ExchangeApiWeb, :controller

  def index(conn, _params) do
    IO.puts("lmao")
    json(conn, %{status: "** shrug **"})
  end

  def init(_foo) do
  end
end
