defmodule CodeslackWeb.MessageControllerTest do
  use CodeslackWeb.ConnCase

  import Codeslack.ContentFixtures

  alias Codeslack.Content.Message

  @create_attrs %{
    body: "some body",
    subject: "some subject"
  }
  @update_attrs %{
    body: "some updated body",
    subject: "some updated subject"
  }
  @invalid_attrs %{body: nil, subject: nil}

  @not_found %Message{
    id: "e1510108-449e-4873-b8fc-df2f369c5527",
    body: "not found body",
    subject: "not found subject",
    inserted_at: ~N[2023-01-12 11:41:29],
    updated_at: ~N[2023-01-12 11:41:29]
  }

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", Application.get_env(:codeslack, :api_key))
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all messages", %{conn: conn} do
      conn = get(conn, Routes.message_path(conn, :index))

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    setup [:create_message]

    test "get message", %{conn: conn, message: %Message{id: id}} do
      conn = get(conn, Routes.message_path(conn, :show, id))

      assert %{
        "id" => ^id,
        "body" => "some body",
        "subject" => "some subject"
      } = json_response(conn, 200)["data"]
    end
  end

  describe "create message" do
    test "renders message when data is valid", %{conn: conn} do
      conn = post(conn, Routes.message_path(conn, :create), message: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      assert %{
               "id" => ^id,
               "body" => "some body",
               "subject" => "some subject"
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.message_path(conn, :create), message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update message" do
    setup [:create_message]

    test "renders message when data is valid", %{conn: conn, message: %Message{id: id} = message} do
      conn = put(conn, Routes.message_path(conn, :update, message), message: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      assert %{
               "id" => ^id,
               "body" => "some updated body",
               "subject" => "some updated subject"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, message: message} do
      conn = put(conn, Routes.message_path(conn, :update, message), message: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete message" do
    setup [:create_message]

    test "deletes chosen message", %{conn: conn, message: message} do
      conn = delete(conn, Routes.message_path(conn, :delete, message))
      assert response(conn, 204)
    end

    test "show 404 when message not found", %{conn: conn, message: _message} do
      assert_error_sent 404, fn ->
        get(conn, Routes.message_path(conn, :show, @not_found))
      end
    end
  end

  defp create_message(_) do
    message = message_fixture()
    %{message: message}
  end
end
