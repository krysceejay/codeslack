defmodule Codeslack.Repo do
  use Ecto.Repo,
    otp_app: :codeslack,
    adapter: Ecto.Adapters.Postgres
end
