defmodule MiniRedis.Server do
	use GenServer
	
	def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{port: Application.get_env(:mini_redis, :port)}, name: __MODULE__)
  end
	
	def init(state) do
		{:ok, socket} = state
		|> Map.get(:port)
		|> :gen_tcp.listen([:binary, packet: :line, ip: {127, 0, 0, 1}, active: false, reuseaddr: true])
    {:ok, Map.put(state, :socket, socket), {:continue, :accept}}
  end
	
	def handle_continue(:accept, state) do
		{:ok, client_socket} = 
		state
		|> Map.get(:socket)
		|> :gen_tcp.accept()
		
		{:ok, pid} = DynamicSupervisor.start_child(MiniRedis.ConnectionSupervisor, {MiniRedis.Connection, %{client_socket: client_socket}})
		:gen_tcp.controlling_process(client_socket, pid)
		send(pid, :active)
		
		{:noreply, state, {:continue, :accept}}
	end	
end