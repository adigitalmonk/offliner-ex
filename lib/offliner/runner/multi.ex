defmodule Offliner.Runner.Multi do
  @moduledoc false

  use Task
  alias Offliner.Runner
  alias Offliner.RunnerSupervisor

  def execute(job_name, id) do
    Task.Supervisor.start_child(RunnerSupervisor, Runner, :run, [job_name, id])
  end
end
