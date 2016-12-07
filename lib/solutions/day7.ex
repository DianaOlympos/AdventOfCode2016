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
  def valid?(<<a::utf8, b::utf8, b::utf8, a::utf8>> <> rest, _) when a != b and a != ?[ and b != ?[ do
    valid?(rest, true)
  end
  def valid?(<<_a::utf8>> <> rest, false), do: valid?(rest, false)

  def bracket_validation("]"<>rest), do: {rest, :valid}
  def bracket_validation(<<a::utf8, b::utf8, b::utf8, a::utf8, rest::binary>>) when a != b, do: {rest, :not_valid}
  def bracket_validation(<<_a::utf8>> <> rest), do: bracket_validation(rest)
end