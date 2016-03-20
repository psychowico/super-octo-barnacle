defmodule Helpers.NotVector do defexception message: "One of arguments is not Vector" end



defmodule Helpers.Vector do
	alias :math, as: Math
	alias Helpers.Vector, as: Vector
	defstruct x: 0.0, y: 0.0


	def distance(d1 = %Vector{},d2 = %Vector{}) do 
		Math.sqrt(Math.pow(d1.x - d2.x,2) + Math.pow(d1.y - d2.y,2))
	end
	
	def sum(d1 = %Vector{},d2 = %Vector{}) do
		%Vector{x: d1.x+d2.x, y: d1.y+d2.y}
	end

	def scale(d1 = %Vector{}, alpha = Integer) do
		%Vector{x: d1.x*alpha, y: d1.y*alpha}
	end

	def module(d = %Vector{}) do
		Math.sqrt(Math.pow(d.x,2) + Math.pow(d.y,2))
	end

	# ------- poli ------ #

	def scale(alpha = Integer, d1 = %Vector{}), do: scale(d1,alpha)

	# ------- errors ------ #

	def scale(_,_), do: raise NotVector
	def module(_), do: raise NotVector
	def distance(_,_), do: raise  NotVector
	def sum(_,_), do: raise NotVector


end


