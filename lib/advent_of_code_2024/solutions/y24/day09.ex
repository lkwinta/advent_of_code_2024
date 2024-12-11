defmodule AdventOfCode2024.Solutions.Y24.Day09 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> to_charlist()
    |> Enum.map(&(&1 - ?0))
    |> build_map()
  end

  defp build_map(list) do
    for {element, i} <- Enum.with_index(list),
        into: %{},
        do: {i, element}
  end

  def part_one(_problem) do
    # indices = for i <- 0..length(Map.keys(problem)), do: i |> IO.inspect()
  end

  # def part_two(problem) do
  #   problem
  # end
end
