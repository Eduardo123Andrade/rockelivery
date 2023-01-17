defmodule Rockelivery.Orders.ValidateUuid do
  # alias Ecto.Changeset
  # alias Rockelivery.Orders.ItemsParams
  alias Ecto.UUID
  alias Rockelivery.Error

  def call(items_params) do
    items_params
    |> Enum.map(fn value -> validate_uuid(value) end)
    |> Enum.filter(fn {status, _} -> status == :error end)
    |> handle_uuid(items_params)
  end

  defp validate_uuid(%{"id" => id} = value) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid id"}
      {:ok, _uuid} -> {:ok, value}
    end
  end

  defp handle_uuid([], items), do: {:ok, items}

  defp handle_uuid(_invalid_list_item, _items),
    do: {:error, Error.build(:bad_request, "Invalid id")}
end
