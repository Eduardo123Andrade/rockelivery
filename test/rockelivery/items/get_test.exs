defmodule Rockelivery.Items.GetTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Get

  describe "call" do
    test "when exists a item with this id, return a item" do
      %Item{id: id} = insert(:item)

      founded_item = Get.call(id)

      assert {:ok, %Item{category: :food, description: "Pizza de frango"}} = founded_item
    end

    test "when item not found, return a error" do
      id = "70247b75-fd37-4c21-bead-ae4996696f9a"
      response = Get.call(id)

      assert {:error, %Error{status: :not_found, result: "Item not found"}} = response
    end
  end
end
