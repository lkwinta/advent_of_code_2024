defmodule AdventOfCode2024.Solutions.Y24.Day01Test do
  alias AoC.Input, warn: false
  alias AdventOfCode2024.Solutions.Y24.Day01, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2024 --day 1
  #
  #     mix test test/2024/day01_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2024 --day 1 --part 1
  #
  # Use sample input file:
  #
  #     # returns {:ok, "priv/input/2024/day-01-mysuffix.inp"}
  #     {:ok, path} = Input.resolve(2024, 1, "mysuffix")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert 11 == solve(input, :part_one)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 1_590_491

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 1, :part_one)
  end

  test "part two example" do
    input = ~S"""
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert 31 == solve(input, :part_two)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 22_588_371

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 1, :part_two)
  end
end
