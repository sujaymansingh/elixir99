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

  @doc """
  Eliminate consecutive duplicates of list elements.

  If a list contains repeated elements they should be replaced with a single copy of the element. The order of the
  elements should not be changed.

    iex> Lists.compress([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e])
    [:a, :b, :c, :a, :d, :e]
  """
  def compress(my_list), do: compress(my_list, [])

  defp compress([], parts), do: reverse(parts)

  defp compress([h | t], [h | other_parts]) do
    compress(t, [h | other_parts])
  end

  defp compress([h | t], parts) do
    compress(t, [h | parts])
  end

  @doc """
  Pack consecutive duplicates of list elements into sublists.

  If a list contains repeated elements they should be placed in separate sublists.

    iex> Lists.pack([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e])
    [[:a, :a, :a, :a], [:b], [:c, :c], [:a, :a], [:d], [:e, :e, :e, :e]]
  """
  def pack(my_list), do: pack(my_list, [])

  defp pack([], acc), do: reverse(acc)

  defp pack([h | t], [head_of_acc = [h | _] | tail_of_acc]) do
    new_head_of_acc = [h | head_of_acc]
    pack(t, [new_head_of_acc | tail_of_acc])
  end

  defp pack([h | t], acc) do
    pack(t, [[h] | acc])
  end

  @doc """
  Run-length encoding of a list.

  Use the result of problem 1.09 to implement the so-called run-length encoding data compression method.
  Consecutive duplicates of elements are encoded as terms [N,E] where N is the number of duplicates of the element E.

    iex> Lists.encode([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e])
    [{4, :a}, {1, :b}, {2, :c}, {2, :a}, {1, :d}, {4, :e}]
  """
  def encode(my_list) do
    my_list |> pack |> Enum.map(&count/1)
  end

  defp count(some_list = [h | _]), do: {length(some_list), h}

  @doc """
  Modified run-length encoding.

  Modify the result of problem 1.10 in such a way that if an element has no duplicates it is simply copied into the
  result list. Only elements with duplicates are transferred as [N,E] terms.
    
    iex> Lists.encode_modified([:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e])
    [{4, :a}, :b, {2, :c}, {2, :a}, :d, {4, :e}]
  """
  def encode_modified(my_list) do
    my_list |> pack |> Enum.map(&count/1) |> Enum.map(&simplify_if_single/1)
  end

  defp simplify_if_single({1, x}), do: x
  defp simplify_if_single(y), do: y

  @doc """
  Decode a modified run-length encoding.

  Given a run-length code list generated as specified in problem 1.11. Construct its uncompressed version.

    iex> Lists.decode_modified([{4, :a}, :b, {2, :c}, {2, :a}, :d, {4, :e}])
    [:a, :a, :a, :a, :b, :c, :c, :a, :a, :d, :e, :e, :e, :e]
  """
  def decode_modified(my_list) do
    my_list |> Enum.map(&repeat/1) |> flatten
  end

  @doc """
  Given {n, x} return a list of n items, each item being x

    iex> Lists.repeat({4, :x})
    [:x, :x, :x, :x]
    iex> Lists.repeat(:y)
    :y
  """
  def repeat({n, x}) when x > 0, do: repeat(n, x, [])
  def repeat(something_else), do: something_else

  defp repeat(0, _, acc), do: acc
  defp repeat(n, x, acc), do: repeat(n - 1, x, [x | acc])

  @doc """
  Duplicate the elements of a list N times (default N = 2)

    iex> Lists.duplicate([:a, :b, :c, :c, :d])
    [:a, :a, :b, :b, :c, :c, :c, :c, :d, :d]
    iex> Lists.duplicate([:a, :b, :c, :c, :d], 3)
    [:a, :a, :a, :b, :b, :b, :c, :c, :c, :c, :c, :c, :d, :d, :d]
  """
  def duplicate(my_list), do: duplicate(my_list, 2)

  def duplicate(my_list, n) do
    my_list
    |> Enum.map(fn item -> repeat({n, item}) end)
    |> flatten
  end

  @doc """
  Drop every N'th element from a list.

    iex> Lists.drop([:a, :b, :c, :d, :e, :f, :g, :h, :i, :k], 3)
    [:a, :b, :d, :e, :g, :h, :k]
  """
  def drop(my_list, n), do: drop(my_list, n, 1, [])

  defp drop([], _, _, acc), do: reverse(acc)
  defp drop([_ | t], n, n, acc), do: drop(t, n, 1, acc)
  defp drop([h | t], n, i, acc), do: drop(t, n, i + 1, [h | acc])

  @doc """
  Split a list into two parts; the length of the first part is given.

  Do not use any predefined predicates.

    iex> Lists.split([:a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k], 3)
    {[:a, :b, :c], [:d, :e, :f, :g, :h, :i, :j, :k]}
  """
  def split(my_list, n) when length(my_list) <= n do
    {my_list, []}
  end

  def split(my_list, n) when n >= 0 do
    split(my_list, n, [])
  end

  defp split(part_2, n, part_1_reversed) when length(part_1_reversed) == n do
    part_1 = part_1_reversed |> reverse
    {part_1, part_2}
  end

  defp split([h | t], n, part_1_reversed) do
    split(t, n, [h | part_1_reversed])
  end

  @doc """
  Extract a slice from a list.

  Given two indices, I and K, the slice is the list containing the elements between the I'th and K'th element of the
  original list (both limits included).
  Start counting the elements with 1.

    iex> Lists.slice([:a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k], 3, 7)
    [:c, :d, :e, :f, :g]
  """
  def slice(my_list, start_idx, end_idx) when start_idx < 1 do
    slice(my_list, 1, end_idx)
  end

  def slice(my_list, start_idx, end_idx) when end_idx > length(my_list) do
    slice(my_list, start_idx, length(my_list))
  end

  def slice(my_list, start_idx, end_idx) do
    slice(my_list, start_idx, end_idx, 1, [])
  end

  defp slice(_, _, end_idx, i, acc) when i > end_idx do
    # We're done slicing!
    reverse(acc)
  end

  defp slice([_ | t], start_idx, end_idx, i, acc) when i < start_idx do
    # We haven't yet started slicing!
    slice(t, start_idx, end_idx, i + 1, acc)
  end

  defp slice([h | t], start_idx, end_idx, i, acc) do
    # We must be in the middle of slicing!
    slice(t, start_idx, end_idx, i + 1, [h | acc])
  end

  @doc """
  Rotate a list N places to the left.

    iex> Lists.rotate([:a, :b, :c, :d, :e, :f, :g, :h], 3)
    [:d, :e, :f, :g, :h, :a, :b, :c]

    iex> Lists.rotate([:a, :b, :c, :d, :e, :f, :g, :h], -2)
    [:g, :h, :a, :b, :c, :d, :e, :f]
  """
  def rotate(my_list, n) when n < 0 do
    positive_n = length(my_list) + n
    rotate(my_list, positive_n)
  end

  def rotate(my_list, n) do
    {part_1, part_2} = split(my_list, n)
    part_2 ++ part_1
  end

  @doc """
  Remove the K'th element from a list.

    iex> Lists.remove_at([:a, :b, :c, :d], 2)
    {:b, [:a, :c, :d]}
  """
  def remove_at(my_list, n) do
    remove_at(my_list, [], n, 1)
  end

  defp remove_at([h | t], acc, n, n) do
    new_list = reverse(acc) ++ t
    {h, new_list}
  end

  defp remove_at([h | t], acc, n, i) when i < n do
    remove_at(t, [h | acc], n, i + 1)
  end

  @doc """
  Insert an element at a given position into a list.

    iex> Lists.insert_at(:alfa, [:a, :b, :c, :d], 2)
    [:a, :alfa, :b, :c, :d]
  """
  def insert_at(item, my_list, index) do
    {start_list, end_list} = split(my_list, index - 1)
    start_list ++ [item | end_list]
  end

  @doc """
  Create a list containing all integers within a given range.

    iex> Lists.range(4, 9)
    [4, 5, 6, 7, 8, 9]
  """
  def range(i, j) when i < j do
    range(i, j, [])
  end

  defp range(i, j, acc) when i > j, do: reverse(acc)
  defp range(i, j, acc), do: range(i + 1, j, [i | acc])

  @doc """
  Extract a given number of randomly selected elements from a list.

  The selected items shall be put into a result list.
  """
  def rnd_select(my_list, n) when n > 0 do
    rnd_select(my_list, n, [])
  end

  defp rnd_select(_, 0, acc), do: acc

  defp rnd_select(rest, n, acc) do
    i = Random.random(1..length(rest))
    {item, new_rest} = remove_at(rest, i)
    rnd_select(new_rest, n - 1, [item | acc])
  end

  @doc """
  Lotto: Draw N different random numbers from the set 1..M.

  The selected numbers shall be put into a result list.
  """
  def lotto(n, m), do: range(1, m) |> rnd_select(n)

  @doc """
  Generate a random permutation of the elements of a list.
  """
  def rnd_permu(my_list), do: rnd_select(my_list, length(my_list))

  @doc """
    Return the maximum number in a list.

    iex> Lists.maximum([4, 99, 34])
    99
  """
  def maximum([h | t]), do: maximum([h | t], h)

  defp maximum([], m), do: m
  defp maximum([h | t], m) when h > m, do: maximum(t, h)
  defp maximum([_ | t], m), do: maximum(t, m)

  @doc """
  Generate the combinations of K distinct objects chosen from the N elements of a list

  In how many ways can a committee of 3 be chosen from a group of 12 people?
  We all know that there are C(12,3) = 220 possibilities (C(N,K) denotes the well-known binomial coefficients).
  For pure mathematicians, this result may be great.
  But we want to really generate all the possibilities (via backtracking).

   iex> Lists.combination([:a, :b, :c], 2)
   [[:a, :b], [:a, :c], [:b, :c]]

   iex> Lists.combination([:a, :b, :c, :d], 3)
   [[:a, :b, :c], [:a, :b, :d], [:a, :c, :d], [:b, :c, :d]]
  """
  def combination(my_list, n) do
    range(1, length(my_list))
    |> combination_numbers(n)
    |> Enum.map(&reverse/1)
    |> Enum.map(&indices_to_list(&1, my_list))
  end

  @doc """
  This produces combinations of numbers, where numbers is a list of consecutive numbers.

  It uses the fact that the numbers are consecutive to optimise without constantly checking for duplicates.
    iex> Lists.combination_numbers([1, 2, 3], 2)
    [[2, 1], [3, 1], [3, 2]]

    iex> Lists.combination_numbers([1, 2, 3, 4], 3)
    [[3, 2, 1], [4, 2, 1], [4, 3, 1], [4, 3, 2]]
  """
  def combination_numbers(numbers, 1) do
    numbers |> Enum.map(&[&1])
  end

  def combination_numbers(numbers, n) do
    numbers |> combination_numbers(n - 1) |> combine_perms_and_numbers(numbers, [])
  end

  defp combine_perms_and_numbers([], _, acc), do: acc

  defp combine_perms_and_numbers([h_perms | t_perms], list_of_numbers, acc) do
    new_perms =
      list_of_numbers
      |> Enum.filter(fn num -> num > maximum(h_perms) end)
      |> Enum.map(fn num -> [num | h_perms] end)

    combine_perms_and_numbers(t_perms, list_of_numbers, acc ++ new_perms)
  end

  defp indices_to_list(indices, my_list) do
    indices |> Enum.map(&element_at(my_list, &1))
  end

  @doc """
  Group the elements of a set into disjoint subsets.

  Generalize [the solution] in a way that we can specify a list of group sizes and the predicate will
  return a list of groups.

  i.e. I can call `Lists.group([:a, :b, :c, :d, :e, :f, :g], [3, 2, 2])`
  """
  def group(my_list, list_sizes) do
    list_sizes
    |> Enum.map(&combination(my_list, &1))
    |> cartesian_product
    |> Enum.filter(&disjoint?/1)
  end

  @doc """
  Given n lists, return a list of each possible combination of the n.

    iex> Lists.cartesian_product([[:a, :b, :c], [1, 2]])
    [[:a, 1], [:a, 2], [:b, 1], [:b, 2], [:c, 1], [:c, 2]]
  """
  def cartesian_product([h | t]) do
    list_of_lists = Enum.map(h, &[&1])

    List.foldl(t, list_of_lists, fn flat_list, acc ->
      mult(acc, flat_list)
    end)
  end

  @doc """
  For each item in the flat_list, add it to the end of each item in list_of_lists.

    iex> Lists.mult([[:a], [:b], [:c]], [1, 2])
    [[:a, 1], [:a, 2], [:b, 1], [:b, 2], [:c, 1], [:c, 2]]
  """
  def mult(list_of_lists, flat_list) do
    List.foldl(list_of_lists, [], fn inner_list, acc ->
      combined = Enum.map(flat_list, &[&1 | inner_list]) |> Enum.map(&reverse/1)
      acc ++ combined
    end)
  end

  @doc """
  Return true if there are no elements that are in more than one list.

    iex> Lists.disjoint?([[:a, :b, :c], [1, 2, 3], [:x, :y, :z]])
    true
    iex> Lists.disjoint?([[:a, :b, :c], [1, 2, 3], [:c, :d, :e]])
    false
  """
  def disjoint?(lists) do
    {unioned_set, concatenated_list} =
      List.foldl(lists, {MapSet.new(), []}, fn inner_list, {acc_union_set, acc_concatenated_list} ->
        {
          MapSet.union(acc_union_set, MapSet.new(inner_list)),
          acc_concatenated_list ++ inner_list
        }
      end)

    length(concatenated_list) == length(MapSet.to_list(unioned_set))
  end

  @doc """
  Sorting a list of lists according to length of sublists

  We suppose that a list (InList) contains elements that are lists themselves. The objective is to sort the elements
  of InList according to their length.
  E.g. short lists first, longer lists later, or vice versa.

    iex> Lists.lsort([[:a, :b, :c], [:d, :e], [:f, :g, :h], [:d, :e], [:i, :j, :k, :l], [:m, :n], [:o]])
    [[:o], [:d, :e], [:d, :e], [:m, :n], [:a, :b, :c], [:f, :g, :h], [:i, :j, :k, :l]]
  """
  def lsort(my_list) do
    my_list |> Enum.sort(&less_than/2)
  end

  defp less_than([], []), do: false
  defp less_than(a, b) when length(a) < length(b), do: true
  defp less_than(a = [ha | _], b = [hb | _]) when length(a) == length(b), do: ha < hb
  defp less_than(_, _), do: false

  @doc """
  Sorting a list of lists according to length frequency of sublists

  Again, we suppose that a list (InList) contains elements that are lists themselves.
  But this time the objective is to sort the elements of InList according to their length frequency;
  i.e. in the default, where sorting is done ascendingly, lists with rare lengths are placed first,
  others with a more frequent length come later.

    iex> Lists.lfsort([[:a, :b, :c], [:d, :e], [:f, :g, :h], [:d, :e], [:i, :j, :k, :l], [:m, :n], [:o]])
    [[:i, :j, :k, :l], [:o], [:a, :b, :c], [:f, :g, :h], [:d, :e], [:d, :e], [:m, :n]]
  """
  def lfsort(my_list) do
    frequencies =
      List.foldl(my_list, Map.new(), fn sublist, acc ->
        sublist_length = length(sublist)
        length_freq = Map.get(acc, sublist_length, 0)
        Map.put(acc, sublist_length, length_freq + 1)
      end)

    my_list |> Enum.sort(fn a, b -> less_than(a, b, frequencies) end)
  end

  defp less_than([], [], _), do: false

  defp less_than(a, b, frequencies) do
    freq_a = Map.get(frequencies, length(a))
    freq_b = Map.get(frequencies, length(b))

    if freq_a != freq_b do
      freq_a < freq_b
    else
      # frequencies are the same!
      [ha | _] = a
      [hb | _] = b
      ha < hb
    end
  end
end
