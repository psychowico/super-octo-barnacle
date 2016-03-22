defmodule BernacleServer.Loops.LoopHolder do

	@name :bernacle_loop_holder

	def start_link() do 
		IO.puts "Loop holder"
		Agent.start_link(fn -> %{} end, name: @name)
	end

	def save_loop_time(loop, time) do 
		Agent.update(@name, fn loop_state -> Map.put(loop_state, loop, time) end)
	end

	def get_loop_time(loop) do 
		Agent.get(@name, fn loop_state -> Map.get(loop_state, loop) end)
	end
end
