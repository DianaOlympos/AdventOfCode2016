defmodule Adventofcode2016.Solution.Day4 do
  alias Adventofcode2016.Solution.Helper


  def solve() do
    "day4.txt"
    |> Helper.load_input()
    |> String.split()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_full/1)
    |> Enum.filter_map(&valid?/1, &elem(&1,1))
    |> Enum.reduce(fn x, acc -> x + acc end)
  end


  def parse_full(input) do
    {room_id_and_checksum, name_list} =
      input
      |> String.split("-")
      |> Enum.partition(&String.ends_with?(&1, "]"))

    {room_id, checksum} = extract_id_and_checksum(room_id_and_checksum)
    name = Enum.flat_map(name_list, &String.to_charlist/1)

    {name, room_id, checksum}
  end

  def compute_checksum(name_list) do
    name_list
    |> Enum.sort()
    |> Enum.chunk_by(&(&1))
    |> Enum.sort_by(&(- Kernel.length(&1)))
    |> Enum.flat_map(&Enum.dedup/1)
    |> Enum.take(5)
    |> List.to_string()
  end

  def extract_id_and_checksum([room_id_and_checksum]) do
    [string_id, checksum_with_bracket] = String.split(room_id_and_checksum, "[")
    checksum = String.trim_trailing(checksum_with_bracket, "]")

    room_id = String.to_integer(string_id)
    {room_id, checksum}
  end

#TODO check that one...
  def valid?({name, _room_id, checksum}) do
    computed = IO.inspect(compute_checksum(name))
    computed == checksum
  end
end