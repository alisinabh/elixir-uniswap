defmodule Uniswap.Price.Utils do
  @moduledoc """
  Helper functions for calculation and interaction with Uniswap DEX.
  """

  @tick_base 1.0001

  @doc """
  Converts a price to it's corresponding tick

  Price is how much token1 is for a token0

  ## Examples

  iex> Uniswap.Price.Utils.price_to_tick(0.000551413, 10, 6, 18)
  201290

  iex> Uniswap.Price.Utils.price_to_tick(1 / 1474.44, 10, 6, 18)
  203360
  """
  def price_to_tick(price, tick_spacing, token0_decimals \\ 18, token1_decimals \\ 18) do
    (:math.log(price / :math.pow(10, token0_decimals - token1_decimals)) /
       :math.log(@tick_base))
    |> round()
    |> nearest_tick(tick_spacing)
  end

  @doc """
  Converts a tick to it's corresponding price

  Price is how much token1 is for a token0

  ## Examples

  iex> Uniswap.Price.Utils.tick_to_price(201290, 6, 18)
  0.000551412440019572

  iex> Uniswap.Price.Utils.tick_to_price(203360, 6, 18)
  1 / 1474.4463585092642
  """
  def tick_to_price(price, token0_decimals \\ 18, token1_decimals \\ 18) do
    :math.pow(@tick_base, price) * :math.pow(10, token0_decimals - token1_decimals)
  end

  @doc """
  Returns the nearest tick with respect to tick spacing

  ## Examples

  iex> Uniswap.Price.Utils.nearest_tick(23, 2)
  24

  iex> Uniswap.Price.Utils.nearest_tick(44, 10)
  40

  iex> Uniswap.Price.Utils.nearest_tick(45, 10)
  50

  iex> Uniswap.Price.Utils.nearest_tick(46, 10)
  50
  """
  def nearest_tick(tick, spacing) do
    spacing * round(tick / spacing)
  end

  @doc """
  Converts a price to sqrtX96 format.
  More info https://docs.uniswap.org/sdk/guides/fetching-prices#understanding-sqrtprice

  To get the price of token_0 per token_1 just use `1 / Utils.from_sqrt_x96(...)`.

  ## Examples

  iex> Uniswap.Price.Utils.to_sqrt_x96(0.000627337, 6, 18)
  1984403731948787316926650586759168
  """
  def to_sqrt_x96(price, token_0_decimals \\ 18, token_1_decimals \\ 18) do
    (:math.sqrt(price * :math.pow(10, abs(token_0_decimals - token_1_decimals))) *
       :math.pow(2, 96))
    |> trunc
  end

  @doc """
  Converts sqrtX96 price into human readable price
  More info https://docs.uniswap.org/sdk/guides/fetching-prices#understanding-sqrtprice

  To get the price of token_0 per token_1 just use `1 / Utils.from_sqrt_x96(...)`.

  ## Examples

  iex> Uniswap.Price.Utils.from_sqrt_x96(1984403731948787316926650586759168, 6, 18)
  6.273370000000002e-4
  """
  def from_sqrt_x96(sqrt_x96_price, token_0_decimals \\ 18, token_1_decimals \\ 18) do
    :math.pow(sqrt_x96_price / :math.pow(2, 96), 2) /
      :math.pow(10, abs(token_0_decimals - token_1_decimals))
  end
end
