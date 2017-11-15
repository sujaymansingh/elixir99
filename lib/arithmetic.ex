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

  @doc """
  Goldbach's conjecture.

  Goldbach's conjecture says that every positive even number greater than 2 is the sum of two prime numbers.
  Example: 28 = 5 + 23.
  It is one of the most famous facts in number theory that has not been proved to be correct in the general case.
  It has been numerically confirmed up to very large numbers (much larger than we can go with our
  ~Prolog~ Elixir system).
  Write a predicate to find the two prime numbers that sum up to a given even integer.

    iex> Arithmetic.goldbach(28)
    {5, 23}

    Alternatively, you can specify that the primes *must* be at least a minimum.
    iex> Arithmetic.goldbach(28, 11)
    {11, 17}

    Even, if that would remove all prime pairs.
    iex> Arithmetic.goldbach(28, 19)
    nil
  """
  def goldbach(n, min_prime \\ 2) do
    if rem(n, 2) != 0 do
      nil
    else
      calculate_goldbach(n, min_prime)
    end
  end

  defp calculate_goldbach(n, min_prime) do
    matching_results =
      prime_numbers_in_range(1, n)
      |> calculate_goldbach(n, [])
      |> Enum.filter(fn {p1, p2} -> p1 >= min_prime and p2 >= min_prime end)

    case matching_results do
      [] -> nil
      [h | _] -> h
    end
  end

  defp calculate_goldbach([], _, acc), do: Lists.reverse(acc)

  defp calculate_goldbach([h | t], n, acc) do
    matching_primes = Enum.filter(t, fn x -> h + x == n end)

    if matching_primes == [] do
      calculate_goldbach(t, n, acc)
    else
      [result | _] = matching_primes
      calculate_goldbach(t, n, [{h, result} | acc])
    end
  end

  @doc """
  A list of Goldbach compositions.

  Given a range of integers by its lower and upper limit,
  return a list of all even numbers and their Goldbach composition.

    iex> Arithmetic.goldbach_list(9, 20)
    [{10, 3, 7}, {12, 5, 7}, {14, 3, 11}, {16, 3, 13}, {18, 5, 13}, {20, 3, 17}]
  """
  def goldbach_list(n1, n2, min_prime \\ 2) do
    Lists.range(n1, n2)
    |> Enum.filter(&(rem(&1, 2) == 0))
    |> Enum.map(fn n ->
         result = goldbach(n, min_prime)

         case result do
           nil -> {n, nil, nil}
           {p1, p2} -> {n, p1, p2}
         end
       end)
    |> Enum.filter(fn {_, p1, _} -> p1 != nil end)
  end

  @doc """
  Determine the greatest common divisor of two positive integer numbers.

  Use Euclid's algorithm.

    iex> Arithmetic.gcd(36, 63)
    9
    iex> Arithmetic.gcd(35, 64)
    1
  """
  def gcd(_, 1), do: 1
  def gcd(x, 0), do: x
  def gcd(a, b) when b > a, do: gcd(b, a)

  def gcd(a, b) do
    remainder = rem(a, b)
    gcd(b, remainder)
  end
end
