defmodule Adventofcode2016.Solution.Day2 do
  alias Adventofcode2016.Solution.Helper
  def solve() do
    "day2.txt"
    |> Helper.load_input()
    |> walk_keypad()
    |> IO.inspect()
  end

  defp walk_keypad(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&read_movements/1)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reduce({1,1,[]}, &walk_line/2)
    |> elem(2)
    |> Enum.map(&to_tag/1)
    |> Enum.reverse()
    |> Enum.join()
  end

  defp read_movements(""), do: []
  defp read_movements("L"<>rest), do: [:L| read_movements(rest)]
  defp read_movements("R"<>rest), do: [:R| read_movements(rest)]
  defp read_movements("U"<>rest), do: [:U| read_movements(rest)]
  defp read_movements("D"<>rest), do: [:D| read_movements(rest)]

  defp walk_line([], {x,y, eol_position}), do: {x,y, [{x,y}| eol_position]}
  defp walk_line([movement|tail], {x, y, eol_position}) do
    {new_x, new_y} = move(movement, x, y)
    walk_line(tail, {new_x, new_y, eol_position})
  end

@doc """
y\\x 0 1 2
0   1 2 3
1   4 5 6
2   7 8 9
"""
  defp move(:L, 0, y), do: {0, y}
  defp move(:R, 2, y), do: {2, y}
  defp move(:U, x, 0), do: {x, 0}
  defp move(:D, x, 2), do: {x, 2}

  defp move(:L, x, y), do: {x-1, y}
  defp move(:R, x, y), do: {x+1, y}
  defp move(:U, x, y), do: {x, y-1}
  defp move(:D, x, y), do: {x, y+1}

  defp to_tag({x,y}) do
    Integer.to_string(x+1+(y*3))
  end
end