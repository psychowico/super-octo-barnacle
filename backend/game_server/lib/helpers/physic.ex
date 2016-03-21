defmodule BernacleServer.Helpers.Physic do
	alias  BernacleServer.Helpers.Vector

	def move(position = %Vector{}, velocity = %Vector{}, time) do
		position |> Vector.sum( velocity |> Vector.scale( time ))
	end

	def move(%{position: position, velocity: velocity}, time) do 
		move(position, velocity, time)
	end
	
end
