defmodule AdventOfCode2024.Solutions.Y24.Day12Test do
  alias AoC.Input, warn: false
  alias AdventOfCode2024.Solutions.Y24.Day12, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example small" do
    input = ~S"""
    AAAA
    BBCD
    BBCC
    EEEC
    """

    assert 140 == solve(input, :part_one)
  end

  test "part one example mid" do
    input = ~S"""
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """

    assert 772 == solve(input, :part_one)
  end

  test "part one example" do
    input = ~S"""
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    assert 1930 == solve(input, :part_one)
  end

  @part_one_solution 1549354

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 12, :part_one)
  end

  test "part two example mid" do
    input = ~S"""
    AAAAAA
    AAABBA
    AAABBA
    ABBAAA
    ABBAAA
    AAAAAA
    """

    assert 368 == solve(input, :part_two)
  end

  test "part two example small" do
    input = ~S"""
    AAAA
    BBCD
    BBCC
    EEEC
    """

    assert 80 == solve(input, :part_two)
  end

  test "part two example mid 1" do
    input = ~S"""
    EEEEE
    EXXXX
    EEEEE
    EXXXX
    EEEEE
    """

    assert 236 == solve(input, :part_two)
  end

  test "part two example mid 2" do
    input = ~S"""
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """

    assert 436 == solve(input, :part_one)
  end

  test "part two example big" do
    input = ~S"""
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    assert 1206 == solve(input, :part_one)
  end

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2024, 12, :part_two)
  # end
end
