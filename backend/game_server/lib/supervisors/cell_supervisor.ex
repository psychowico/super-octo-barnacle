defmodule BernacleServer.CellSupervisor do
    use Supervisor
    alias BernacleServer.{Entity,Cell}

    @name BernacleCellSupervisor

    def start_link do
        IO.puts "BernacleCellSupervisor stared"
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

    def give_children do 
        for { _ , pid, _, _} <- Supervisor.which_children(@name), do: pid
    end
end
