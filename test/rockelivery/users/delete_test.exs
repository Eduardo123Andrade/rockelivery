defmodule Rockelivery.Users.DeleteTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.{Create, Delete}

  describe "call/1" do
    test "when exists a user with id, delete a user" do
      params = build(:user_params)

      {:ok, %User{id: id}} = Create.call(params)

      founded_user = Delete.call(id)

      assert {:ok,
              %User{
                id: id,
                age: 26,
                cpf: "00000000000",
                name: "Stark"
              }} = founded_user
    end

    test "when id not found, return a error" do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"
      response = Delete.call(id)

      assert {:error, %Error{status: :not_found, result: "User not found"}} = response
    end
  end
end
