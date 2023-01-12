defmodule Codeslack.Slack do

  @slack_webhook Application.compile_env!(:codeslack, :slack_webhook)
  @slack_api_url Application.compile_env!(:codeslack, :slack_api_url)
  @user_token Application.compile_env!(:codeslack, :user_token)
  @channel_id Application.compile_env!(:codeslack, :channel_id)

  def send(message) do
    HTTPoison.post(
      @slack_webhook,
      '{"text": "#{message}"}',
      [{"Content-Type", "application/json"}]
    )
  end

  def get() do
    HTTPoison.get!(
      "#{@slack_api_url}/conversations.history?channel=#{@channel_id}",
      [{"Content-Type", "application/json"}, "Authorization": "Bearer #{@user_token}"]
    )
  end

  def delete(message) do
    HTTPoison.post(
      "#{@slack_api_url}/chat.delete",
      '{"channel": "#{@channel_id}", "ts": "#{message}"}',
      [{"Content-Type", "application/json"}, "Authorization": "Bearer #{@user_token}"]
    )
  end
end
