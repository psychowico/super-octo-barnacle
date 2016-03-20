defmodule Helpers.Physic do
	alias Helpers

	def move(%Vector{} = position, %Vector{} = velocity, time){
		position |> sum( velocity |> scale( time ) )
	}

	def move(%{position: position, velocity: velocity}, time) do 
		move(position ,velocity ,time)
	end
end
