defmodule AdventOfCode2024.Solutions.Y24.Day11 do
  alias AoC.Input
  use Agent

  def parse(input, _part) do
    Input.read!(input)
    |> String.split([" ", "\n"])
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
  end

  def part_one(problem) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)

    problem
    |> Stream.map(&blink(&1, 25))
    |> Enum.sum()
  end

  def part_two(problem) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)

    problem
    |> Stream.map(&blink(&1, 75))
    |> Enum.sum()
  end

  defp blink(num, blink_num) do
    memo_value = Agent.get(__MODULE__, &Map.get(&1, {num, blink_num}))

    cond do
      memo_value ->
        memo_value

      blink_num == 0 ->
        1

      num == 0 ->
        blink(1, blink_num - 1)

      rem(length(Integer.digits(num)), 2) != 0 ->
        blink(num * 2024, blink_num - 1)

      true ->
        digits = div(length(Integer.digits(num)), 2)
        half = :math.pow(10, digits) |> round

        res = blink(div(num, half), blink_num - 1) + blink(rem(num, half), blink_num - 1)

        Agent.update(__MODULE__, &Map.put(&1, {num, blink_num}, res))
        res
    end
  end
end
