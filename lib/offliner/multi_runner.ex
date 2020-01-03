defmodule Offliner.MultiRunner do
    use Task
    alias Offliner.RunnerSupervisor
    alias Offliner.Runner

    def execute(job_name, id) do
        Task.Supervisor.start_child(RunnerSupervisor, Runner, :run, [job_name, id])
    end
end
