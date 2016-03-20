defmodule Entity do
	defstruct id: 0,
		attriutes: %{},
		abilities: %{},

	def start_link, do Agent.start_link(fn -> %Entity{} end) end
	def kill(en), do Agent.stop(en)
	def get_attribute(en = %Entity{attriutes: attr}, key), do Map.get(attr,key)
	def set_attribute(en = %Entity{attriutes: attr}, key, val), do Map.put(en, attriutes:, Map.put(attr, key, val))
	def give_ability(en = %Entity{abilities: abi}, ability, resp), do Map.put(en, abilities: ,Map.put(abi, ability, resp)) 
	def get_ability(en = %Entity{abilities: abi}, key), do Map.get(abi,key)

	def do_ability(agent, ability, params) do 
		Agent.update(agent, fn entity -> do_ability(entity, ability, params))
	end

	def do_ability(en = %Entity{}, ability, params)
		case get_ability(en, ability) do
			nil -> en
			module -> apply(module ,ability, [en | params] )
		end
	end
end
