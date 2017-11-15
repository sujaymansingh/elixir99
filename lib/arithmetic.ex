defmodule Arithmetic do
  @doc """
  Determine whether a given integer number is prime.

    iex> Arithmetic.prime?(7)
    true
  """
  def prime?(1), do: true
  def prime?(2), do: true
  def prime?(n) when n > 2, do: prime?(n, 2)

  defp prime?(n, n), do: true

  defp prime?(n, i) do
    case rem(n, i) do
      0 -> false
      _ -> prime?(n, i + 1)
    end
  end

  @doc """
  Given a number n, return the smallest prime p such that p > n

    iex> Arithmetic.next_prime(2)
    3
    iex> Arithmetic.next_prime(5000)
    5003
  """
  def next_prime(n) do
    if prime?(n + 1) do
      n + 1
    else
      next_prime(n + 1)
    end
  end

  @doc """
  Determine the prime factors of a given positive integer.

    iex> Arithmetic.prime_factors(315)
    [3, 3, 5, 7]
    iex> Arithmetic.prime_factors(-1)
    []
  """
  def prime_factors(n) when n < 1, do: []

  def prime_factors(n) do
    prime_factors(n, 2, [])
  end

  defp prime_factors(1, _, acc), do: Lists.reverse(acc)

  defp prime_factors(n, p, acc) do
    remainder = rem(n, p)

    if remainder == 0 do
      next_n = div(n, p)
      prime_factors(next_n, p, [p | acc])
    else
      next_p = next_prime(p)
      prime_factors(n, next_p, acc)
    end
  end

  @doc """
  Determine the prime factors of a given positive integer (2).

  Construct a list containing the prime factors and their multiplicity.

    iex> Arithmetic.prime_factors_mult(315)
    [{3, 2}, {5, 1}, {7, 1}]
  """
  def prime_factors_mult(n) do
    n
    |> prime_factors
    |> Lists.encode()
    |> Enum.map(fn {a, b} -> {b, a} end)
  end

  @doc """
  A list of prime numbers.

  Given a range of integers by its lower and upper limit, construct a list of all prime numbers in that range.

    iex> Arithmetic.prime_numbers_in_range(1, 20)
    [1, 2, 3, 5, 7, 11, 13, 17, 19]
  """
  def prime_numbers_in_range(n1, n2) do
    Lists.range(n1, n2) |> Enum.filter(&prime?/1)
  end
end
