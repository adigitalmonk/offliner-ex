defmodule Offliner.TaskState do
  defstruct [
    :exec_ms,
    :started_at,
    :finished_at,
    :status,
    :filename,
    :task_id
  ]

  def new(filename, job_id) do
    %__MODULE__{
      filename: filename,
      task_id: job_id,
      exec_ms: "-",
      status: "Started",
      started_at: DateTime.utc_now()
    }
  end

  def done(task, exec_us, status) do
    %__MODULE__{
      task
      | exec_ms: exec_us / 1_000,
        status: status,
        finished_at: DateTime.utc_now()
    }
  end
end
