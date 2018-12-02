defmodule Day2.Utils do
  def parse_input(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.graphemes/1)
  end
end

defmodule Day2.Part1 do
  def process(input) do
    input
    |> Enum.map(fn value ->
      value
      |> Enum.reduce({value, %{}}, fn letter, {value, acc} ->
        acc
        |> Map.get(letter)
        |> case do
          nil -> {value, Map.put(acc, letter, 1)}
          count -> {value, Map.put(acc, letter, count + 1)}
        end
      end)
    end)
    |> Enum.map(fn {value, counts} ->
      counts =
        counts
        |> Enum.reduce(MapSet.new(), fn {_letter, count}, acc ->
          if count == 2 || count == 3 do
            MapSet.put(acc, count)
          else
            acc
          end
        end)

      {value, counts}
    end)
    |> Enum.reduce({0, 0}, fn {_value, counts}, {count_of_two, count_of_three} ->
      {
        MapSet.member?(counts, 2),
        MapSet.member?(counts, 3)
      }
      |> case do
        {true, true} -> {count_of_two + 1, count_of_three + 1}
        {false, true} -> {count_of_two, count_of_three + 1}
        {true, false} -> {count_of_two + 1, count_of_three}
        _ -> {count_of_two, count_of_three}
      end
    end)
    |> (fn {count_of_two, count_of_three} ->
          count_of_two * count_of_three
        end).()
    |> IO.puts()
  end
end

defmodule Day2.Part2 do
  def process(input) do
    input
    |> Enum.map(fn base_value ->
      input
      |> Enum.reduce({nil, nil}, fn value, acc = {_acc_value, acc_diff} ->
        diff = word_diff(base_value, value)

        if base_value != value && (is_nil(acc_diff) || length(diff) < length(acc_diff)) do
          {value, diff}
        else
          acc
        end
      end)
    end)
    |> Enum.reject(fn {_, diff} ->
      length(diff) > 1
    end)
    |> Enum.map(fn {value, [{_, index}]} ->
      value
      |> List.delete_at(index)
      |> List.to_string()
    end)
    |> List.first()
    |> IO.puts()
  end

  defp word_diff(first_list, second_list) do
    first_list
    |> Enum.with_index()
    |> Enum.reject(fn {value, index} ->
      Enum.at(second_list, index) == value
    end)
  end
end

"input.txt"
|> Day2.Utils.parse_input()
|> Day2.Part1.process()

"input.txt"
|> Day2.Utils.parse_input()
|> Day2.Part2.process()
