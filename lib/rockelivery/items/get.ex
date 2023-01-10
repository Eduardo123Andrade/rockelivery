defmodule Rockelivery.Items.Get do
  alias Rockelivery.{Error, Repo, Item}

  def call(id) do
    case Repo.get(Item, id) do
      nil -> {:error, Error.build_item_not_found_error()}
      item -> {:ok, item}
    end
  end
end
