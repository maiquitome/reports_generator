defmodule ReportsGenerator do
  @moduledoc """
  Builds a report.
  """

  alias ReportsGenerator.Parser

  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["foods", "users"]

  @spec build(String) :: map
  @doc """
  Builds a report.

  ## Examples

      iex> ReportsGenerator.build("report_test.csv")
      %{
        "foods" => %{
          "açaí" => 1,
          "churrasco" => 2,
          "esfirra" => 3,
          "hambúrguer" => 2,
          "pastel" => 0,
          "pizza" => 2,
          "prato_feito" => 0,
          "sushi" => 0
        },
        "users" => %{
          "1" => 48,
          "10" => 36,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 45,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 31,
          "30" => 0,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }

  """
  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> build_report_map()
  end

  # iex> ReportsGenerator.build_from_many(["report_1.csv","report_2.csv"])
  def build_from_many(file_names) when not is_list(file_names) do
    {:error, "Please provide a list of strings"}
  end

  def build_from_many(file_names) do
    result =
      file_names
      |> Task.async_stream(&build/1)
      |> Enum.reduce(report_layout(), fn {:ok, result}, acc -> sum_reports(acc, result) end)

    {:ok, result}
  end

  @spec fetch_higher_cost(map, String) :: {:ok, {String, number()}} | {:error, String}
  @doc """
  Returns the higher cost.

  ## Examples

      iex> ReportsGenerator.build("report_complete.csv") |> ReportsGenerator.fetch_higher_cost()
      {"13", 282953}

  """
  def fetch_higher_cost(report, option) when option in @options,
    do: {:ok, Enum.max_by(report[option], fn {_option, value} -> value end)}

  def fetch_higher_cost(_report, _option), do: {:error, "INVALID OPTION!!!!!"}

  defp sum_reports(
         %{"foods" => foods1, "users" => users1},
         %{"foods" => foods2, "users" => users2}
       ) do
    foods = merge_maps(foods1, foods2)
    users = merge_maps(users1, users2)

    build_report(foods, users)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  defp build_report(foods, users) do
    %{"users" => users, "foods" => foods}
  end

  defp build_report_map(list) do
    Enum.reduce(list, report_layout(), fn line_list, acc_map -> sum_values(line_list, acc_map) end)
  end

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users}) do
    foods = Map.put(foods, food_name, foods[food_name] + 1)
    users = Map.put(users, id, price + users[id])

    build_report(foods, users)
  end

  defp report_layout do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    build_report(foods, users)

    # %{
    #   "foods" => %{
    #     "açaí" => 0,
    #     "churrasco" => 0,
    #     "esfirra" => 0,
    #     "hambúrguer" => 0,
    #     "pastel" => 0,
    #     "pizza" => 0,
    #     "prato_feito" => 0,
    #     "sushi" => 0
    #   },
    #   "users" => %{
    #     "1" => 0,
    #     "10" => 0,
    #     "11" => 0,
    #     "12" => 0,
    #     ...
  end
end
