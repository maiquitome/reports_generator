defmodule ReportsGeneratorTest do
  use ExUnit.Case
  # doctest ReportsGenerator

  describe "build/1" do
    test "Builds a report." do
      file_name = "report_test.csv"

      response = ReportsGenerator.build(file_name)

      expected_response = %{
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

      assert response == expected_response
    end
  end

  describe "build_from_many/1" do
    test "Builds a report from many files." do
      files_name = ["report_test.csv", "report_test.csv"]

      response = ReportsGenerator.build_from_many(files_name)

      expected_response =
        {:ok,
         %{
           "foods" => %{
             "açaí" => 2,
             "churrasco" => 4,
             "esfirra" => 6,
             "hambúrguer" => 4,
             "pastel" => 0,
             "pizza" => 4,
             "prato_feito" => 0,
             "sushi" => 0
           },
           "users" => %{
             "1" => 96,
             "10" => 72,
             "11" => 0,
             "12" => 0,
             "13" => 0,
             "14" => 0,
             "15" => 0,
             "16" => 0,
             "17" => 0,
             "18" => 0,
             "19" => 0,
             "2" => 90,
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
             "3" => 62,
             "30" => 0,
             "4" => 84,
             "5" => 98,
             "6" => 36,
             "7" => 54,
             "8" => 50,
             "9" => 48
           }
         }}

      assert response == expected_response
    end

    test "When a files list is not provided, returns an error message." do
      files_name = "not_a_list"

      response = ReportsGenerator.build_from_many(files_name)

      expected_response = {:error, "Please provide a list of strings"}

      assert response == expected_response
    end
  end

  describe "fetch_higher_cost/2" do
    test "When the option is 'users', returns the user who spent the most." do
      file_name = "report_test.csv"

      report = ReportsGenerator.build(file_name)

      option = "users"

      response = ReportsGenerator.fetch_higher_cost(report, option)

      expected_response = {:ok, {"5", 49}}

      assert response == expected_response
    end

    test "When the option is 'foods', returns the most consumed food." do
      file_name = "report_test.csv"

      report = ReportsGenerator.build(file_name)

      option = "foods"

      response = ReportsGenerator.fetch_higher_cost(report, option)

      expected_response = {:ok, {"esfirra", 3}}

      assert response == expected_response
    end

    test "When an invalid option is passed as argument, returns an error message." do
      report = ReportsGenerator.build("report_test.csv")

      option = "aaaaaaaaaaa"

      response = ReportsGenerator.fetch_higher_cost(report, option)

      expected_response = {:error, "INVALID OPTION!!!!!"}

      assert response == expected_response
    end
  end
end
