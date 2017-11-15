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
end
