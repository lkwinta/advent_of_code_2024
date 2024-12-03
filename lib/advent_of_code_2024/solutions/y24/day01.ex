defmodule AdventOfCode2024.Solutions.Y24.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    parsed_list =
      Input.read!(input)
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.split(&1, "\s\s\s"))
      |> Enum.map(fn [x, y] -> {Integer.parse(x), Integer.parse(y)} end)

    list_left = for {{x, _}, _} <- parsed_list, do: x
    list_right = for {_, {y, _}} <- parsed_list, do: y

    {
      list_left,
      list_right
    }
  end

  def part_one(problem) do
    {list_left, list_right} = problem

    list_left = Enum.sort(list_left, :asc)
    list_right = Enum.sort(list_right, :asc)

    List.zip([list_left, list_right])
    |> Enum.map(fn {x, y} -> abs(x - y) end)
    |> Enum.sum()
  end

  def part_two(problem) do
    {list_left, list_right} = problem

    counts =
      list_left
      |> Enum.map(&count_occurrences(list_right, &1))

    List.zip([list_left, counts])
    |> Enum.map(fn {x, y} -> x * y end)
    |> Enum.sum()
  end

  defp count_occurrences([], _), do: 0

  defp count_occurrences([elem | list], value) when elem == value,
    do: count_occurrences(list, value) + 1

  defp count_occurrences([_ | list], value), do: count_occurrences(list, value)
end
