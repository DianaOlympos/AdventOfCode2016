defmodule Adventofcode2016.Solution.Day1 do
  alias Adventofcode2016.Solution.Struct.Position

  @input "L1, L3, L5, L3, R1, L4, L5, R1, R3, L5, R1, L3, L2, L3, R2, R2, L3, L3, R1, L2, R1, L3, L2, R4, R2, L5, R4, L5, R4, L2, R3, L2, R4, R1, L5, L4, R1, L2, R3, R1, R2, L4, R1, L2, R3, L2, L3, R5, L192, R4, L5, R4, L1, R4, L4, R2, L5, R45, L2, L5, R4, R5, L3, R5, R77, R2, R5, L5, R1, R4, L4, L4, R2, L4, L1, R191, R1, L1, L2, L2, L4, L3, R1, L3, R1, R5, R3, L1, L4, L2, L3, L1, L1, R5, L4, R1, L3, R1, L2, R1, R4, R5, L4, L2, R4, R5, L1, L2, R3, L4, R2, R2, R3, L2, L3, L5, R3, R1, L4, L3, R4, R2, R2, R2, R1, L4, R4, R1, R2, R1, L2, L2, R4, L1, L2, R3, L3, L5, L4, R4, L3, L1, L5, L3, L5, R5, L5, L4, L2, R1, L2, L4, L2, L4, L1, R4, R4, R5, R1, L4, R2, L4, L2, L4, R2, L4, L1, L2, R1, R4, R3, R2, R2, R5, L1, L2"

  def solve() do
    position =
      %Position{}
      |> insert_zero()

    @input
    |> split_input()
    |> move(position)
    |> calculate_distance()
    |> IO.puts()
  end

  defp calculate_distance(%Position{x: x, y: y}) do
    abs(x) + abs(y)
  end

  defp move(_list, %Position{stopped: true} = position) do
    position
  end

  defp move([], position) do
    position
  end

  defp move([{rotation, steps}| tail], position) do
    new_position =
      position
      |> rotate(rotation)
      |> jumping(steps)
    move(tail, new_position)
  end

  defp rotate(%Position{direction: :W} = position, :L), do: %{position | direction: :S}
  defp rotate(%Position{direction: :N} = position, :L), do: %{position | direction: :W}
  defp rotate(%Position{direction: :S} = position, :L), do: %{position | direction: :E}
  defp rotate(%Position{direction: :E} = position, :L), do: %{position | direction: :N}

  defp rotate(%Position{direction: :N} = position, :R), do: %{position | direction: :E}
  defp rotate(%Position{direction: :E} = position, :R), do: %{position | direction: :S}
  defp rotate(%Position{direction: :S} = position, :R), do: %{position | direction: :W}
  defp rotate(%Position{direction: :W} = position, :R), do: %{position | direction: :N}

  defp jumping(%Position{direction: :N, x: x ,y: y} = position, steps), do: Enum.map((y+1)..(y+steps), &{x, &1}) |> moving(position)
  defp jumping(%Position{direction: :S, x: x ,y: y} = position, steps), do: Enum.map((y-1)..(y-steps), &{x, &1}) |> moving(position)
  defp jumping(%Position{direction: :E, x: x, y: y} = position, steps), do: Enum.map((x+1)..(x+steps), &{&1, y}) |> moving(position)
  defp jumping(%Position{direction: :W, x: x, y: y} = position, steps), do: Enum.map((x-1)..(x-steps), &{&1, y}) |> moving(position)

  defp moving([], position) do
    position
  end

  defp moving([coordinate = {x,y}|tail], %Position{visited: set} = position) do
    if MapSet.member?(set, coordinate) do
      %{position| x: x, y: y, stopped: true}
    else
      moving(tail,%{position| visited: MapSet.put(set, coordinate), x: x, y: y})
    end
  end

  defp split_input(string) do
    string
    |> String.split(", ")
    |> Enum.map(&parse/1)
  end

  defp parse("L" <> n), do: {:L, String.to_integer(n)}
  defp parse("R" <> n), do: {:R, String.to_integer(n)}

  defp insert_zero(%Position{visited: mapset} = position) do
    %{position| visited: MapSet.put(mapset, {0,0})}
  end
end