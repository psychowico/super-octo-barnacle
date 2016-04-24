defmodule BernacleServer.Cell do
	alias BernacleServer.{Entity, Cell}
	alias BernacleServer.Helpers.{Physic, Vector}


	def born(position, velocity) do
		Entity.new()
			|> Entity.set_attribute(:position, position)
			|> Entity.set_attribute(:velocity, velocity)
			|> Entity.set_attribute(:mass, 5)
			|> Entity.give_ability(:move, Cell)
			|> Entity.give_ability(:eat, Cell)
	end

	def born(position), do: born(position, %Vector{})

	def born(), do: born(%Vector{}, %Vector{x: 1, y: 1})

	def move(cell = %Entity{}, time) do
		position = Entity.get_attribute(cell, :position)
		velocity = Entity.get_attribute(cell, :velocity)
		new_velocity = Physic.calc_current_forces(position, velocity)
		new_position = Physic.move(position, new_velocity, time)
		cell
			|> Entity.set_attribute(:position, new_position)
			|> Entity.set_attribute(:velocity, new_velocity)
	end

	def eat(cell, mass) do
		new_mass = Entity.get_attribute(cell, :mass) + mass
		Entity.set_attribute(cell, :mass, new_mass)
	end

end
