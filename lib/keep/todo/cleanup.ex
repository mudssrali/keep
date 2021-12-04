defmodule Keep.Todo.Cleanup do
  @moduledoc """
  a simple gen_server process to archive all unarchived lists which have not been updated in last 24 hours.
  It run execute schedule work after 5 mins 
  """
  use GenServer

  alias Keep.Todo

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{counter: 0})
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, %{counter: state.counter + 1}}
  end

  def handle_info(:work, state) do
    # Exec clean-up logic
    {updated_count, nil} = Todo.archive_lists()
    IO.puts("Cleanup Server: #{state.counter}")

    IO.puts("Archived #{updated_count} lists that have not been archived in last 24 hours")

    # Reschedule clean-up process once more
    schedule_work()
    {:noreply, %{counter: state.counter + 1}}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 5 * 60 * 1000)
  end
end
