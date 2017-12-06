defmodule Logic do
  @moduledoc """
  See https://sites.google.com/site/prologsite/prolog-problems/3
  """
  def and_(a, b), do: a and b

  def or_(a, b), do: a or b

  def nand(a, b), do: not(a and b)

  def nor(a, b), do: not(a or b)

  def xor(false, true), do: true
  def xor(true, false), do: true
  def xor(_, _), do: false

  @doc """
  Produce a truth table for the given number of inputs.

  n is the number of inputs
  f is a function that takes a list of size n and returns true or false

  This is slightly different to the way the prolog example works.
  There, it uses the concept of binding in prolog. I don't believe this will work in
  elixir, without some invasive macros.

  Thus, for now, I'm writing a truth table function.
  """
  def table(n, f) do
    Enum.map(1..n, fn _ -> [true, false] end)
    |> Lists.cartesian_product()
    |> Enum.map(fn inputs -> inputs ++ [f.(inputs)] end)
  end

  @doc """
  Return an n-bit Gray code.

  An n-bit Gray code is a sequence of n-bit strings constructed according to certain rules. For example,

    iex> Logic.gray(1)
    ["0", "1"]
    iex> Logic.gray(2)
    ["00", "01", "11", "10"]
    iex> Logic.gray(3)
    ["000", "001", "011", "010", "110", "111", "101", "100"]
  """
  def gray(n) when n > 0 do
    gray(n, 1, ['0', '1'])
    |> Enum.map(fn x -> to_string([x]) end)
  end

  defp gray(n, n, current), do: current

  defp gray(n, i, current) do
    first_part =
      current
      |> Enum.map(fn x -> ['0' | x] end)

    second_part =
      current
      |> Enum.reverse()
      |> Enum.map(fn x -> ['1' | x] end)

    gray(n, i + 1, first_part ++ second_part)
  end

  defmodule Node do
    defstruct label: nil, value: nil, left_child: nil, right_child: nil

    def leaf?(%Node{left_child: nil, right_child: nil}), do: true
    def leaf?(_), do: false
  end

  def depth_first_search(root, func, initial_acc) do
    visit(root, [], func, initial_acc)
  end

  defp visit(node, trail, acc, func) do
    if Node.leaf?(node) do
      # First, let's work out the new acc
      new_acc = func.(acc, node, trail)

      [{parent, direction} | t] = trail

      case direction do
        :left ->
          # We now can visit the right child, as in our case, any non-leaf node *will* have
          # both children.
          visit(parent.right_child, [{parent, :right} | t], new_acc, func)
        :right ->
          # We go back up, indicating that we came from the right child.
          backtrack({parent, :right}, t, new_acc, func)
      end
    else
      visit(node.left_child, [{node, :left} | trail], acc, func)
    end
  end

  defp backtrack({_, :right}, [], acc, _) do
    # Right, the lack of trail means that we're back at the root.
    # And the fact that we arrived from the right means that we've done every node!
    acc
  end

  defp backtrack({_, :right}, [h | t], acc, func) do
    # We came back up via the right child, so we must have visited both children.
    # That's why we go back up to the parent.
    backtrack(h, t, acc, func)
  end

  defp backtrack({node, :left}, trail, acc, func) do
    # We came back up from the left child, so we must have finished the entire left side.
    # Thus we make a move on the right child.
    visit(node.right_child, [{node, :right} | trail], acc, func)
  end
end
