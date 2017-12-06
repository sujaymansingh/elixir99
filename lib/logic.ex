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
end
