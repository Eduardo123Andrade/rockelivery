defmodule Rockelivery.Items.UpdateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Update

  describe "call/1" do
    test "when all params are valid, return a item with updated data" do
      %{id: id} = insert(:item)

      updated_params = %{"id" => id, "description" => "Pizza de presunto"}

      update_item = Update.call(updated_params)

      assert {:ok, %Item{description: "Pizza de presunto"}} = update_item
    end
  end

  test "when item not found, return a error" do
    id = "70247b75-fd37-4c21-bead-ae4996696f9a"
    insert(:item)

    updated_params = %{"id" => id, "description" => "Pizza de presunto"}

    response = Update.call(updated_params)

    assert {:error, %Error{status: :not_found, result: "Item not found"}} = response
  end

  test "When there some invalid params, return a error" do
    %{id: id} = insert(:item)

    updated_params = %{"id" => id, "description" => "Pizza", "category" => "invalid_category"}

    response = Update.call(updated_params)

    expected_response = %{
      category: ["is invalid"],
      description: ["should be at least 6 character(s)"]
    }

    assert {:error, %Error{result: changeset, status: :bad_request}} = response
    assert errors_on(changeset) == expected_response
  end
end
