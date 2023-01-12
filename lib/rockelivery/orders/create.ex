defmodule Rockelivery.Orders.Create do
  import Ecto.Query

  alias Rockelivery.{Error, Item, Order, Repo}
  alias Rockelivery.Orders.{ValidateItems, ValidateAndMultiplyItems, ValidateUuid}

  def call(%{"items" => items_params} = params) do
    with {:ok, valid_items} <- ValidateItems.call(items_params),
         {:ok, _} <- ValidateUuid.call(items_params) do
      items_ids = Enum.map(items_params, fn item -> item["id"] end)

      query = from item in Item, where: item.id in ^items_ids

      query
      |> Repo.all()
      |> ValidateAndMultiplyItems.call(items_ids, valid_items)
      |> handle_items(params)
    end
  end

  defp handle_items({:ok, items}, params) do
    params
    |> Order.changeset(items)
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_items({:error, result}, _params), do: {:error, Error.build(:bad_request, result)}

  defp handle_insert({:ok, %Order{} = order}), do: {:ok, order}
  defp handle_insert({:error, result}), do: {:error, Error.build(:bad_request, result)}
end
