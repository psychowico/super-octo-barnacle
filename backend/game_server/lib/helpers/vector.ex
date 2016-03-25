defmodule BernacleServer.Helpers.RaiseNotVector do
	defexception message: "One of arguments is not Vector"
end

defmodule BernacleServer.Helpers.Vector do
	alias :math, as: Math
	alias BernacleServer.Helpers.{Vector, RaiseNotVector}

	defstruct x: 0.0, y: 0.0

	def distance(v1 = %Vector{}, v2 = %Vector{}) do
		Math.sqrt(Math.pow(v1.x - v2.x, 2) + Math.pow(v1.y - v2.y, 2))
	end

	def distance(_,_), do: raise  RaiseNotVector

	def sum(v1 = %Vector{}, v2 = %Vector{}) do
		%Vector{x: v1.x + v2.x, y: v1.y + v2.y}
	end

	def sum(_,_), do: raise RaiseNotVector

	def scale(v1 = %Vector{}, alpha) do
		%Vector{x: v1.x*alpha, y: v1.y*alpha}
	end

	def scale(alpha, v = %Vector{}), do: scale(v, alpha)

	def scale(_,_), do: raise RaiseNotVector

	def module(d = %Vector{}) do
		Math.sqrt(Math.pow(d.x, 2) + Math.pow(d.y, 2))
	end

	def module(_), do: raise RaiseNotVector

end
