defmodule Offliner.Runner do
    alias Offliner.Cache
    alias Offliner.Runner.{Multi, Single}

    def execute(<<"safe_", job_name::binary>>, id) do
        Single.execute(job_name, id)
        IO.puts("-> Running task ['" <> job_name <> "'] safely")
    end

    def execute(job_name, id) do
        Multi.execute(job_name, id)
        IO.puts("-> Running task " <> job_name <> " in parallel")
    end

    def run("test", id), do: run_script("test.R", id)
    def run("fail", id), do: run_script("fail.R", id)
    def run(job, id) do
        Cache.set(id, "Task: " <> job <> " - not found")
    end

    def run_script(filename, id) do
        # TODO: Hard fails if Rscript not found and doesn't mark as failed
        case System.cmd("Rscript", ["algorithm/" <> filename]) do
            {res, 0} ->
                Cache.set(id, res)
            {_, exit_code} when is_integer(exit_code) when exit_code > 0 ->
                Cache.set(id, "Failure")
        end
    end
end
