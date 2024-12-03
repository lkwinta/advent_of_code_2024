defmodule AdventOfCode2024.Solutions.Y24.Day02 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn x ->
      x
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(&elem(&1, 0))
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.filter(&(is_asc(&1) or is_desc(&1)))
    |> length
  end

  def part_two(problem) do
    problem
    |> Enum.map(&try_all/1)
    |> Enum.count(&(&1 == true))
  end

  defp try_all(list), do: try_all([], list)
  defp try_all(_, []), do: false

  defp try_all(left, [head | list]) do
    new_list = left ++ list

    if is_asc(new_list) or is_desc(new_list) do
      true
    else
      try_all(left ++ [head], list)
    end
  end

  defp is_asc([head | list]), do: is_asc(list, head)
  defp is_asc([]), do: true
  defp is_asc([], _), do: true

  defp is_asc([head | list], last) when head - last >= 1 and head - last <= 3,
    do: is_asc(list, head)

  defp is_asc([_head | _list], _), do: false

  defp is_desc([head | list]), do: is_desc(list, head)
  defp is_desc([]), do: true
  defp is_desc([], _), do: true

  defp is_desc([head | list], last) when last - head >= 1 and last - head <= 3,
    do: is_desc(list, head)

  defp is_desc([_head | _list], _), do: false
end
