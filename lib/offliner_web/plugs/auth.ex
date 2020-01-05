defmodule OfflinerWeb.Plug.Auth do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    token =
      Application.get_env(:offliner, __MODULE__)
      |> Keyword.get(:token)

    case get_req_header(conn, "authorization") do
      [<<"Bearer ", ^token::binary>>] ->
        conn
      _ ->
        json(conn, %{error: "Missing 'Authorization' header"})
    end
  end
end
