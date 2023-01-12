defmodule CodeslackWeb.MessageController do
  use CodeslackWeb, :controller

  alias Codeslack.{Content, Slack}
  alias Codeslack.Content.Message

  action_fallback CodeslackWeb.FallbackController

  def index(conn, _params) do
    messages = Content.list_messages()
    render(conn, "index.json", messages: messages)
  end

  def create(conn, %{"message" => message_params}) do
    with {:ok, %Message{} = message} <- Content.create_message(message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.message_path(conn, :show, message))
      |> render("show.json", message: message)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Content.get_message!(id)
    render(conn, "show.json", message: message)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Content.get_message!(id)

    with {:ok, %Message{} = message} <- Content.update_message(message, message_params) do
      render(conn, "show.json", message: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Content.get_message!(id)

    %{body: body} = Slack.get()
    resp = body |> Jason.decode!()
    get_messages = Map.get(resp, "messages", [])
    msg_in_slack = Enum.find(get_messages, fn m -> m["text"] == "Subject: #{message.subject} \nMessage: #{message.body}" end)

    with {:ok, %Message{}} <- Content.delete_message(message) do
      send_resp(conn, 204, "Message was deleted successfully")
    end
  end
end
