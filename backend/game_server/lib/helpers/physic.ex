defmodule BernacleServer.Helpers.Physic do
	alias  BernacleServer.Helpers.Vector

    @time_factor = 1

	def move(position = %Vector{}, velocity = %Vector{}, time) do
        velocity |> Vector.scale(time * @time_factor) |> Vector.sum(position)
	end

	def move(%{position: position, velocity: velocity}, time) do
		move(position, velocity, time)
	end

    def calc_current_forces(position = %Vector{}, velocity = %Vector{}) do
        velocity_length = Vector.module(velocity)

        Vector.unit_vector(velocity)
            |> Vector.sum(game_vector_field(position))
            |> Vector.unit_vector
            |> Vector.scale(velocity_length)
    end

    def game_vector_field(position = %Vector{}) do
        width = 600
        height = 800
        case {position.x < 0, position.y < 0, position.x > width, position.y > height} do
            {true, true, false, false} -> Vector.new(1, 1)
            {false, true, true, false} -> Vector.new(-1, 1)
            {false, false, true, true} -> Vector.new(-1, -1)
            {true, false, false, true} -> Vector.new(1, -1)

            {true, false, false, false} -> Vector.new(1, 0)
            {false, true, false, false} -> Vector.new(0, 1)
            {false, false, true, false} -> Vector.new(-1, 0)
            {false, false, false, true} -> Vector.new(0, -1)
            {_, _, _, _} -> Vector.new(0, 0)
        end
    end
end
