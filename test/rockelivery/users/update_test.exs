defmodule Rockelivery.Users.UpdateTest do
  use Rockelivery.DataCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.{Create, Update}
  alias Rockelivery.ViaCep.ClientMock

  describe "call/1" do
    test "when all params are valid, return a user with updated data" do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      {:ok, user} = Create.call(params)

      updated_params = %{"id" => user.id, "name" => "Lord Stark"}

      updated_user = Update.call(updated_params)

      assert {:ok, %User{name: "Lord Stark"}} = updated_user
    end

    test "when are invalid param, return a error" do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      {:ok, user} = Create.call(params)

      updated_params = %{"id" => user.id, "age" => 10}

      response = Update.call(updated_params)

      expected_response = %{
        age: ["must be greater than or equal to 18"]
      }

      assert {:error, %Error{result: changeset, status: :bad_request}} = response
      assert errors_on(changeset) == expected_response
    end

    test "when id not found, return a error" do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"
      response = Update.call(%{"id" => id})

      assert {:error, %Error{status: :not_found, result: "User not found"}} = response
    end
  end
end
