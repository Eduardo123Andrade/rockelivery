defmodule Rockelivery.Items.GetTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Get

  describe "call/1" do
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

  describe "call/0" do
    test "return all items" do
      insert(:item)
      insert(:item, %{id: "c29d68c9-f2a0-4326-b321-50c02f7a37ae"})

      {:ok, founded_items} = Get.call()

      [first_item | _] = founded_items

      expected_quantity_of_items = 2

      assert expected_quantity_of_items == Enum.count(founded_items)

      assert %{
               id: "70247b75-fd37-4c21-bead-ae4996696f9e",
               category: :food,
               description: "Pizza de frango"
             } = first_item
    end

    test "when doesnt have item, return a empty array" do
      {:ok, founded_items} = Get.call()
      assert Enum.empty?(founded_items) == true
    end
  end
end
