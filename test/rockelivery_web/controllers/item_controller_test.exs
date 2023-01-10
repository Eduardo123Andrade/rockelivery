defmodule RockeliveryWeb.ItemControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory

  describe "create/2" do
    test "when all params is valid, create a item", %{conn: conn} do
      params = %{
        "category" => "food",
        "description" => "Pizza de frango",
        "photo" => "https://www.google.com",
        "price" => "30.0"
      }

      response =
        conn
        |> post(Routes.items_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "Item created",
               "item" => %{
                 "id" => _id,
                 "category" => "food",
                 "description" => "Pizza de frango",
                 "photo" => "https://www.google.com",
                 "price" => "30.0"
               }
             } = response
    end

    test "when there a invalid params, return a error", %{conn: conn} do
      params = %{
        "category" => "food",
        "description" => "Pizza"
      }

      response =
        conn
        |> post(Routes.items_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "description" => ["should be at least 6 character(s)"],
          "photo" => ["can't be blank"],
          "price" => ["can't be blank"]
        }
      }

      assert expected_response == response
    end
  end
end
