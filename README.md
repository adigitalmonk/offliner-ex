# Offliner

## Requirements
- Elixir + Erlang `brew install elixir`
- R `brew install R`

There's also an export of an InsomniaWorkspace

## The How

`JobController` handles incoming API requests.
Calls to the `POST /job?name="some job"` will attempt to run the `some_job`.
Jobs that are prefixed by `safe_` (e.g., `?job=safe_test`) will attempt to start the job `test` in the single runner.

There are two job runners: `Offliner.Runner.Single` and `Offliner.Runner.Multi`.

`Single` can only do a single task at a time.
This means that it will not start a new task until it finishes the previous one.

`Multi` will spin up a new `Task` for each incoming request.
It will run as many tasks in paralell as you ask it to.

Both Runners take a job name and a job ID.
Independently of everything is a simple cache, `Offliner.Cache`.
When starting a task, a note is made in the cache with the newly generated ID saying that it just started.
After the task finishes in the Runner process, it will mark the success / failure into the Cache.

`JobController` returns the new ID for the job to the caller when the job is created.
Subsequently, the caller can call the `GET /job?id=XXXX` end point to check the status of the job.

## Running The Server
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Future Work
- Better handler for calling remote scripts
- Better handling of job -> task queue / multi threading
  - `safe_` should be it's own param on the API or maybe some jobs just go to multi runner and some jobs go to the single runner
- Configuration linking job name to command to run
- Cache clean up process
- Docker development environment