defmodule Exchange.Aggregation do
  use GenServer

  def start_link([]), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do: {:ok, %{}}

  def new_message(msg),
    do: new_message(__MODULE__, msg)

  def new_message(pid, msg),
    do: GenServer.cast(pid, {:new_message, msg})

  def handle_cast({:new_message, %{"side" => side, "price" => price}}, %{}=counts) do
    updated_counts = case side do
      "buy" -> case Map.get(counts, "buy") do
        nil -> Map.put(counts, "buy", [to_number(price)])
        buy_list -> Map.put(counts, "buy", buy_list ++ [to_number(price)])
      end
      "sell" -> case Map.get(counts, "sell") do
        nil -> Map.put(counts, "sell", [to_number(price)])
        sell_list -> Map.put(counts, "sell", sell_list ++ [to_number(price)])
      end
    end

    {:noreply, updated_counts}
  end

  def handle_cast({:new_message, %{}}, %{}=counts), do: {:noreply, counts}

  def to_number(val) do
    if String.contains?(val, ".") do
      String.to_float(val)
    else
      String.to_integer(val) * 1.00
    end
  end

end
