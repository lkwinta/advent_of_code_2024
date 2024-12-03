defmodule AdventOfCode2024.Solutions.Y24.Day03Test do
  alias AoC.Input, warn: false
  alias AdventOfCode2024.Solutions.Y24.Day03, as: Solution, warn: false
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
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """

    assert 161 == solve(input, :part_one)
  end

  @part_one_solution 173517243

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 3, :part_one)
  end

  test "part two example" do
    input = ~S"""
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """

    assert 48 == solve(input, :part_two)
  end

  @part_two_solution 100450138

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 3, :part_two)
  end
end
