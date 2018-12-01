defmodule Day1.Utils do
  def parse_input(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Day1.Part1 do
  def process(input) do
    input
    |> Enum.sum()
    |> IO.puts()
  end
end

defmodule Day1.Part2 do
  def process(input, frequency, frequencies) do
    input
    |> Enum.reduce_while({frequency, frequencies}, fn value, {frequency, frequencies} ->
      new_frequency = frequency + value

      frequencies
      |> MapSet.member?(new_frequency)
      |> if do
        {:halt, {:ok, new_frequency}}
      else
        {:cont, {new_frequency, MapSet.put(frequencies, new_frequency)}}
      end
    end)
    |> case do
      {:ok, answer} ->
        IO.puts(answer)

      {frequency, frequencies} ->
        Day1.Part2.process(input, frequency, frequencies)
    end
  end
end

"input.txt"
|> Day1.Utils.parse_input()
|> Day1.Part1.process()

"input.txt"
|> Day1.Utils.parse_input()
|> Day1.Part2.process(0, MapSet.new())
