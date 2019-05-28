try_helper = fn fun ->
  try do
    fun.()
    IO.puts("No error.")
  catch type, value ->
    IO.puts("Error\n #{inspect(type)}\n #{inspect(value)}")
  end
end

try_helper.(fn -> raise("something went wrong") end)

try_helper.(fn -> :erlang.error("something went wrong") end)
