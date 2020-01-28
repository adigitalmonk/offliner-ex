defmodule OfflinerWeb.Router do
  use OfflinerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OfflinerWeb do
    pipe_through :browser
    get "/", ViewController, :index
  end

  scope "/job", OfflinerWeb do
    pipe_through :api

    get "/", JobController, :check
    get "/ids", JobController, :ids
    get "/all", JobController, :list
    post "/", JobController, :create
  end
end
