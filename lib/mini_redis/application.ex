defmodule MiniRedis.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name:  MiniRedis.ConnectionSupervisor},
      MiniRedis.Server
    ]

    opts = [strategy: :one_for_one, name: MiniRedis.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
