defmodule Offliner.Cache do
    use Agent

    def start_link(_opts) do
        Agent.start_link(fn -> %{} end, name: __MODULE__)
    end

    def list, do: Agent.get(__MODULE__, fn state -> Map.keys(state) end)
    def results, do: Agent.get(__MODULE__, fn state -> state end)

    def result(id), do: Agent.get(__MODULE__, fn state -> Map.get(state, id, nil) end)    
    def set(id, success), do: Agent.update(__MODULE__, fn state -> Map.update(state, id, success, fn _ -> success end) end)
end