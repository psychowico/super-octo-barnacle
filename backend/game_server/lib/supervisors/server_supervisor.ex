defmodule ServerSupervisor do
  use Supervisor

  @name ServerSupervisor
  
  def start_link do
    IO.puts "ServerSupervisor stared"
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
    	supervisor(CellSupervisor, [])
    ]
	  supervise(children, strategy: :rest_for_one)
  end

end
