defmodule Offliner.SingleRunner do
    use GenServer

    alias Offliner.RunnerSupervisor
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
        Runner.run(job_name, id)
        {:noreply, nil}
    end
end
