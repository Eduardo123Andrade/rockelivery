defmodule Rockelivery.ItemTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.Item

  describe "changeset/1" do
    test "when all params are valid, return a valid changeset" do
      params = build(:item_params)

      response = Item.changeset(params)

      assert %Changeset{changes: %{category: :food, description: "Pizza de frango"}, valid?: true} =
               response
    end

    test "when there invalid params, return a error" do
      params = build(:item_params, %{description: "Pizza", price: Decimal.new("0")})

      response = Item.changeset(params)

      expected_response = %{
        description: ["should be at least 6 character(s)"],
        price: ["must be greater than 0"]
      }

      assert errors_on(response) == expected_response
    end
  end

  describe "changeset/2" do
    test "when all params are valid, return a valid changeset" do
      params = build(:item_params)

      update_params = %{description: "Sorvete de whey"}

      response =
        params
        |> Item.changeset()
        |> Item.changeset(update_params)

      assert %Changeset{changes: %{description: "Sorvete de whey"}, valid?: true} = response
    end

    test "when there some error, return a error" do
      params = build(:item_params, %{description: "Pizza", price: Decimal.new("0")})

      response = Item.changeset(params)

      expected_response = %{
        description: ["should be at least 6 character(s)"],
        price: ["must be greater than 0"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
