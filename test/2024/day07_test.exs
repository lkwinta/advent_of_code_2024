defmodule AdventOfCode2024.Solutions.Y24.Day07Test do
  alias AoC.Input, warn: false
  alias AdventOfCode2024.Solutions.Y24.Day07, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

    assert 3749 == solve(input, :part_one)
  end

  @part_one_solution 3_119_088_655_389

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 7, :part_one)
  end

  test "part two example" do
    input = ~S"""
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

    assert 11387 == solve(input, :part_two)
  end

  @part_two_solution 264_184_041_398_847

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 7, :part_two)
  end
end
