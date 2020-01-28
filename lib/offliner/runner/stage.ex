# https://hexdocs.pm/gen_stage/GenStage.html
defmodule Offliner.Runner.Stage do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def execute(job_name, id, timeout \\ 5000) do
    GenStage.call(__MODULE__, {:exec, job_name, id}, timeout)
  end

  ## Callbacks  
  def init(:ok) do
    {:producer, {:queue.new(), 0}, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_call({:exec, job_name, id}, from, {queue, demand}) do
    dispatch_events(:queue.in({from, job_name, id}, queue), demand, [])
  end

  def handle_demand(incoming_demand, {queue, demand}) do
    dispatch_events(queue, incoming_demand + demand, [])
  end

  defp dispatch_events(queue, demand, jobs) do
    case :queue.out(queue) do
      {{:value, {from, job_name, job_id}}, queue} ->
        GenStage.reply(from, :ok)
        dispatch_events(queue, demand - 1, [{job_name, job_id} | jobs])

      {:empty, queue} ->
        {:noreply, Enum.reverse(jobs), {queue, demand}}
    end
  end
end

defmodule Offliner.Runner.Stage.Consumer do
  use GenStage
  alias Offliner.Runner

  def start_link() do
    GenStage.start_link(__MODULE__, :ok)
  end

  # Callbacks  
  def init(:ok) do
    {:consumer, :ok, subscribe_to: [Offliner.Runner.Stage]}
  end

  def handle_events(jobs, _from, state) do
    Enum.each(jobs, fn {job_name, job_id} ->
      Runner.run(job_name, job_id)
    end)
    {:noreply, [], state}
  end
end
