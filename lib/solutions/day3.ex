defmodule Adventofcode2016.Solution.Day3 do
  alias Adventofcode2016.Solution.Helper

  def solve_part1() do
    "day3.txt"
    |> Helper.load_input()
    |> String.split()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk(3)
    |> Enum.count(&triangle?/1)
  end

  def solve_part2() do
    "day3.txt"
    |> Helper.load_input()
    |> String.split()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.sort_by(fn {_side, index} -> rem(index, 3) end)
    |> Enum.unzip()
    |> elem(0)
    |> Enum.chunk(3)
    |> Enum.count(&triangle?/1)
  end

  def triangle?([x, y, z]) when x+y > z and x+z > y and y+z > x, do: true
  def triangle?(_), do: false
end