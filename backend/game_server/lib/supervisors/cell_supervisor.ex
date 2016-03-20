defmodule CellSupervisor do
  use Supervisor

  @name CellSupervisor

  def start_link do
  	IO.puts "CellSupervisor stared"
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
    	 worker(Entity, [], restart: :temporary)
    ]
	supervise(children, strategy: :simple_one_for_one)
  end

  def spawn_cell do
    Supervisor.start_child(@name, [Cell.born])
  end


end
