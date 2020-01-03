defmodule Offliner.Spawner do

    alias Offliner.SingleRunner
    alias Offliner.MultiRunner
    alias Offliner.Cache

    # https://gist.github.com/danschultzer/99c21ba403fd7f49a26cc40571ff5cce
    defp gen_reference() do
        min = String.to_integer("100000", 36)
        max = String.to_integer("ZZZZZZ", 36)
    
        max
        |> Kernel.-(min)
        |> :rand.uniform()
        |> Kernel.+(min)
        |> Integer.to_string(36)
      end
    
    def spawn(job_name) do
        id = gen_reference()
        Cache.set(id, "Started")
        SingleRunner.execute(job_name, id)

        id
    end

    def multi_spawn(job_name) do
        id = gen_reference()
        Cache.set(id, "Started")
        MultiRunner.execute(job_name, id)

        id
    end
end