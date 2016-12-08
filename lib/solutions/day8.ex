defmodule Adventofcode2016.Solution.Day8 do
  alias Adventofcode2016.Solution.Helper
  alias Adventofcode2016.Solution.CellServer

  def solve_part1() do

    CellServer.launch()
      "day8.txt"
      |> Helper.load_input()
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Stream.map(&extract_action/1)
      |> Enum.map(&CellServer.send_action/1)
      |> Enum.count()

    CellServer.result()
    |> IO.puts
  end

  def extract_action("rect "<>rectangle) do
    {a, b} =
      rectangle
      |> String.split("x")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    {:rect, a-1, b-1}
  end
  def extract_action("rotate row y="<> data) do
    {index, steps} =
      data
      |> String.split(" by ")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    {:row, index, steps}
  end
  def extract_action("rotate column x="<> data) do
    {index, steps} =
      data
      |> String.split(" by ")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    {:column, index, steps}
  end
end