defmodule AdventOfCode2024.Solutions.Y24.Day06 do
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
    starting_position =
      problem
      |> Enum.find(fn {_, value} -> value == ?^ end)
      |> elem(0)

    grid = Map.put(problem, starting_position, ?.)

    make_move(grid, starting_position, {-1, 0})
    |> Enum.filter(fn {_, value} -> value == ?X end)
    |> Enum.count()
  end

  def part_two(problem) do
    starting_position =
      problem
      |> Enum.find(fn {_, value} -> value == ?^ end)
      |> elem(0)

    grid = Map.put(problem, starting_position, ?.)

    obstacle_positions =
      make_move(grid, starting_position, {-1, 0})
      |> Enum.filter(fn {pos, value} -> value == ?X and pos != starting_position end)
      |> Enum.map(&elem(&1, 0))

    obstacle_positions
    |> Task.async_stream(
      &check_loop(Map.put(grid, &1, ?#), starting_position, {-1, 0}, MapSet.new()),
      ordered: false
    )
    |> Stream.filter(&match?({:ok, true}, &1))
    |> Enum.count()
  end

  defp rotate({-1, 0}), do: {0, 1}
  defp rotate({0, 1}), do: {1, 0}
  defp rotate({1, 0}), do: {0, -1}
  defp rotate({0, -1}), do: {-1, 0}

  defp make_move(grid, {x, y}, {dx, dy}) do
    grid = Map.put(grid, {x, y}, ?X)

    case Map.fetch(grid, {x + dx, y + dy}) do
      {:ok, ?#} ->
        make_move(grid, {x, y}, rotate({dx, dy}))

      {:ok, chr} when chr == ?X or chr == ?. ->
        make_move(grid, {x + dx, y + dy}, {dx, dy})

      :error ->
        grid
    end
  end

  defp check_loop(grid, {x, y}, {dx, dy}, visited) do
    if MapSet.member?(visited, {{x, y}, {dx, dy}}) do
      true
    else
      visited = MapSet.put(visited, {{x, y}, {dx, dy}})

      case Map.fetch(grid, {x + dx, y + dy}) do
        {:ok, ?#} ->
          check_loop(grid, {x, y}, rotate({dx, dy}), visited)

        {:ok, ?.} ->
          check_loop(grid, {x + dx, y + dy}, {dx, dy}, visited)

        :error ->
          false
      end
    end
  end
end
