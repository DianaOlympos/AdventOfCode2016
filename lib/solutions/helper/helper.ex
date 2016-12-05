defmodule Adventofcode2016.Solution.Helper do
  def load_input(day) do
    Path.join(Application.app_dir(:adventofcode2016, "priv"), day)
    |> File.read!()
  end
end