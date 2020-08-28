defmodule ExchangeApiWeb.UserControllerTest do
  use ExchangeApiWeb.ConnCase

  alias ExchangeApi.Accounts
  alias ExchangeApi.Accounts.User

  @create_attrs %{
    email: "some email"
  }
  @update_attrs %{
    email: "some updated email"
  }
  @invalid_attrs %{email: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"jwt" => jwt} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422) == "Failed to create user"
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
