defmodule AdventOfCode2024.Solutions.Y24.Day13 do
  alias AoC.Input
  use Agent

  defmodule ClawMachine do
    defstruct [:button_A, :button_B, :prize_position]
  end

  def parse(input, part) do
    Input.read!(input)
    |> String.split(~r"\r\n|\r|\n")
    |> Stream.chunk_by(&(&1 == ""))
    |> Stream.filter(&(&1 != [""]))
    |> Stream.map(&parse_claw_machine(&1, part))
    |> Enum.to_list()
  end

  defp parse_claw_machine([button_A, button_B, prize], part) do
    map_button_A = Regex.named_captures(~r"Button [A-B]: X\+(?<X>\d+), Y\+(?<Y>\d+)", button_A)
    map_button_B = Regex.named_captures(~r"Button [A-B]: X\+(?<X>\d+), Y\+(?<Y>\d+)", button_B)
    map_prize = Regex.named_captures(~r"Prize: X=(?<X>\d+), Y=(?<Y>\d+)", prize)

    {xA, _} = Integer.parse(map_button_A["X"])
    {yA, _} = Integer.parse(map_button_A["Y"])
    {xB, _} = Integer.parse(map_button_B["X"])
    {yB, _} = Integer.parse(map_button_B["Y"])

    {xP, _} = Integer.parse(map_prize["X"])
    {yP, _} = Integer.parse(map_prize["Y"])

    {xP, yP} =
      if part == :part_two do
        {xP + 10_000_000_000_000, yP + 10_000_000_000_000}
      else
        {xP, yP}
      end

    %ClawMachine{
      button_A: {xA, yA},
      button_B: {xB, yB},
      prize_position: {xP, yP}
    }
  end

  def part_one(problem) do
    problem
    |> Stream.map(&find_minimum_cost/1)
    |> Stream.filter(fn {n, k} ->
      0 <= n and n <= 100 and
        0 <= k and k <= 100 and
        :math.floor(n) - n == 0.0 and
        :math.floor(k) - k == 0.0
    end)
    |> Stream.map(fn {n, k} -> 3 * n + k end)
    |> Enum.sum()
    |> trunc()
  end

  def part_two(problem) do
    problem
    |> Stream.map(&find_minimum_cost/1)
    |> Stream.filter(fn {n, k} ->
      0 <= n and
        0 <= k and
        :math.floor(n) - n == 0.0 and
        :math.floor(k) - k == 0.0
    end)
    |> Stream.map(fn {n, k} -> 3 * n + k end)
    |> Enum.sum()
    |> trunc()
  end

  defp find_minimum_cost(%ClawMachine{
         button_A: {xA, yA},
         button_B: {xB, yB},
         prize_position: {xP, yP}
       }) do
    w = xA * yB - xB * yA
    wn = xP * yB - yP * xB
    wk = xA * yP - yA * xP

    cond do
      w != 0 ->
        n = wn / w
        k = wk / w

        {n, k}

      w == 0 and wn == 0 and wk == 0 ->
        IO.puts("Singularity")

      true ->
        {0, 0}
    end
  end
end
