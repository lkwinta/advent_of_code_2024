defmodule AdventOfCode2024.Solutions.Y24.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    [rules, updates] = Input.read!(input)
    |> String.split("\n")
    |> Enum.chunk_by(& &1 == "")
    |> Enum.filter(& &1 != [""])

    rules = rules
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.map(fn [x, y] ->
      {x, _ } = Integer.parse(x)
      {y, _ } = Integer.parse(y)
      {x, y}
    end)

    updates = updates
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&
      &1 |> Enum.map(fn x -> elem(Integer.parse(x), 0) end)
    )

    {rules, updates}
  end

  def part_one(problem) do
    {rules, updates} = problem
    indices = updates
    |> Enum.map(&check_update(&1 |> Enum.with_index(), rules, []))

    Enum.zip(updates, indices)
    |> Enum.filter(fn {_, {ind, _}} -> ind == true end)
    |> Enum.map(fn {update, _} ->
      Enum.at(update, Integer.floor_div(length(update), 2))
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    {rules, updates} = problem
    indices = updates
    |> Enum.map(&check_update(&1 |> Enum.with_index(), rules, []))
    |> IO.inspect(charlists: :as_lists)

    rules_map_succ = rules |> Enum.reduce(%{}, fn {x, y}, acc_map ->
      Map.put(acc_map, x, [y | Map.get(acc_map, x, [])])
    end) |> IO.inspect(charlists: :as_lists)

    rules_map_pred = rules |> Enum.reduce(%{}, fn {x, y}, acc_map ->
      Map.put(acc_map, y, [x | Map.get(acc_map, y, [])])
    end) |> IO.inspect(charlists: :as_lists)

    Enum.zip(updates, indices)
    |> Enum.filter(fn {_, {ind, _}} -> ind == false end)
    |> IO.inspect(charlists: :as_lists)
    # |> Enum.map(fn {update, {_, incorrect}} ->
    #   Enum.at(update, Integer.floor_div(length(update), 2))
    # end)
    # |> Enum.sum()
  end

  # defp fix(update, incorrect)

  defp check_update(_, [], []), do: {true, []}
  defp check_update(_, [], incorrect), do: {false, Enum.uniq(incorrect)}
  defp check_update(update, [{pre, aft} | rules], incorrect) do
    {val_incorrect, ind_pre} = Enum.find(update, {:a, nil}, fn {val, _} -> val == pre end)
    {_, ind_aft} = Enum.find(update, {:a, nil}, fn {val, _} -> val == aft end)

    if ind_aft == nil or ind_pre == nil or ind_pre < ind_aft do
      check_update(update, rules, incorrect)
    else
      check_update(update, rules, incorrect ++ [{pre, aft}])
    end
  end
end
