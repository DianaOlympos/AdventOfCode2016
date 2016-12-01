defmodule Adventofcode2016.Solution.Struct.Position do
  defstruct [
    direction: :N,
    x: 0,
    y: 0,
    visited: MapSet.new(),
    stopped: false
  ]
end