defmodule Adventofcode2016.Day2Test do
  use ExUnit.Case
  alias Adventofcode2016.Solution.Day2

@test_input """
ULL
RRDDD
LURDL
UUUUD
"""

  test "test the exemple for day 2" do
    code = Day2.walk_keypad(@test_input)
    assert "1985" = code
  end

  test "test the diamond exemple for day 2" do
    code = Day2.walk_diamond(@test_input)
    assert "5DB3" = code
  end

end