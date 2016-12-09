defmodule Adventofcode2016.Solution.Day9 do
  alias Adventofcode2016.Solution.Helper

  def solve_part1() do
    "day9.txt"
    |> Helper.load_input()
    |> String.trim()
    |> compute_length()
    |> IO.puts
  end

  def compute_length(<<>>), do: 0
  def compute_length(<<_a::utf8>>), do: 1
  def compute_length("("<>rest_with_marker) do
    {leftover, length} = parse_marker(rest_with_marker)
    (length + compute_length(leftover))
  end
  def compute_length(<<_a::utf8, rest::binary>>), do: (1 + compute_length(rest))

  def parse_marker(binary) do
    {part2_to_parse, number_to_ditch} = parse_marker(binary, "")
    {to_ditch, number_copy} = parse_marker(part2_to_parse, "")
    size = number_to_ditch*number_copy
    leftover = string_ditch(number_to_ditch, to_ditch)
    {leftover, size}
  end

  def parse_marker("x"<>rest, string_int), do: {rest, String.to_integer(string_int)}
  def parse_marker(")"<>rest, string_int), do: {rest, String.to_integer(string_int)}
  def parse_marker(<<a::utf8, rest::binary>>, string_int), do: parse_marker(rest, string_int<><<a>>)

  def string_ditch(0, rest), do: rest
  def string_ditch(int, <<_a::utf8, rest::binary>>), do: string_ditch(int-1, rest)

  def solve_part2() do
    "day9.txt"
    |> Helper.load_input()
    |> String.trim()
    |> compute_length_2()
    |> IO.puts
  end

  def compute_length_2(<<>>), do: 0
  def compute_length_2(<<_a::utf8>>), do: 1
  def compute_length_2("("<>rest_with_marker) do
    {leftover, length} = parse_marker_2(rest_with_marker)
    (length + compute_length_2(leftover))
  end
  def compute_length_2(<<_a::utf8, rest::binary>>), do: (1 + compute_length_2(rest))

  def parse_marker_2(binary) do
    {part2_to_parse, number_to_copy} = parse_marker(binary, "")
    {binary_to_parse, number_copy} = parse_marker(part2_to_parse, "")
    {to_compute, rest} = extract_and_expand(binary_to_parse, number_to_copy, number_copy)
    size = compute_length_2(to_compute)
    {rest, size}
  end

  def extract_and_expand(binary, to_copy, number_copy) do
    {to_expand, rest} = String.split_at(binary, to_copy)
    expanded = String.duplicate(to_expand, number_copy)
    {expanded, rest}
  end
end