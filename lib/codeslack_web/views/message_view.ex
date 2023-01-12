defmodule CodeslackWeb.MessageView do
  use CodeslackWeb, :view
  alias CodeslackWeb.MessageView

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      subject: message.subject,
      body: message.body
    }
  end
end
