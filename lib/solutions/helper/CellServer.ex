defmodule Adventofcode2016.Solution.CellServer do
  alias Adventofcode2016.Solution.Struct.Cell
  use GenServer

  @wide_size 49
  @tall_size 5


  #Client
  def launch() do
      for x <- 0..@wide_size, y <- 0..@tall_size do
        start_cell(x, y)
      end
  end

  def start_cell(x,y) do
    initial = %Cell{x: x, y: y}
    name = cell_name(x,y)
    GenServer.start(__MODULE__, initial, name: name)
  end

  def send_action({:rect, width, tall}) do
      for x <- 0..width, y <-0..tall do
        GenServer.call(cell_name(x,y), :lit)
      end
  end
  def send_action({:row, index, steps}) do
      0..@wide_size
      |> Enum.map(&cell_name(&1, index))
      |> Enum.map(&GenServer.call(&1, {:row, steps}))
      |> Enum.reject(&(&1==:nook))
      |> Enum.map(&GenServer.call(&1, :lit))
  end
  def send_action({:column, index, steps}) do
    0..@tall_size
      |> Enum.map(&cell_name(index, &1))
      |> Enum.map(&GenServer.call(&1, {:column, steps}))
      |> Enum.reject(&(&1==:nook))
      |> Enum.map(&GenServer.call(&1, :lit))
  end

  def cell_name(x,y), do: String.to_atom("#{x}_#{y}")

  def result() do
    status =
      for y <- 0..@tall_size, x <- 0..@wide_size do
        %Cell{state: state} = GenServer.call(cell_name(x,y), :status)
        {x, y, state}
      end

    to_print = Enum.group_by(status, fn {_, y, _}-> y end, fn {x, _, state} -> { x, state} end)
    for y <- 0..@tall_size do
      to_print[y]
      |> Enum.sort(fn {x1, _state1}, {x2, _state2} -> x1<x2 end)
      |> Enum.map(fn {_x, state} -> state end)
      |> Enum.map(fn state -> if state==:lit, do: "x", else: " " end)
      |> IO.puts()
    end
    Enum.count(status, &(elem(&1,2)==:lit))
  end


# Server
  def init(initial) do
    {:ok, initial}
  end

  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:lit, _from, state) do
    new_state = %{state|state: :lit}
    {:reply, :ok, new_state}
  end
  def handle_call(:dim, _from, state) do
    new_state = %{state|state: :dim}
    {:reply, :ok, new_state}
  end

  def handle_call({_, _}, _from, %Cell{state: :dim} = state) do
    {:reply, :nook, state}
  end
  def handle_call({:row, steps}, _from, state) do
    to_lit = rem(state.x + steps, (@wide_size+1))
    answer = cell_name(to_lit, state.y)
    new_state = %{state| state: :dim}
    {:reply, answer, new_state}
  end
  def handle_call({:column, steps}, _from, state) do
    to_lit = rem(state.y + steps, (@tall_size+1))
    answer = cell_name(state.x, to_lit)
    new_state = %{state| state: :dim}
    {:reply, answer, new_state}
  end
end