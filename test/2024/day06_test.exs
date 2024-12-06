defmodule AdventOfCode2024.Solutions.Y24.Day06Test do
  alias AoC.Input, warn: false
  alias AdventOfCode2024.Solutions.Y24.Day06, as: Solution, warn: false
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
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    assert 41 == solve(input, :part_one)
  end

  @part_one_solution 4602

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 6, :part_one)
  end

  test "part two example" do
    input = ~S"""
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    assert 6 == solve(input, :part_two)
  end

  test "small part one" do
    input = ~S"""
    #.##
    #..#
    #^##
    """

    assert 3 == solve(input, :part_one)
  end

  test "small part two" do
    input = ~S"""
    #.##
    #..#
    #^##
    """

    assert 1 == solve(input, :part_two)
  end

  @part_two_solution 1703

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 6, :part_two)
  end
end
