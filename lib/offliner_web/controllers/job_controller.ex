defmodule OfflinerWeb.JobController do
    use OfflinerWeb, :controller
  
    alias Offliner.Cache
    alias Offliner.Spawner

    def check(conn, %{"id" => id}) do
        json(conn, %{
            data: Cache.result(id)
        })
    end

    def ids(conn, _params) do
        json(conn, %{
            ids: Cache.list()
        })
    end

    def list(conn, _params) do
        json(conn, %{
            data: Cache.results()
        })
    end

    def create(conn, %{"job" => job_name}) do
        json(conn, %{
            id: Spawner.multi_spawn(job_name)
        })
    end

    def mcreate(conn, _params) do
        json(conn, %{
            id: Spawner.multi_spawn("test")
        })
    end

    def screate(conn, _params) do
        json(conn, %{
            id: Spawner.spawn("test")
        })
    end
  end
  