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

  @doc """
  Find the K'th element of a list.

  The first element in the list is number 1.

    iex> Lists.element_at([:a, :b, :c, :d, :e], 3)
    :c
  """
  def element_at([h | _], 1), do: h

  def element_at([_, h1 | t], n) when n > 1 do
    element_at([h1 | t], n - 1)
  end

  @doc """
  Find the number of elements of a list.

    iex> Lists.len([:a, :b, :c])
    3
  """
  def len(my_list), do: len(my_list, 0)
  defp len([], acc), do: acc
  defp len([_ | t], acc), do: len(t, acc + 1)
end
