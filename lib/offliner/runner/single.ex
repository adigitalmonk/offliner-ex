defmodule Offliner.Runner.Single do
  use GenServer
  alias Offliner.Runner
  alias Offliner.Cache

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def execute(job_name, id) do
    GenServer.cast(__MODULE__, {:run, job_name, id})
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_cast({:run, job_name, id}, _) do
    {:noreply, {job_name, id}, {:continue, :run}}
  end

  def handle_continue(:run, {job_name, id}) do
    Runner.run(job_name, id)
    {:noreply, nil}
  end

  def terminate({:enoent, _}, {job_name, id}) do
    Cache.set(id, "Job ['" <> job_name <> "'] died because something was not found")
  end
end
