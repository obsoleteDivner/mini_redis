defmodule MiniRedis.Server do
	use GenServer
	
	def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{port: Application.get_env(:mini_redis, :port)}, name: __MODULE__)
  end
	
	def init(state) do
		{:ok, socket} = state
		|> Map.get(:port)
		|> :gen_tcp.listen([:binary, packet: :line, active: false, reuseaddr: true])
    {:ok, Map.put(state, :socket, socket)}
  end
end