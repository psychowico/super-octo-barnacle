defmodule BernacleServer.Cell do
	alias BernacleServer.{Entity}
	alias BernacleServer.Helpers.{Physic,Vector}


	def born(position, velocity) do
		Entity.new
			|> Entity.set_attribute(:position, position)
			|> Entity.set_attribute(:velocity, velocity)
			|> Entity.set_attribute(:mass, 5)
			|> Entity.give_ability(:move, Cell)
			|> Entity.give_ability(:eat, Cell)
	end

	def born(position), do: born(position, %Vector{})

	def born(), do: born(%Vector{}, %Vector{})

	def move(cell, time) do
		new_position = Physic.move(Entity.get_attribute(cell, :position), Entity.get_attribute(cell, :velocity), time)
		Entity.set_attribute(cell, :position, new_position)
	end

	def eat(cell, mass) do
		new_mass = Entity.get_attribute(cell, :mass) + mass
		Entity.set_attribute(cell, :mass, new_mass)
	end

end
