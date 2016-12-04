defmodule Adventofcode2016.Solution.Helper do
  def load_input(day) do
    Path.join(:code.priv_dir(:adventofcode2016), day)
    |> File.read!()
  end
end