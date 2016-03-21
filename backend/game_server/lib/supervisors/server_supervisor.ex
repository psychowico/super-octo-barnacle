defmodule BernacleServer.ServerSupervisor do
    use Supervisor
    alias BernacleServer.CellSupervisor
  
    @name BernacleServerSupervisor
    
    def start_link do
        IO.puts "BernacleServerSupervisor stared"
        Supervisor.start_link(__MODULE__, :ok, name: @name)
    end
  
    def init(:ok) do
        children = [
            supervisor(CellSupervisor, [])
        ]
        supervise(children, strategy: :rest_for_one)
    end
end
