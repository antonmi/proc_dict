defmodule Cell do

  def new(data) do
    spawn(__MODULE__, :init, [data])
  end

  def init(data) do
    receive do
      {pid, :set, new_data} ->
        send(pid, {self, :ok})
        init(new_data)
      {pid, :get} ->
        send(pid, {self, data})
      any -> IO.inspect "Cell #{self} received #{any} and died"
    end
  end

  def get(cell) do
    send(cell, {self, :get})
    receive do
      {^cell, data} -> data
    end
  end

  def set(cell, data) do
    send(cell, {self, :set, data})
    receive do
      {^cell, :ok} -> :ok
    end
  end

end