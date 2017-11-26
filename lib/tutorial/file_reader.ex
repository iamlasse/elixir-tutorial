defmodule Tutorial.FileReader do
  @moduledoc """
  This function takes a path to a file and find a string to tweet

  iex> Tutorial.FileReader.get_strings("priv/test/doc.txt")
  "ABC"
  """

  def get_strings(path) do
    path
    |> File.read!()
    |> select_string
  end

  def select_string(str) do
    str
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&String.length(&1) <= 140)
    |> Enum.random()
  end
end
