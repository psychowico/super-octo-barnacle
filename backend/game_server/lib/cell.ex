defmodule Cell do
	import Entity
	alias Helpers.Physic, as: Physic
	alias Helpers.Vector, as: Vector

	def born(position,velocity) do
		%Entity{} 
			|> set_attribute(:position, position)
			|> set_attribute(:velocity, velocity)
			|> set_attribute(:mass, 5)
			|> give_ability(:move, Cell)
			|> give_ability(:eat, Cell)
	end
	def born(position), do: born(position, %Vector{})
	def born(), do: born(%Vector{}, %Vector{})

	def move(cell,t) do
		new_position = Physic.move(get_attribute(cell,:position),get_attribute(cell,:velocity),t)
		set_attribute(cell,:position, new_position)
	end

	def eat(cell, mass) do
		new_mass = get_attribute(cell, :mass) + mass
		set_attribute(cell, :mass, new_mass)
	end

end