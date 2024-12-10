defmodule AdventOfCode2024.Solutions.Y24.Day08 do
  alias AoC.Input

  def parse(input, _part) do
    map =
      Input.read!(input)
      |> String.split(~r"\r\n|\r|\n")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&to_charlist/1)
      |> build_grid()

    {max_x, max_y} = Map.keys(map) |> Enum.max()

    antennas =
      map
      |> Enum.filter(fn {_, value} -> value != ?. end)

    {antennas, {max_x, max_y}}
  end

  defp build_grid(list) do
    for {row, i} <- Enum.with_index(list),
        {col, j} <- Enum.with_index(row),
        into: %{},
        do: {{i, j}, col}
  end

  def part_one(problem) do
    {antennas, {max_x, max_y}} = problem

    Enum.map(antennas, fn antenna1 ->
      Enum.map(antennas, fn antenna2 ->
        get_antinodes(antenna1, antenna2)
      end)
    end)
    |> List.flatten()
    |> Stream.filter(&(&1 != nil))
    |> Stream.filter(fn {x, y} ->
      x >= 0 and y >= 0 and x <= max_x and y <= max_y
    end)
    |> Stream.uniq()
    |> Enum.count()
  end

  def part_two(problem) do
    {antennas, {max_x, max_y}} = problem

    Enum.map(antennas, fn antenna1 ->
      Enum.map(antennas, fn antenna2 ->
        get_antinodes_extended(antenna1, antenna2, {max_x, max_y})
      end)
    end)
    |> List.flatten()
    |> Stream.filter(&(&1 != nil))
    |> Stream.uniq()
    |> Enum.count()
  end

  defp get_antinodes({_, type1}, {_, type2}) when type1 != type2, do: nil
  defp get_antinodes({{x1, y1}, _}, {{x2, y2}, _}) when x1 == x2 and y1 == y2, do: nil

  defp get_antinodes({{x1, y1}, _}, {{x2, y2}, _}) do
    dist_x = x2 - x1
    dist_y = y2 - y1

    [{x2 + dist_x, y2 + dist_y}, {x1 - dist_x, y1 - dist_y}]
  end

  defp get_antinodes_extended({_, type1}, {_, type2}, _) when type1 != type2, do: nil
  defp get_antinodes_extended({{x1, y1}, _}, {{x2, y2}, _}, _) when x1 == x2 and y1 == y2, do: nil

  defp get_antinodes_extended({{x1, y1}, _}, {{x2, y2}, _}, max) do
    dist_x = x2 - x1
    dist_y = y2 - y1

    [
      get_multiple({x2, y2}, {dist_x, dist_y}, max),
      get_multiple({x2, y2}, {-dist_x, -dist_y}, max)
    ]
  end

  defp get_multiple({x, y}, {dx, dy}, {max_x, max_y})
       when x + dx < 0 or y + dy < 0 or x + dx > max_x or y + dy > max_y,
       do: []

  defp get_multiple({x, y}, {dx, dy}, max),
    do: [{x + dx, y + dy} | get_multiple({x + dx, y + dy}, {dx, dy}, max)]
end
