defmodule ExchangeApiWeb.PageController do
  use ExchangeApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: _params})
  end
end
