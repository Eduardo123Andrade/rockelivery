defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  # import Rockelivery.Factory

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
end
