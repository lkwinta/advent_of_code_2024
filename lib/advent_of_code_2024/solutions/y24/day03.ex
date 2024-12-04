defmodule AdventOfCode2024.Solutions.Y24.Day03 do
  alias AoC.Input

  def parse(input, :part_one) do
    Regex.scan(~r"mul\(\d{1,3},\d{1,3}\)", Input.read!(input))
    |> Enum.map(&parse_str/1)
  end

  def parse(input, :part_two) do
    Regex.scan(~r"mul\(\d{1,3},\d{1,3}\)|don't\(\)|do\(\)", Input.read!(input))
    |> Enum.map(&parse_str/1)
  end

  defp parse_str(["don't()"]), do: :dont
  defp parse_str(["do()"]), do: :do

  defp parse_str([mul_expr]) do
    [[x], [y]] = Regex.scan(~r"\d+", mul_expr)
    {x, _} = Integer.parse(x)
    {y, _} = Integer.parse(y)
    x * y
  end

  def part_one(problem) do
    problem
    |> Enum.sum()
  end

  def part_two(problem) do
    sump(problem, :on)
  end

  defp sump([], _), do: 0
  defp sump([:dont | list], _), do: sump(list, :off)
  defp sump([:do | list], _), do: sump(list, :on)
  defp sump([h | list], :on), do: h + sump(list, :on)
  defp sump([_ | list], :off), do: sump(list, :off)
end
