defmodule ExchangeApiWeb.OrderBookLiveTest do
  use ExchangeApiWeb.ConnCase
  import Phoenix.LiveViewTest

  test "connected mount", %{conn: conn} do
    conn = get(conn, "/home/ticker/AGUS")
    assert html_response(conn, 200) =~ "<h3> Sell Orders: </h3>"
    assert html_response(conn, 200) =~ "<h3> Buy Orders: </h3>"

    {:ok, _view, _html} = live(conn)
  end
end
