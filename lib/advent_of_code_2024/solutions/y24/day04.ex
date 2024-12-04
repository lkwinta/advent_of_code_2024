defmodule AdventOfCode2024.Solutions.Y24.Day04 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&to_charlist/1)
    |> build_grid()
  end

  defp build_grid(list) do
    for {row, i} <- Enum.with_index(list),
        {col, j} <- Enum.with_index(row),
        into: %{},
        do: {{i, j}, col}
  end

  def part_one(problem) do
    get_directions()
    |> Enum.map(fn {di, dj} ->
      Enum.count(Map.keys(problem), fn {i, j} ->
        Stream.iterate({i, j}, fn {i, j} -> {i + di, j + dj} end)
        |> Stream.take(4)
        |> Enum.map(&problem[&1])
        |> Enum.to_list() == ~c"XMAS"
      end)
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    Enum.count(problem, fn
      {coord, ?A} -> check_corners(problem, coord)
      _ -> false
    end)
  end

  defp get_directions() do
    for i <- -1..1, j <- -1..1, not (i == 0 and j == 0), do: {i, j}
  end

  defp check_corners(grid, {i, j}) do
    {grid[{i - 1, j - 1}], grid[{i + 1, j + 1}]} in [{?M, ?S}, {?S, ?M}] and
      {grid[{i - 1, j + 1}], grid[{i + 1, j - 1}]} in [{?M, ?S}, {?S, ?M}]
  end
end
