defmodule Offliner.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      OfflinerWeb.Endpoint,
      Offliner.Cache,
      Offliner.Runner.Single,
      {Task.Supervisor, name: Offliner.RunnerSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Offliner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    OfflinerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
