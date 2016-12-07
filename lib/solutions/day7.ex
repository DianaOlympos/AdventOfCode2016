defmodule Adventofcode2016.Solution.Day7 do
  alias Adventofcode2016.Solution.Helper

  def solve_part1() do
    "day7.txt"
    |> Helper.load_input()
    |> String.split()
    |> Enum.count(&valid?(&1, false))
    |> IO.puts
  end

  def valid?(<<>>, validity), do: validity
  def valid?("["<> rest, validity) do
    case bracket_validation(rest) do
      {_, :not_valid} -> false
      {new_rest, :valid} -> valid?(new_rest, validity)
    end
  end
  def valid?(<<_a::utf8>> <> rest, true), do: valid?(rest, true)
  def valid?(<<a::utf8, b::utf8, b::utf8, a::utf8>> <> rest, _) when a != b do
    valid?(rest, true)
  end
  def valid?(<<_a::utf8>> <> rest, false), do: valid?(rest, false)

  def bracket_validation("]"<>rest), do: {rest, :valid}
  def bracket_validation(<<a::utf8, b::utf8, b::utf8, a::utf8, rest::binary>>) when a != b, do: {rest, :not_valid}
  def bracket_validation(<<_a::utf8>> <> rest), do: bracket_validation(rest)

  def solve_part2() do
    "day7.txt"
    |> Helper.load_input()
    |> String.split()
    |> Enum.count(&valid_ssl?(&1, MapSet.new(), MapSet.new()))
    |> IO.puts
  end

  def valid_ssl?(<<>>, set_outside, set_inside) do
    set_outside != MapSet.new()
    && set_inside != MapSet.new()
    && not MapSet.disjoint?(set_outside, set_inside)
  end
  def valid_ssl?("["<> rest, set_outside, set_inside) do
    {new_rest, new_set} = search_triplets(rest, set_inside)
    valid_ssl?(new_rest, set_outside, new_set)
  end
  def valid_ssl?(<<a::utf8, b::utf8, a::utf8>> <> rest, set_outside, set_inside)
                  when a != b
                  and b != ?[ do
    new_rest = <<b, a>> <> rest
    new_set_outside = MapSet.put(set_outside, <<b,a,b>>)
    valid_ssl?(new_rest,new_set_outside, set_inside)
  end
  def valid_ssl?(<<_a::utf8>> <> rest, set_outside, set_inside), do: valid_ssl?(rest, set_outside, set_inside)

  def search_triplets("]"<>rest, set_inside), do: {rest, set_inside}
  def search_triplets(<<a::utf8, b::utf8, a::utf8>> <> rest , set_inside)
                  when a != b
                  and b != ?] do
    new_rest = <<b, a>> <> rest
    new_set_inside = MapSet.put(set_inside, <<a, b, a>>)
    search_triplets(new_rest, new_set_inside)
  end
  def search_triplets(<<_a::utf8>> <> rest, set_inside), do: search_triplets(rest, set_inside)

end