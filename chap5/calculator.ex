# First crack
#defmodule Calculator do
#  def start do
#    spawn(fn ->
#      loop(0)
#    end)
#  end
#
#  def value(pid) do
#    send(pid, {:value, self()})
#
#    receive do
#      {:ok, value} -> value
#    end
#  end
#
#  def add(pid, num) do
#    send(pid, {:add, num})
#  end
#
#  def sub(pid, num) do
#    send(pid, {:sub, num})
#  end
#
#  def mul(pid, num) do
#    send(pid, {:mul, num})
#  end
#
#  def div(pid, num) do
#    send(pid, {:div, num})
#  end
#
#  defp loop(value) do
#    receive do
#      {:add, num} ->
#        loop(value + num)
#      {:sub, num} ->
#        loop(value - num)
#      {:mul, num} ->
#        loop(value * num)
#      {:div, num} ->
#        loop(value / num)
#      {:value, sender} ->
#        send(sender, {:ok, value})
#    end
#  end
#end

defmodule Calculator do
  def start do
    spawn(fn ->
      loop(0)
    end)
  end

  def value(server_pid) do
    send(server_pid, {:value, self()})

    receive do
      {:response, value} -> value
    end
  end

  def add(server_pid, num), do: send(server_pid, {:add, num})
  def sub(server_pid, num), do: send(server_pid, {:sub, num})
  def mul(server_pid, num), do: send(server_pid, {:mul, num})
  def div(server_pid, num), do: send(server_pid, {:div, num})

  defp loop(current_value) do
    new_value =
      receive do
        {:value, caller} ->
          send(caller, {:response, current_value})
          current_value
        {:add, num} -> current_value + num
        {:sub, num} -> current_value - num
        {:mul, num} -> current_value * num
        {:div, num} -> current_value / num

        invalid_request ->
          IO.puts("invalid request #{inspect invalid_request}")
          current_value
      end

    loop(new_value)
  end
end
