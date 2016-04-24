defmodule BernacleServer.Entity do
	alias BernacleServer.Entity

	defstruct id: 0, attributes: %{}, abilities: %{}

	def start_link(en = %Entity{}), do: Agent.start_link(fn -> en end)

	def get_ability(%Entity{abilities: abi}, key), do: Map.get(abi, key)

	def do_ability(en = %Entity{}, ability, params) do
		case get_ability(en, ability) do
			nil -> en
			module -> apply(module, ability, [en | params] )
		end
	end

	def new, do: %Entity{}

	def get_attribute(%Entity{attributes: attr}, key), do: Map.get(attr, key)

	def set_attribute(en = %Entity{attributes: attr}, key, val) do
		Map.put(en, :attributes, Map.put(attr, key, val))
	end

	def give_ability(en = %Entity{abilities: abi}, ability, resp) do
		Map.put(en, :abilities, Map.put(abi, ability, resp))
	end

	def kill(agent), do: Agent.stop(agent)

	def do_ability(agent, ability, params) do
		Agent.update(
			agent,
			fn entity -> do_ability(entity, ability, params) end
		)
	end

	def get_ability(agent, key) do
		Agent.get(agent, fn entity -> get_ability(entity, key) end)
	end

	def get_entity(agent) do
		Agent.get(agent, fn entity -> entity end)
	end

end
