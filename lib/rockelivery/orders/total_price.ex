defmodule Rockelivery.Orders.TotalPrice do
  alias Rockelivery.Item

  def call(items) do
    Enum.reduce(items, Decimal.new("0.00"), &sum_prices/2)
  end

  defp sum_prices(%Item{price: price}, accumulator), do: Decimal.add(price, accumulator)
end
