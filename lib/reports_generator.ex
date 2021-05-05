defmodule ReportsGenerator do
  @moduledoc """
  Builds a report.
  """

  alias ReportsGenerator.Parser

  @spec build(String) :: map
  @doc """
  Builds a report.

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
    file_name
    |> Parser.parse_file()
    |> build_report_map()
  end

  @spec fetch_higher_cost(map) :: {String, number()}
  @doc """
  Returns the higher cost.

  ## Examples

      iex> ReportsGenerator.build("report_complete.csv") |> ReportsGenerator.fetch_higher_cost()
      {"13", 282953}

  """
  def fetch_higher_cost(report), do: Enum.max_by(report, fn {_key, value} -> value end)

  defp build_report_map(list) do
    Enum.reduce(list, report_map(), fn line_list, acc_map -> sum_values(acc_map, line_list) end)
  end

  defp sum_values(map, [id, _food_name, price]) do
    Map.put(map, id, price + map[id])
  end

  defp report_map, do: Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
end
