defmodule Lists do
  @moduledoc """
  See https://sites.google.com/site/prologsite/prolog-problems/1
  """

  @doc """
  Find the last element in a list.

    iex> Lists.last([:a, :b, :c, :d])
    :d
  """
  def last([element]), do: element
  def last([_ | t]), do: last(t)
end
