defmodule NotVector do defexception message: "One of arguments is not Vector" end



defmodule Helpers.Vector do
	alias :math
	defstruct x: 0.0, y: 0.0


	def distance(d1 = %Vector{},d2 = %Vector{}) do 
		sqrt(pow(d1.x - d2.x,2) + pow(d1.y - d2.y,2))
	end
	
	def sum(d1 = %Vector{},d2 = %Vector{}) do
		%Vector{x: d1.x+d2.x, y: d1.y+d2.y}
	end

	def scale(d1 = %Vector{}, alpha = Integer}) do
		%Vector{x: d1.x*alpha, y: d1.y*alpha}
	end

	def module(d = %Vector{}) do
		sqrt(pow(d1.x,2) + pow(d2.y,2))
	end

	# ------- poli ------ #

	def scale(alpha = Integer, d1 = %Vector{}), do: scale(d1,alpha)

	# ------- errors ------ #

	def scale(_,_), do: raise NotVector
	def module(_), do: raise NotVector
	def distance(_,_), do: raise  NotVector
	def sum(_,_), do: raise NotVector


end


