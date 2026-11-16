defmodule MiniRedis.Connection do
  use GenServer, restart: :temporary

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end
  
  def init(state) do
    {:ok, state}
  end
  
  def handle_info(:active, state) do
   state 
   |> Map.get(:client_socket) 
   |> :inet.setopts([active: :once])
  
  {:noreply, state}
  end
end