defmodule AdventOfCode2024.Solutions.Y24.Day14 do
  alias AoC.Input

  defmodule Robot do
    defstruct [:position, :velocity]
  end

  def parse(input, _part) do
    robots = Input.read!(input)
    |> String.split(~r"\r\n|\r|\n")
    |> Stream.filter(& &1 != "")
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(&parse_robot/1)
    |> Enum.to_list()

    min_x = robots |> Stream.map(& &1.position |> elem(0)) |> Enum.min()
    min_y = robots |> Stream.map(& &1.position |> elem(1)) |> Enum.min()
    max_x = robots |> Stream.map(& &1.position |> elem(0)) |> Enum.max()
    max_y = robots |> Stream.map(& &1.position |> elem(1)) |> Enum.max()

    {max_x - min_x + 1, max_y - min_y + 1, robots}
  end

  defp parse_robot([pos_str, vel_str]) do
    pos_map = Regex.named_captures(~r"p=(?<x>\d+),(?<y>\d+)", pos_str)
    vel_map = Regex.named_captures(~r"v=(?<x>-?\d+),(?<y>-?\d+)", vel_str)

    %Robot{
      position: {
        String.to_integer(pos_map["x"]),
        String.to_integer(pos_map["y"])
      },
      velocity: {
        String.to_integer(vel_map["x"]),
        String.to_integer(vel_map["y"])
      }
    }
  end

  def part_one(problem) do
    {width, height, robots} = problem

    robots = robots
    |> Stream.map(&simulate(&1.position, &1.velocity, {width, height}, 100))
    |> Enum.to_list()

    q1 = robots |> Enum.count(fn {x, y} ->
      x < div(width, 2) and y < div(height, 2)
    end)
    q2 = robots |> Enum.count(fn {x, y} ->
      x > div(width, 2) and y < div(height, 2)
    end)
    q3 = robots |> Enum.count(fn {x, y} ->
      x < div(width, 2) and y > div(height, 2)
    end)
    q4 = robots |> Enum.count(fn {x, y} ->
      x > div(width, 2) and y > div(height, 2)
    end)

    q1 * q2 * q3 * q4
  end

  def part_two(problem) do
    {width, height, robots} = problem

    indices_x = for i <- 0..width - 1, do: i
    indices_y = for i <- 0..height - 1, do: i

    steps = for i <- 7000..7100, do: i
    {:ok, file} = File.open("output14.txt", [:write])
    Enum.each(steps,
      fn step ->
        robots = robots
        |> Stream.map(&simulate(&1.position, &1.velocity, {width, height}, step))
        |> MapSet.new()

        IO.write(file, "Epoch " <> to_string(step) <> "\n")
        IO.write("Epoch " <> to_string(step) <> "\n")
        Enum.each(indices_y, fn y ->
          Enum.each(indices_x, fn x ->
            if MapSet.member?(robots, {x, y}) do
              IO.write(file, "1")
            else
              IO.write(file, ".")
            end
          end)
          IO.write(file, "\n")
        end)
        IO.write(file, "\n\n\n")
      end
    )
    File.close(file)
  end

  defp simulate({px, py}, {vx, vy}, {width, height}, steps) do
    new_x = rem((px + vx*steps), width)
    new_y = rem((py + vy*steps), height)

    new_x = if new_x < 0 do width + new_x else new_x end
    new_y = if new_y < 0 do height + new_y else new_y end

    {new_x, new_y}
  end
end
