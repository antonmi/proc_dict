defmodule ProcDict do
  use GenServer
  use Dict

  def new do
    {:ok, pid} = GenServer.start_link(__MODULE__, [])
    pid
  end

  def init(_args) do
    state = %{dict: HashDict.new}
    {:ok, state}
  end

  def put(pid, key, value) do
    GenServer.call(pid, {:put, key, value})
  end

  def fetch(pid, key) do
    GenServer.call(pid, {:fetch, key})
  end

  def delete(pid, key) do
    GenServer.call(pid, {:delete, key})
  end

  def size(pid) do
    GenServer.call(pid, :size)
  end

  def reduce(pid, acc, fun) do
    GenServer.call(pid, {:reduce, acc, fun})
  end


  def handle_call({:put, key, value}, _pid, state) do
    dict = state[:dict]
    cell = HashDict.get(dict, key)
    if cell do
      Cell.set(cell, value)
    else
      cell = Cell.new(value)
      dict = HashDict.put(dict, key, cell)
      state = %{state | dict: dict}
    end
    {:reply, self, state}
  end

  def handle_call({:fetch, key}, _pid, state) do
    dict = state[:dict]
    cell = HashDict.get(dict, key)
    value = if cell, do: {:ok, Cell.get(cell)}, else: :error
    {:reply, value, state}
  end

  def handle_call({:delete, key}, _pid, state) do
    dict = state[:dict]
    cell = HashDict.get(dict, key)
    if cell do
      Process.exit(cell, :kill)
      dict = HashDict.delete(dict, key)
      state = %{state | dict: dict}
    end
    {:reply, self, state}
  end

  def handle_call(:size, _pid, state) do
    size = HashDict.size(state[:dict])
    {:reply, size, state}
  end

  def handle_call({:reduce, acc, fun}, _pid, state) do
    dict = state[:dict]
    result = Enum.reduce(dict, acc, fn({key, cell}, local_acc) ->
      value = Cell.get(cell)
      fun.({key, value}, local_acc)
    end)
    {:reply, result, state}
  end
end
