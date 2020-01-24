defmodule OfflinerWeb.JobController do
  use OfflinerWeb, :controller

  alias Offliner.Cache
  alias Offliner.Spawner

  def check(conn, %{"id" => id}) do
    json(conn, %{
      result: Cache.result(id)
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

  def create(conn, %{"name" => job_name}) do
    json(conn, %{
      id: Spawner.spawn(job_name)
    })
  end

  def create(conn, _params) do
    json(conn, %{
      error: "Provide a job name"
    })
  end
end
