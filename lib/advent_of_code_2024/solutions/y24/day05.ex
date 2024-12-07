defmodule AdventOfCode2024.Solutions.Y24.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    [rules, updates] =
      Input.read!(input)
      |> String.split(~r"\r\n|\r|\n")
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.filter(&(&1 != [""]))

    rules =
      rules
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.map(fn [x, y] ->
        {x, _} = Integer.parse(x)
        {y, _} = Integer.parse(y)
        {x, y}
      end)

    updates =
      updates
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(
        &(&1
          |> Enum.map(fn x -> elem(Integer.parse(x), 0) end))
      )

    {rules, updates}
  end

  def part_one(problem) do
    {rules, updates} = problem

    indices =
      updates
      |> Enum.map(&check_update(&1 |> Enum.with_index(), rules))

    Enum.zip(updates, indices)
    |> Enum.filter(fn {_, ind} -> ind == true end)
    |> Enum.map(fn {update, _} ->
      Enum.at(update, div(length(update), 2))
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    {rules, updates} = problem

    indices =
      updates
      |> Enum.map(&check_update(&1 |> Enum.with_index(), rules))

    successors_map =
      rules
      |> Enum.reduce(%{}, fn {x, y}, map ->
        map
        |> Map.update(x, MapSet.new([y]), fn successor -> MapSet.put(successor, y) end)
        |> Map.put_new(y, MapSet.new())
      end)

    Enum.zip(updates, indices)
    |> Enum.filter(fn {_, ind} -> ind == false end)
    |> Enum.map(fn {update, _} -> fix(update, successors_map) end)
    |> Enum.map(&Enum.at(&1, div(length(&1), 2)))
    |> Enum.sum()
  end

  defp fix([], _), do: []

  defp fix([head | update], rules) do
    successors = Map.fetch!(rules, head)

    if update |> Enum.all?(&MapSet.member?(successors, &1)) do
      [head | fix(update, rules)]
    else
      fix(insert_behind_successors(update, head, successors), rules)
    end
  end

  defp insert_behind_successors([head | update], el_to_insert, successors) do
    if update |> Enum.all?(&MapSet.member?(successors, &1)) do
      [head, el_to_insert | update]
    else
      [head | insert_behind_successors(update, el_to_insert, successors)]
    end
  end

  defp check_update(_, []), do: true

  defp check_update(update, [{pre, aft} | rules]) do
    {_, ind_pre} = Enum.find(update, {:a, nil}, fn {val, _} -> val == pre end)
    {_, ind_aft} = Enum.find(update, {:a, nil}, fn {val, _} -> val == aft end)

    if ind_aft == nil or ind_pre == nil or ind_pre < ind_aft do
      check_update(update, rules)
    else
      false
    end
  end
end
