defmodule Adventofcode2016.Solution.Day6 do
  alias Adventofcode2016.Solution.Helper

  def solve_part1() do
      "day6.txt"
      |> Helper.load_input()
      |> String.split()
      |> Enum.map(&String.to_charlist/1)
      |> Enum.reduce([], &extract_most_used_char/2)
      |> Enum.map(&Enum.max_by(&1, fn {_char, count} -> count end))
      |> Enum.map(&elem(&1, 0))
      |> IO.puts
  end

  def extract_most_used_char([], []), do: []
  def extract_most_used_char(list, []) do
    acc =
      Stream.cycle([%{}])
      |> Enum.take(length(list))
    extract_most_used_char(list, acc)
  end

  def extract_most_used_char([head_char|tail_char], [head_acc|tail_acc]) do
    updated_map = Map.update(head_acc, head_char, 1, &(&1 + 1))
    [updated_map|extract_most_used_char(tail_char, tail_acc)]
  end

  def solve_part2() do
      "day6.txt"
      |> Helper.load_input()
      |> String.split()
      |> Enum.map(&String.to_charlist/1)
      |> Enum.reduce([], &extract_most_used_char/2)
      |> Enum.map(&Enum.min_by(&1, fn {_char, count} -> count end))
      |> Enum.map(&elem(&1, 0))
      |> IO.puts
  end
end