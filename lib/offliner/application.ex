defmodule Offliner.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      OfflinerWeb.Endpoint,
      Offliner.Cache,
      {Task.Supervisor, name: Offliner.RunnerSupervisor},
      worker(Offliner.Runner.Stage, []),
      worker(Offliner.Runner.Stage.Consumer, [], id: 1)
    ]

    opts = [strategy: :one_for_one, name: Offliner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    OfflinerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
