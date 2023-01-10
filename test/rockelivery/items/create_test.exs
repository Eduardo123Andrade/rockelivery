defmodule Rockelivery.Items.CreateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, Item}
  alias Rockelivery.Items.Create

  describe "call/1" do
    test "when all params are valid, return a item" do
      response =
        build(:item_params)
        |> Create.call()

      assert {:ok, %Item{category: :food, description: "Pizza de frango"}} = response
    end

    test "When there are invalid params, return a error" do
      response =
        build(:item_params, %{price: Decimal.new("0"), category: "invalid_category"})
        |> Create.call()

      expected_response = %{
        category: ["is invalid"],
        price: ["must be greater than 0"]
      }

      assert {:error, %Error{result: changeset, status: :bad_request}} = response
      assert errors_on(changeset) == expected_response
    end
  end
end
