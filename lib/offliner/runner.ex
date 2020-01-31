defmodule Offliner.Runner do
  @moduledoc false
  alias Offliner.{Cache, TaskState}
  alias Offliner.Runner.{Multi, Stage}
  alias Phoenix.PubSub

  def execute(<<"safe_", job_name::binary>>, id) do
    Stage.execute(job_name, id)
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
    task = TaskState.new(filename, id)

    PubSub.broadcast(
      Offliner.PubSub,
      "task_view",
      {:task_state, task}
    )

    {exec_us, status} = :timer.tc(__MODULE__, :timed_script, [filename, id])

    PubSub.broadcast(
      Offliner.PubSub,
      "task_view",
      {:task_state, TaskState.done(task, exec_us, status)}
    )
  end

  def timed_script(filename, id) do
    # Hard fails if Rscript not found and doesn't mark as failed
    case System.cmd("Rscript", ["algorithm/" <> filename]) do
      {res, 0} ->
        Cache.set(id, res)
        res

      {_, exit_code} when is_integer(exit_code) when exit_code > 0 ->
        Cache.set(id, "Failure")
        "Failure"
    end
  end
end
