defmodule ReportsGenerator.Parser do
  @moduledoc """
  Extracts information from a file and parse lines.
  """

  @spec parse_file(String) :: %Stream{
          :done => nil,
          :funs => nonempty_maybe_improper_list
        }
  @doc """
  Extracts information from a file and parse lines.

  ## Examples

  - using Enum.map:
      iex> ReportsGenerator.Parser.parse_file("report_test.csv")
      [
        ["1", "pizza", 48],
        ["2", "açaí", 45],
        ["3", "hambúrguer", 31],
        ["4", "esfirra", 42],
        ["5", "hambúrguer", 49],
        ["6", "esfirra", 18],
        ["7", "pizza", 27],
        ["8", "esfirra", 25],
        ["9", "churrasco", 24],
        ["10", "churrasco", 36]
      ]
  - using Stream.map:
      iex> ReportsGenerator.Parser.parse_file("report_test.csv")
      #Stream<[
        enum: %File.Stream{
          line_or_bytes: :line,
          modes: [:raw, :read_ahead, :binary],
          path: "reports/report_test.csv",
          raw: true
        },
        funs: [#Function<48.50989570/1 in Stream.map/2>]
      ]>

  """
  def parse_file(file_name) do
    "reports/#{file_name}"
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

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
