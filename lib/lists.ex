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

  @doc """
  Find the last but one element in a list.

    iex> Lists.last_but_one([:a, :b, :c, :d])
    :c
  """
  def last_but_one([penultimate, _ultimate]), do: penultimate
  def last_but_one([_ | t]), do: last_but_one(t)
end
