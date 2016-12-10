defmodule Adventofcode2016.Solution.Day10 do
  alias Adventofcode2016.Solution.Helper
  alias Adventofcode2016.Solution.Day10.Bot
  alias Adventofcode2016.Solution.Day10.BotRegistry

  def solve() do

    BotRegistry.launch()

      "day10.txt"
      |> Helper.load_input()
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split/1)
      |> Enum.map(&parse_action/1)
      |> Enum.map(&Bot.send_action/1)

      ("Answer for part 1: " <>Atom.to_string(BotRegistry.find_value()))
      |> IO.puts

      [:output0, :output1, :output2]
      |> Enum.flat_map(&Bot.get_output_value/1)
      |> Enum.reduce(fn x, acc -> x*acc end)
      |> Integer.to_string()
      |> IO.puts()

  end

  def parse_action(["bot", actor, "gives", "low", "to", output_bot_low, int_target_low, "and", "high", "to", output_bot_high, int_target_high | _rest]) do
    target_low = extract_target(output_bot_low, int_target_low)
    target_high = extract_target(output_bot_high, int_target_high)
    bot = extract_target("bot", actor)
    {:give, bot, target_low, target_high}
  end
  def parse_action(["value", chip_number, "goes", "to", "bot", actor_target |_rest]) do
    {:input, extract_target("bot",actor_target), String.to_integer(chip_number)}
  end

  def extract_target(type, number) do
    String.to_atom(type<>number)
  end
end

defmodule Adventofcode2016.Solution.Day10.Bot do
  use GenServer
  alias Adventofcode2016.Solution.Day10.BotRegistry

  #Client API
  def send_action({:give, actor, _target_low, _target_high} = action) do
    if GenServer.whereis(actor) == nil do
      GenServer.start(__MODULE__, [], name: actor)
      BotRegistry.register(actor)
    end
    GenServer.call(actor, action)
  end

  def send_action({:input, actor, _chip_number} = action) do
    if GenServer.whereis(actor) == nil do
      GenServer.start(__MODULE__, [], name: actor)
      BotRegistry.register(actor)
    end
    GenServer.call(actor, action)
  end

  def get_output_value(output) do
    GenServer.call(output, :value)
  end

  #Server Callbacks

  def init(_args) do
    {:ok, {[],[]}}
  end

  def handle_call({:input, actor, chip_number}, _from, {values, actions}) do
    state = act_on_action(values ++ [chip_number], actions)
    {:reply, actor, state}
  end

  def handle_call({:give, actor, _target_low, _target_high} = new_action, _from, {values, actions}) do
    state = act_on_action(values, actions ++ [new_action])
    {:reply, actor, state}
  end

  def handle_call(:value, _from, {value, _actions} = state) do
    {:reply, value, state}
  end

  defp act_on_action([value1, value2 |rest], [{:give, actor, target_low, target_high}| action_rest]) do
    if value1 in [61,17] and value2 in [61,17] do
      BotRegistry.send_answer(actor)
    end

    {value_high, value_low} =
      if value1>value2 do
        {value1, value2}
      else
        {value2, value1}
      end

    send_action({:input, target_low, value_low})
    send_action({:input, target_high, value_high})
    {rest, action_rest}
  end
  defp act_on_action(values, actions), do: {values, actions}
end

defmodule Adventofcode2016.Solution.Day10.BotRegistry do
  use GenServer

  def launch() do
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def register(actor) do
    GenServer.call(__MODULE__, {:register, actor})
  end

  def send_answer(actor) do
    GenServer.call(__MODULE__, {:answer, actor})
  end

  def find_value() do
    GenServer.call(__MODULE__, :find)
  end

  #Callback
  def init(_state) do
    {:ok, {[], nil}}
  end

  def handle_call({:register, actor}, _from, {list, something}) do
    {:reply, :ok, {[actor|list], something}}
  end

  def handle_call(:find, _from, {_list, answer} = state) do
    IO.inspect(answer)
    {:reply, answer, state}
  end

  def handle_call({:answer, actor}, _from, {list, _something}) do
    {:reply, :ok, {list, actor}}
  end

end