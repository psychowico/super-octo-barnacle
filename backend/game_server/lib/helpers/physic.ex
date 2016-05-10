defmodule BernacleServer.Helpers.Physic do
	alias  BernacleServer.Helpers.Vector

    @time_factor 1
	@width 600
	@width 800

	def move(position = %Vector{}, velocity = %Vector{}, time) do
        velocity |> Vector.scale(time * @time_factor) |> Vector.sum(position)
	end

	def move(%{position: position, velocity: velocity}, time) do
		move(position, velocity, time)
	end

	def turn(position = %Vector{}, velocity = %Vector{}, time) do
		calc_current_velocity(position, velocity)
	end

	def turn(%{position: position, velocity: velocity}, time) do
		turn(position, velocity, time)
	end

	def calc_new_velocity(position = %Vector{}, velocity = %Vector{}) do
        pos = get_possition_on_board(position, velocity)
		new_x = case pos.x do
			1 when velocity.x < 0 -> velocity.x * -1
			-1 when velocity.x > 0 -> velocity.x * -1
			_ -> velocity.x
		end

		new_y = case pos.y do
			1 when velocity.y < 0 -> velocity.y * -1
			-1 when velocity.y > 0 -> velocity.y * -1
			_ -> velocity.y
		end

		Vector.new(new_x, new_y)
    end

    def get_possition_on_board(position = %Vector{}, velocity = %Vector{}) do
        case {position.x < 0, position.y < 0, position.x > @width, position.y > @height} do
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
