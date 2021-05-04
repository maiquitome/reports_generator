defmodule ReportsGenerator do
  @moduledoc """
  Documentation for `ReportsGenerator`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ReportsGenerator.hello()
      :world

  """
  def build(file_name) do
    "reports/#{file_name}"
    |> File.read()
    |> handle_file()
  end

  def handle_file({:ok, content}), do: content
  def handle_file({:error, reason}), do: reason
end
