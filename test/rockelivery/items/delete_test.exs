defmodule Rockelivery.Items.DeleteTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Delete

  describe "call/1" do
    test "when are a item with this id, delete the item" do
      %Item{id: id} = insert(:item)

      deleted_item = Delete.call(id)

      assert {:ok, %Item{category: :food, description: "Pizza de frango"}} = deleted_item
    end

    test "when item not found, return a error" do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"
      response = Delete.call(id)

      assert {:error, %Error{status: :not_found, result: "Item not found"}} = response
    end
  end
end
