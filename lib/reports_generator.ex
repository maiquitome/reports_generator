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

  @spec build(String) :: map
  @doc """
  Builds a report.

  ## Examples

      iex> ReportsGenerator.build("report_complete.csv")
      %{
        "foods" => %{
          "açaí" => 37742,
          "churrasco" => 37650,
          "esfirra" => 37462,
          "hambúrguer" => 37577,
          "pastel" => 37392,
          "pizza" => 37365,
          "prato_feito" => 37519,
          "sushi" => 37293
        },
        "users" => %{
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
    Enum.reduce(list, report_map(), fn line_list, acc_map -> sum_values(line_list, acc_map) end)
  end

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users} = report) do
    foods = Map.put(foods, food_name, foods[food_name] + 1)
    users = Map.put(users, id, price + users[id])

    # report
    # |> Map.put("users", users)
    # |> Map.put("foods", foods)

    %{report | "users" => users, "foods" => foods}
  end

  defp report_map do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    %{"users" => users, "foods" => foods}

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
