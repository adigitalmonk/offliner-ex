defmodule OfflinerWeb.ViewController do
  use OfflinerWeb, :controller

  def index(conn, _params) do
    live_render(conn, OfflinerWeb.ViewLive, session: %{})
  end
end
