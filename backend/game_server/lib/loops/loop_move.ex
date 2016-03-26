defmodule BernacleServer.Loops.LoopMove do
	alias BernacleServer.Supervisors.CellSupervisor
	alias BernacleServer.Loops.LoopsStateHolder

  	def start_link do
        {:ok, spawn_link(fn -> move_iteration(:os.system_time(:micro_seconds)) end)}
    end

    def move_iteration(time) do
        old_time = case LoopsStateHolder.get_loop_time(:move) do
            nil ->
                LoopsStateHolder.save_loop_time(:move, time)
                time
            x -> x
        end

        diff = (time - old_time)

        if diff > 0 do
            micro_sec_time = diff/1000

            LoopsStateHolder.save_loop_time(:move, time)
            CellSupervisor.do_on_child(:move, [micro_sec_time])
        end
    end

end
