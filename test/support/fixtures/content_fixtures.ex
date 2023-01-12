defmodule Codeslack.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Codeslack.Content` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        body: "some body",
        subject: "some subject"
      })
      |> Codeslack.Content.create_message()

    message
  end
end
