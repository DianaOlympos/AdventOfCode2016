defmodule Adventofcode2016.Solution.Day5 do
  alias Adventofcode2016.Solution.Helper

  def solve_part1(input) do
    input
    |> String.trim()
    |> Stream.iterate(&(&1))
    |> Stream.with_index()
    |> Stream.map(&into_io_list/1)
    |> Stream.map(&(:crypto.hash(:md5, &1)))
    |> Stream.flat_map(&extracting_member_part1/1)
    |> Enum.take(8)
  end

  def extracting_member_part1(<<0::integer-size(20), x::integer-size(4), _rest::bitstring>>) do
    "0"<> character = Base.encode16(<<0::integer-size(4), x::integer-size(4)>>)
    [character]
  end

  def extracting_member_part1(_), do: []

  def into_io_list({string, index}), do: [string, Integer.to_string(index)]

  def solve_part2(input) do
    input
    |> String.trim()
    |> Stream.iterate(&(&1))
    |> Stream.with_index()
    |> Stream.map(&into_io_list/1)
    |> Stream.map(&(:crypto.hash(:md5, &1)))
    |> Stream.map(&extracting_member_part2/1)
    |> Enum.reduce_while(%{}, &build_result/2)
  end

  def extracting_member_part2(<<0::integer-size(21), position::integer-size(3), x::integer-size(4), _rest::bitstring>>) do
    "0"<> character = Base.encode16(<<0::integer-size(4), x::integer-size(4)>>)
    {position,character}
  end

  def extracting_member_part2(_), do: nil

  def build_result({index, character}, acc) when index in 0..7 do
    size_map = length(Map.keys(acc))
    if size_map == 8 do
      {:halt, extract_result(acc)}
    else
      {:cont, Map.put_new(acc, index, character)}
    end
  end

  def build_result(_, acc), do: {:cont, acc}

  def extract_result(map) do
    map
    |> Map.to_list()
    |> Enum.sort(&(elem(&1,0) < elem(&2, 0)))
    |> Enum.map(&(elem(&1,1)))
  end

end