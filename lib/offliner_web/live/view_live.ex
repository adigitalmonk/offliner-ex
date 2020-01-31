defmodule OfflinerWeb.ViewLive do
  @moduledoc false
  use OfflinerWeb, :live_view
  alias Phoenix.PubSub

  def render(assigns) do
    ~L"""
    <table>
        <thead>
            <tr>
                <th>Task ID</th>
                <th>Task Name</th>
                <th>Start Time</th>
                <th>End Time</th>
                <th>Exec. Time (ms)</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
        <%= for { task_id, task_state } <- @tasks do %>
            <tr>
                <td><%= task_id %></td>
                <td><%= task_state.filename %></td>
                <td><%= render_time(task_state.started_at) %></td>
                <td><%= render_time(task_state.finished_at) %></td>
                <td><%= task_state.exec_ms %></td>
                <td><%= task_state.status %></td>
            </tr>
        <% end %>
        </tbody>
    </table>
    """
  end

  defp render_time(nil) do
    "N/A"
  end

  defp render_time(timestamp) do
    day =
        [timestamp.year, timestamp.month, timestamp.day]
        |> Enum.map(&to_string/1)
        |> Enum.map(&String.pad_leading(&1, 2, "0"))
        |> Enum.join("/")

    time =
        [timestamp.hour, timestamp.minute, timestamp.second]
        |> Enum.map(&to_string/1)
        |> Enum.map(&String.pad_leading(&1, 2, "0"))
        |> Enum.join(":")

    day <> " " <> time
  end

  def handle_info({:task_state, task_state}, socket) do
    tasks =
      Map.update(socket.assigns.tasks, task_state.task_id, task_state, fn _ -> task_state end)

    {:noreply, assign(socket, :tasks, tasks)}
  end

  # def handle_info(:purge, socket) do
  #   Process.send_after(self(), :purge, 60_000)
  #   {:noreply, socket}
  # end

  def handle_info(_msg, socket) do
    {:noreply, socket}
  end

  def mount(_params, _session, socket) do
    PubSub.subscribe(Offliner.PubSub, "task_view")
    # Process.send_after(self(), :purge, 10_000)
    {:ok, assign(socket, :tasks, %{})}
  end
end
