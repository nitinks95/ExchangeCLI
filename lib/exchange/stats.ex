defmodule Exchange.Stats do

  def get_stats() do
    :sys.get_state(Exchange.Aggregation)
    |> get_avg_val()
    |> get_max_rate()
    |> display()
  end

  defp display(%{}=counts) do
    {:ok, now} = DateTime.now("Etc/UTC")

    IO.ANSI.clear() <> """
    #{now}
    Average Buying price: #{Map.get(counts, "avg_buy")}
    Average Selling price: #{Map.get(counts, "avg_sell")}
    Maximum Buying Bid price: #{Map.get(counts, "max_buy")}
    Maximum Selling Bid price: #{Map.get(counts, "max_sell")}
    """
    |> IO.puts()
  end

  defp get_avg_val(%{}=counts) do
    avg_buy = calc_avg(Map.get(counts, "buy"))
    avg_sell = calc_avg(Map.get(counts, "sell"))

    counts
    |> Map.put("avg_buy", avg_buy)
    |> Map.put("avg_sell", avg_sell)
  end

  defp calc_avg(price_list) when is_list(price_list), do: Enum.sum(price_list)/length(price_list)

  defp calc_avg(_), do: 0

  defp get_max_rate(%{}=counts) do
    max_buy = calc_max(Map.get(counts, "buy"))
    max_sell = calc_max(Map.get(counts, "sell"))

    counts
    |> Map.put("max_buy", max_buy)
    |> Map.put("max_sell", max_sell)
  end

  defp calc_max(price_list) when is_list(price_list), do: Enum.max(price_list)

  defp calc_max(_), do: 0

end
