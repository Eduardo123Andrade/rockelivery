defmodule Rockelivery.Users.UpdateTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.{Create, Update}

  describe "call/1" do
    test "when all params are valid, return a user with updated data" do
      params = build(:user_params)

      {:ok, user} = Create.call(params)

      updated_params = %{"id" => user.id, "name" => "Lord Stark"}

      updated_user = Update.call(updated_params)

      assert {:ok, %User{name: "Lord Stark"}} = updated_user
    end

    test "when id not found, return a error" do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"
      response = Update.call(%{"id" => id})

      assert {:error, %Error{status: :not_found, result: "User not found"}} = response
    end
  end
end
