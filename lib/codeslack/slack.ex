defmodule Codeslack.Slack do

   def send(message) do
    HTTPoison.post(
      Application.get_env(:codeslack, :slack_webhook),
      '{"text": "#{message}"}',
      [{"Content-Type", "application/json"}]
    )
  end

  def get() do
    HTTPoison.get!(
      "#{Application.get_env(:codeslack, :slack_api_url)}/conversations.history?channel=#{Application.get_env(:codeslack, :channel_id)}",
      [{"Content-Type", "application/json"}, "Authorization": "Bearer #{Application.get_env(:codeslack, :user_token)}"]
    )
  end

  def delete(message) do
    HTTPoison.post(
      "#{Application.get_env(:codeslack, :slack_api_url)}/chat.delete",
      '{"channel": "#{Application.get_env(:codeslack, :channel_id)}", "ts": "#{message}"}',
      [{"Content-Type", "application/json"}, "Authorization": "Bearer #{Application.get_env(:codeslack, :user_token)}"]
    )
  end
end
