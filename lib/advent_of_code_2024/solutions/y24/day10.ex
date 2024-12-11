defmodule AdventOfCode2024.Solutions.Y24.Day10 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split(~r"\r\n|\r|\n")
    |> Stream.filter(&(&1 != ""))
    |> Stream.map(&to_charlist/1)
    |> build_grid()
  end

  defp build_grid(list) do
    for {row, i} <- Enum.with_index(list),
        {col, j} <- Enum.with_index(row),
        into: %{},
        do: {{i, j}, col}
  end

  def part_one(problem) do
    trailheads =
      problem
      |> Stream.filter(fn {_, value} -> value == ?0 end)
      |> Stream.map(&elem(&1, 0))
      |> Enum.to_list()

    trailheads
    |> Enum.map(&(find_trails(&1, problem, ?0 - 1) |> Enum.uniq() |> Enum.count()))
    |> Enum.sum()
  end

  def part_two(problem) do
    trailheads =
      problem
      |> Stream.filter(fn {_, value} -> value == ?0 end)
      |> Stream.map(&elem(&1, 0))
      |> Enum.to_list()

    trailheads
    |> Enum.map(&count_trails(&1, problem, ?0 - 1))
    |> Enum.sum()
  end

  defp find_trails(position, map, _) when not is_map_key(map, position), do: []

  defp find_trails(position, map, height)
       when :erlang.map_get(position, map) == ?9 and height == ?8,
       do: [position]

  defp find_trails({x, y}, map, prev_height)
       when :erlang.map_get({x, y}, map) == prev_height + 1 do
    height = map[{x, y}]

    find_trails({x + 1, y}, map, height) ++
      find_trails({x - 1, y}, map, height) ++
      find_trails({x, y + 1}, map, height) ++
      find_trails({x, y - 1}, map, height)
  end

  defp find_trails(_, _, _), do: []

  defp count_trails(position, map, _) when not is_map_key(map, position), do: 0

  defp count_trails(position, map, height)
       when :erlang.map_get(position, map) == ?9 and height == ?8,
       do: 1

  defp count_trails({x, y}, map, prev_height)
       when :erlang.map_get({x, y}, map) == prev_height + 1 do
    height = map[{x, y}]

    count_trails({x + 1, y}, map, height) +
      count_trails({x - 1, y}, map, height) +
      count_trails({x, y + 1}, map, height) +
      count_trails({x, y - 1}, map, height)
  end

  defp count_trails(_, _, _), do: 0
end
