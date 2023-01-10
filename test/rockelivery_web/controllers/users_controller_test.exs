defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory

  describe "create/2" do
    test "when all params are valid, creates the user", %{conn: conn} do
      params = %{
        "age" => 26,
        "address" => "Winterfell",
        "cep" => "00000000",
        "cpf" => "00000000000",
        "email" => "email@email",
        "password" => "123123",
        "name" => "Stark"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created",
               "user" => %{
                 "address" => "Winterfell",
                 "age" => 26,
                 "cpf" => "00000000000",
                 "email" => "email@email",
                 "name" => "Stark",
                 "id" => _id
               }
             } = response
    end

    test "when theres is some error, returns the error", %{conn: conn} do
      params = %{
        "age" => 26,
        "address" => "Winterfell"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "cep" => ["can't be blank"],
          "cpf" => ["can't be blank"],
          "email" => ["can't be blank"],
          "name" => ["can't be blank"],
          "password" => ["can't be blank"]
        }
      }

      assert expected_response == response
    end
  end

  describe "delete/2" do
    test "when there is a user with the given id, delete this user", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"

      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end

    test "where user not found, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"

      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:not_found)

      assert %{"message" => "User not found"} = response
    end

    test "where given a invalid id, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60"

      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid UUID"} = response
    end
  end

  describe "show/2" do
    test "when theres a valid id, return a user", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"

      insert(:user)

      response =
        conn
        |> get(Routes.users_path(conn, :show, id))
        |> json_response(:ok)

      assert %{
               "user" => %{
                 "id" => "957da868-ce7f-4eec-bcdc-97b8c992a60d",
                 "age" => 26,
                 "cpf" => "00000000000",
                 "address" => "Winterfell",
                 "email" => "email@email",
                 "name" => "Stark"
               }
             } = response
    end

    test "where user not found, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"

      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:not_found)

      assert %{"message" => "User not found"} = response
    end

    test "where given a invalid id, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60"

      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid UUID"} = response
    end
  end

  describe "update2" do
    test "when all parameters are valid, return a updated user", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"
      update_params = build(:user_params, %{name: "Lord Stark", age: 30, id: id})

      insert(:user)

      response =
        conn
        |> put(Routes.users_path(conn, :update, id), update_params)
        |> json_response(:ok)

      expected_response = %{
        "user" => %{
          "address" => "Winterfell",
          "age" => 30,
          "cpf" => "00000000000",
          "email" => "email@email",
          "id" => "957da868-ce7f-4eec-bcdc-97b8c992a60d",
          "name" => "Lord Stark"
        }
      }

      assert expected_response == response
    end

    test "when some params are invalid, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60d"
      update_params = build(:user_params, %{age: 10, id: id})

      insert(:user)

      response =
        conn
        |> put(Routes.users_path(conn, :update, id), update_params)
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"age" => ["must be greater than or equal to 18"]}}

      assert expected_response == response
    end

    test "where user not found, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"

      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:not_found)

      assert %{"message" => "User not found"} = response
    end

    test "where given a invalid id, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60"

      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid UUID"} = response
    end
  end
end
