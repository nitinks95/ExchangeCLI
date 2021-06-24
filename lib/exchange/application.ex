defmodule Exchange.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Exchange.Aggregation, []},
      {Exchange.Connection, ["BTC-USD"]},
      {Exchange.Stats.Caller, []}
    ]


    opts = [strategy: :one_for_one, name: Exchange.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
