defmodule Calculator do
  def start do
    spawn(fn ->
      loop(0)
    end)
  end

  def value(pid) do
    send(pid, {:value, self()})
    
    receive do
      {:ok, value} -> value
    end
  end

  def add(pid, num) do
    send(pid, {:add, num})
  end

  def sub(pid, num) do
    send(pid, {:sub, num})
  end

  def mul(pid, num) do
    send(pid, {:mul, num})
  end

  def div(pid, num) do
    send(pid, {:div, num})
  end

  defp loop(value) do
    receive do
      {:add, num} ->
        loop(value + num)
      {:sub, num} ->
        loop(value - num)
      {:mul, num} ->
        loop(value * num)
      {:div, num} ->
        loop(value / num)
      {:value, sender} ->
        send(sender, {:ok, value})
    end
  end
end
