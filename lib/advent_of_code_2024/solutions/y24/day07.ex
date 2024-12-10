defmodule AdventOfCode2024.Solutions.Y24.Day07 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split(~r"\r\n|\r|\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&Regex.named_captures(~r"(?<r>\d+):(?<v>(\s\d+)*)", &1))
    |> Enum.map(fn %{"r" => res, "v" => val} ->
      {
        elem(Integer.parse(res), 0),
        String.split(val, " ")
        |> Enum.filter(&(&1 != ""))
        |> Enum.map(&elem(Integer.parse(&1), 0))
      }
    end)
  end

  def part_one(problem) do
    problem
    |> Enum.filter(&check_operators/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Task.async_stream(&{check_operators_extended(&1), &1}, ordered: false)
    |> Stream.filter(&match?({:ok, {true, _}}, &1))
    |> Stream.map(&elem(elem(elem(&1, 1), 1), 0))
    |> Enum.to_list()
    |> Enum.sum()
  end

  defp check_operators({sum, [value]}), do: sum == value
  defp check_operators({sum, [value | _]}) when sum < value, do: false

  defp check_operators({sum, [a, b | values]}),
    do: check_operators({sum, [a * b | values]}) or check_operators({sum, [a + b | values]})

  defp check_operators_extended({sum, [value]}), do: sum == value
  defp check_operators_extended({sum, [value | _]}) when sum < value, do: false

  defp check_operators_extended({sum, [a, b | values]}) do
    check_operators_extended({sum, [a * b | values]}) or
      check_operators_extended({sum, [a + b | values]}) or
      check_operators_extended({sum, [10 ** length(Integer.digits(b)) * a + b | values]})
  end
end
