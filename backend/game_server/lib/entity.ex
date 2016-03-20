defmodule Entity do

	defstruct id: 0, attriutes: %{}, abilities: %{}

	# def start_link, do Agent.start_link(fn -> %Entity{} end) end
	def start_link(en = %Entity{}), do: Agent.start_link(fn -> en end) 
	def start_link(), do: Agent.start_link(fn -> %Entity{} end)
	
	def kill(en), do: Agent.stop(en)

	def get_attribute(%Entity{attriutes: attr}, key), do: Map.get(attr, key)
	def get_ability(%Entity{abilities: abi}, key), do: Map.get(abi,key)
	def get_ability(agent, key) do
		Agent.get(agent, fn entity -> get_ability(entity,key) end)
	end

	def get_entity(agent) do
		Agent.get(agent, fn entity -> entity end)
	end

	def set_attribute(en = %Entity{attriutes: attr}, key, val) do 
		Map.put(en, :attriutes, Map.put(attr, key, val))
	end

	def give_ability(en = %Entity{abilities: abi}, ability, resp) do 
		Map.put(en, :abilities ,Map.put(abi, ability, resp)) 
	end

	def do_ability(en = %Entity{}, ability, params) do
		case get_ability(en, ability) do
			nil -> en
			module -> apply(module ,ability, [en | params] )
		end
	end

	def do_ability(agent, ability, params) do 
		Agent.update(agent, fn entity -> do_ability(entity, ability, params) end)
	end

	
end
