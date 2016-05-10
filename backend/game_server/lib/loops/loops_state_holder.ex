defmodule BernacleServer.Loops.LoopsStateHolder do

	@name :bernacle_loops_state_holder

	def start_link() do
		IO.puts "Loops State Holder"
		Agent.start_link(fn -> %{} end, name: @name)
	end

	def save_loop_time(loop, time) do
		Agent.update(@name, fn loop_state -> Map.put(loop_state, loop, time) end)
	end

	def get_loop_time(loop) do
		Agent.get(@name, fn loop_state ->
			Map.get(loop_state, loop)
		end)
	end
end
