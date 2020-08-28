defmodule ExchangeApiWeb.CompletedTradesLiveTest do
  use ExchangeApiWeb.ConnCase
  import Phoenix.LiveViewTest

  test "connected mount", %{conn: conn} do
    conn = get(conn, "/home/ticker/AGUS/completed")
    assert html_response(conn, 200) =~ " <th>Trade ID</th>"

    {:ok, _view, _html} = live(conn)
  end
end
