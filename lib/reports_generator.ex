defmodule ReportsGenerator do
  @moduledoc """
  Documentation for `ReportsGenerator`.
  """

  @spec build(String) :: map
  @doc """
  Extracts information from a file.

  ## Examples

      iex> ReportsGenerator.build("report_complete.csv")
      %{
        "1" => 278849,
        "10" => 268317,
        "11" => 268877,
        "12" => 276306,
        "13" => 282953,
        "14" => 277084,
        "15" => 280105,
        "16" => 271831,
        "17" => 272883,
        "18" => 271421,
        "19" => 277720,
        "2" => 271031,
        "20" => 273446,
        "21" => 275026,
        "22" => 278025,
        "23" => 276523,
        "24" => 274481,
        "25" => 274512,
        "26" => 274199,
        "27" => 278001,
        "28" => 274256,
        "29" => 273030,
        "3" => 272250,
        "30" => 275978,
        "4" => 277054,
        "5" => 270926,
        "6" => 272053,
        "7" => 273112,
        "8" => 275161,
        "9" => 274003
      }

  """
  def build(file_name) do
    "reports/#{file_name}"
    |> File.stream!()
    |> Enum.reduce(map_report(), fn line_string, acc_map ->
      # parse_line(line): ["3", "hambúrguer", 47]
      [id, _food_name, price] = parse_line(line_string)
      Map.put(acc_map, id, acc_map[id] + price)
      # iex> Map.put(%{}, "1", 48)
      # %{"1" => 48}
    end)
  end

  defp map_report, do: Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

  defp parse_line(line) do
    # "3,hambúrguer,47\n"
    line
    |> String.trim()
    # "3,hambúrguer,47"
    |> String.split(",")
    # ["3", "hambúrguer", "47"]
    |> List.update_at(2, &String.to_integer/1)

    # ["3", "hambúrguer", 47]
  end
end
