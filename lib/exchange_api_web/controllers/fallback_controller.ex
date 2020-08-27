defmodule ExchangeApiWeb.FallbackController do
  use ExchangeApiWeb, :controller

  def call(conn, {:error, msg}) do
    json(conn, %{"error" => msg})
  end
end
