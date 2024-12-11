defmodule AdventOfCode2024.Solutions.Y24.Day11 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split([" ", "\n"])
    |> Enum.filter(& &1 != "")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(& elem(&1, 0))
    |> IO.inspect()
  end

  def part_one(problem) do
    problem |> iterate(25, &blink/1) |> length()
  end

  def part_two(problem) do
    problem |> iterate(75, &blink/1) |> length()
  end

  def iterate(list, num, _) when num == 0, do: list
  def iterate(list, num, fun) when num > 0 do
    iterate(fun.(list), num - 1, fun)
  end

  defp blink(list), do: blink(list, [])

  defp blink([], result), do: result
  defp blink([0 | list], result), do: blink(list, [1 | result])
  defp blink([element | list], result) do
    if rem(length(Integer.digits(element)), 2) != 0 do
      blink(list, [element*2024 | result])
    else
      digits = Integer.digits(element)
      half = div(length(digits), 2)

      left_half = Integer.undigits(digits |> Enum.take(half))
      right_half = Integer.undigits(digits |> Enum.drop(half))

      blink(list, [left_half, right_half | result])
    end
  end
end
