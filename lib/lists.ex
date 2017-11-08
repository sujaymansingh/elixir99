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

  @doc """
  Reverse a list.

    iex> Lists.reverse([:a, :b, :c])
    [:c, :b, :a]
  """
  def reverse(my_list), do: reverse(my_list, [])
  defp reverse([], acc), do: acc
  defp reverse([h | t], acc), do: reverse(t, [h | acc])

  @doc """
  Find out whether a list is a palindrome.

    iex> Lists.is_palindrome([:x, :a, :m, :a, :x])
    true
    iex> Lists.is_palindrome([:x, :a, :m, :a])
    false
  """
  def is_palindrome([]), do: false
  def is_palindrome(my_list), do: is_palindrome(my_list, [])

  defp is_palindrome(part_1, part_2) when length(part_1) == length(part_2) do
    # This is the case when the original list was even numbered in length.
    # Note that we don't have to reverse part_2 because it will already by reversed by
    # the partitioning function.
    part_2 == part_1
  end

  defp is_palindrome(part_1, part_2) when length(part_1) - length(part_2) == 1 do
    # This is the case when the original list had an odd number of items.
    # The head of part_1 in this case is the middle item in the list, and doesn't matter.
    [_ | t] = part_1
    t == part_2
  end

  defp is_palindrome(part_1, part_2) when length(part_1) > length(part_2) do
    # The parts are not in a position yet to compare. So we move an item from part_1 to
    # part_2 and check again.
    # Note that [h | part_2] has the effect of 'reversing' part_2, so when they are in a
    # position to compare, we won't need to reverse anything.
    [h | t] = part_1
    is_palindrome(t, [h | part_2])
  end

  defp is_palindrome(_, _), do: false

  @doc """
  Flatten a nested list structure.

  Transform a list, possibly holding lists as elements into a 'flat' list by replacing each list with its
  elements (recursively).

    iex> Lists.flatten([:a, [:b, [:c, :d], :e]])
    [:a, :b, :c, :d, :e]
  """
  def flatten(x) when is_list(x) do
    flatten(x, [])
  end

  defp flatten([], acc), do: reverse(acc)

  defp flatten([h | t], acc) when is_list(h) do
    new_input = flatten(h) ++ t
    flatten(new_input, acc)
  end

  defp flatten([h | t], acc) do
    flatten(t, [h | acc])
  end
end
