defmodule AdventOfCode2024.Solutions.Y24.Day12 do
  alias AoC.Input
  use Agent


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
    Agent.start_link(fn -> MapSet.new() end, name: __MODULE__)

    Map.keys(problem)
    |> Stream.map(fn pos ->
      {Map.get(problem, pos), extend(problem, pos, Map.get(problem, pos))}
    end)
    |> Stream.filter(& elem(&1, 1) != [nil])
    |> Stream.map(fn {a, list} ->
      {a, list |> List.flatten() |> Enum.filter(& &1 != nil)}
    end)
    |> Stream.map(& length(elem(&1, 1)) * count_perimeter(problem, elem(&1, 1)))
    |> Enum.sum()
  end

  def part_two(problem) do
    Agent.start_link(fn -> MapSet.new() end, name: __MODULE__)

    regions = Map.keys(problem)
    |> Stream.map(fn pos ->
      {Map.get(problem, pos), extend(problem, pos, Map.get(problem, pos))}
    end)
    |> Stream.filter(& elem(&1, 1) != [nil])
    |> Stream.map(fn {a, list} ->
      {a, list |> List.flatten() |> Enum.filter(& &1 != nil)}
    end)
    |> Enum.to_list()

    regions |> Enum.sum()
  end

  defp extend(map, position, _) when not is_map_key(map, position), do: [nil]
  defp extend(map, {x, y}, type) do
    visited = Agent.get(__MODULE__, &MapSet.member?(&1, {x, y}))
    curr_type = Map.fetch!(map, {x, y})

    cond do
      visited -> [nil]
      curr_type != type -> [nil]
      true ->
        Agent.update(__MODULE__, &MapSet.put(&1, {x, y}))
        [{x, y} | [extend(map, {x + 1, y}, type) | [extend(map, {x, y + 1}, type) | [extend(map, {x - 1, y}, type) | extend(map, {x, y - 1}, type)]]]]
    end
  end

  defp count_perimeter(_, []), do: 0
  defp count_perimeter(map, [{x, y} | list]) do
    type = Map.fetch!(map, {x, y})

    top = Map.fetch(map, {x + 1, y})
    bottom = Map.fetch(map, {x - 1, y})
    left = Map.fetch(map, {x, y - 1})
    right = Map.fetch(map, {x, y + 1})

    a = if match?(:error, top) || elem(top, 1) != type, do: 1
    b = if match?(:error, bottom) || elem(bottom, 1) != type, do: 1
    c = if match?(:error, left) || elem(left, 1) != type, do: 1
    d = if match?(:error, right) || elem(right, 1) != type, do: 1

    count = [a, b, c, d] |> Stream.filter(& &1 != nil) |> Enum.sum()
    count + count_perimeter(map, list)
  end
end
