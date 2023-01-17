defmodule Rockelivery.Orders.ValidateItems do
  alias Ecto.Changeset
  alias Rockelivery.Error
  alias Rockelivery.Orders.ItemsParams

  def call(items_params) do
    items_params
    |> Enum.map(fn item -> ItemsParams.changeset(item) end)
    |> Enum.filter(fn %Changeset{valid?: valid} -> !valid end)
    |> handle_items(items_params)
  end

  defp handle_items([], items), do: {:ok, items}

  defp handle_items(_invalid_list_item, _items),
    do: {:error, Error.build(:bad_request, "Invalid quantity")}
end
