defmodule Helpers.Physic do
	import Helpers.Vector
	alias  Helpers.Vector, as: Vector

	def move(%Vector{} = position, %Vector{} = velocity, time) do
		position |> sum( velocity |> scale( time ) )
	end

	def move(%{position: position, velocity: velocity}, time) do 
		move(position ,velocity ,time)
	end
end
