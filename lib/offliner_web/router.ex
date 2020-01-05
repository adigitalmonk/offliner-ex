defmodule OfflinerWeb.Router do
  use OfflinerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OfflinerWeb.Plug.Auth
  end

  scope "/", OfflinerWeb do
    pipe_through :api

    get "/job", JobController, :check
    get "/job/ids", JobController, :ids
    get "/job/all", JobController, :list
    post "/job", JobController, :create
  end


  # Other scopes may use custom stacks.
  # scope "/api", OfflinerWeb do
  #   pipe_through :api
  # end
end
