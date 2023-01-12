defmodule CodeslackWeb.Plugs.ApiKey do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn,_) do
    get_x_api_key_header = Enum.find(conn.req_headers, fn {k, _v} -> k == "x-api-key" end)
    if get_x_api_key_header == {"x-api-key", Application.get_env(:codeslack, :api_key)} do
      conn
    else
      conn
      |> send_resp(403, "Unauthorized route")
      |> halt()
    end
  end
end
