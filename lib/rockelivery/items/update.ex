defmodule Rockelivery.Items.Update do
  alias Rockelivery.{Error, Repo, Item}

  def call(%{"id" => id} = params) do
    case Repo.get(Item, id) do
      nil -> {:error, Error.build_item_not_found_error()}
      item -> do_update(item, params)
    end
  end

  defp do_update(item, params) do
    item
    |> Item.changeset(params)
    |> Repo.update()
    |> handle_insert()
  end

  defp handle_insert({:ok, %Item{}} = result), do: result

  defp handle_insert({:error, result}) do
    {:error, Error.build(:bad_request, result)}
  end
end
