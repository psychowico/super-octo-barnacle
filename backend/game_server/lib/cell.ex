defmodule Cell do
	use Entity

	def born(position,velocity) do
		%Entity{} 
			|> set_attribute(:position, %Vector{})
			|> set_attribute(:velocity, %Vector{})
			|> set_attribute(:mass, 5)
			|> give_ability(:move, Cell)
			|> give_ability(:eat, Cell)
	end

	def move(cell,t)
		new_position = Physic.move(get_attribute(cell,:position),get_attribute(cell,:velocity),t)
		set_attribute(cell,:position,new_position)
	end

	def eat(cell, mass)
		set_attribute(cell, :mass , get_attribute(cell, :mass) + mass)
	end

end
