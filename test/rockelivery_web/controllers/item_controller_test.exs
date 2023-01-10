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

  describe "show/2" do
    test "when find item with this id, return a item", %{conn: conn} do
      %{id: id} = insert(:item)

      response =
        conn
        |> get(Routes.items_path(conn, :show, id))
        |> json_response(:ok)

      expected_response = %{
        "item" => %{
          "category" => "food",
          "description" => "Pizza de frango",
          "id" => "70247b75-fd37-4c21-bead-ae4996696f9e",
          "photo" => "https://www.google.com",
          "price" => "30.0"
        }
      }

      assert expected_response == response
    end

    test "when item not found, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"

      response =
        conn
        |> get(Routes.items_path(conn, :show, id))
        |> json_response(:not_found)

      assert %{"message" => "Item not found"} = response
    end

    test "where given a invalid id, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60"

      response =
        conn
        |> get(Routes.items_path(conn, :show, id))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid UUID"} = response
    end
  end

  describe "delete/2" do
    test "when item was founded, delete it", %{conn: conn} do
      %{id: id} = insert(:item)

      response =
        conn
        |> delete(Routes.items_path(conn, :delete, id))
        |> response(:no_content)

      expected_response = ""
      assert expected_response == response
    end

    test "when item not found, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"

      response =
        conn
        |> delete(Routes.items_path(conn, :delete, id))
        |> json_response(:not_found)

      assert %{"message" => "Item not found"} = response
    end

    test "where given a invalid id, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60"

      response =
        conn
        |> delete(Routes.items_path(conn, :delete, id))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid UUID"} = response
    end
  end

  describe "update/2" do
    test "when all params is valid, return a updated item", %{conn: conn} do
      %{id: id} = insert(:item)

      updated_params = %{"id" => id, "description" => "Pizza de 4 queijos"}

      response =
        conn
        |> put(Routes.items_path(conn, :update, id), updated_params)
        |> json_response(:ok)

      assert %{
               "item" => %{
                 "category" => "food",
                 "description" => "Pizza de 4 queijos",
                 "id" => _id,
                 "photo" => "https://www.google.com",
                 "price" => "30.0"
               }
             } = response
    end

    test "when item not found, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60a"

      response =
        conn
        |> put(Routes.items_path(conn, :update, id))
        |> json_response(:not_found)

      assert %{"message" => "Item not found"} = response
    end

    test "where given a invalid id, return a error", %{conn: conn} do
      id = "957da868-ce7f-4eec-bcdc-97b8c992a60"

      response =
        conn
        |> put(Routes.items_path(conn, :update, id))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid UUID"} = response
    end
  end
end
