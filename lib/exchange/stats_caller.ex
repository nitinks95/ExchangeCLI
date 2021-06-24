defmodule Exchange.Stats.Caller do

  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_) do
    start()
    {:ok, nil}
  end

  def handle_info(:warm, _state) do
    Exchange.Stats.get_stats()
    start()
    {:noreply, nil}
  end

  def start, do: Process.send_after(self(), :warm, 5000)
  # restart process after 5sec

end
