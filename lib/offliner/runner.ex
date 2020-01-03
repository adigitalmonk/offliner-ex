defmodule Offliner.Runner do
    alias Offliner.Cache

    def run("test", id), do: run_script("test.R", id)
    def run("fail", id), do: run_script("fail.R", id)
    def run(job, id) do
        Cache.set(id, "Task: " <> job <> " - not found")
    end

    def run_script(filename, id) do
        case System.cmd("Rscript", ["algorithm/" <> filename]) do
            {res, 0} ->
                Cache.set(id, res)
            {_, exit_code} when is_integer(exit_code) when exit_code > 0 ->
                Cache.set(id, "Failure")
        end
    end
end
