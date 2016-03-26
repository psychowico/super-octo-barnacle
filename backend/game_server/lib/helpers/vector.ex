defmodule BernacleServer.Helpers.RaiseNotVector do
	defexception message: "One of arguments is not Vector"
end

defmodule BernacleServer.Helpers.Vector do

	alias :math, as: Math
	alias BernacleServer.Helpers.{Vector, RaiseNotVector}

	defstruct x: 0.0, y: 0.0

	def new(x, y), do: %Vector{x: x, y: y}

	def distance(v1 = %Vector{}, v2 = %Vector{}) do
		Math.sqrt(Math.pow(v1.x - v2.x, 2) + Math.pow(v1.y - v2.y, 2))
	end

	def distance(_, _), do: raise  RaiseNotVector

	def sum(v1 = %Vector{}, v2 = %Vector{}) do
		%Vector{x: v1.x + v2.x, y: v1.y + v2.y}
	end

	def sum(_, _), do: raise RaiseNotVector

	def scale(v = %Vector{}, alpha) do
		%Vector{x: v.x * alpha, y: v.y * alpha}
	end

	def scale(alpha, v = %Vector{}), do: scale(v, alpha)

	def scale(_, _), do: raise RaiseNotVector

	def module(v = %Vector{}) do
		Math.sqrt(Math.pow(v.x, 2) + Math.pow(v.y, 2))
	end

	def normalize_vector(v = %Vector{}) do
		scale(v, 1 / module(v))
	end

	def module(_), do: raise RaiseNotVector

end

#implementation of IO.inspect for Vector (pretty vector in console)
defimpl Inspect, for: BernacleServer.Helpers.Vector do
	def inspect(%BernacleServer.Helpers.Vector{x: x, y: y}, _) do
		"{x: " <> inspect(x) <> ", y: " <> inspect(y) <> "}"
	end
end
