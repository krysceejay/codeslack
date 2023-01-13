defmodule CodeslackWeb.Plugs.ApiKey do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn,_) do
    get_auth_header = Enum.find(conn.req_headers, fn {k, _v} -> k == "authorization" end)
    if get_auth_header == {"authorization", Application.get_env(:codeslack, :api_key)} do
      conn
    else
      conn
      |> send_resp(403, "Unauthorized route")
      |> halt()
    end
  end
end
