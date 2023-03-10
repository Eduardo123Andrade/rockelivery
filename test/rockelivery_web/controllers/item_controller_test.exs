defmodule RockeliveryWeb.ItemControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory
  alias RockeliveryWeb.Auth.Guardian

  describe "create/2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn}
    end

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
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn}
    end

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

  describe "index/2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn}
    end

    test "return all items", %{conn: conn} do
      insert(:item)
      insert(:item, %{id: "c29d68c9-f2a0-4326-b321-50c02f7a37ae"})

      response =
        conn
        |> get(Routes.items_path(conn, :index))
        |> json_response(:ok)

      [first_item | _] = response
      expected_quantity_of_items = 2

      assert expected_quantity_of_items == Enum.count(response)

      assert %{
               "category" => "food",
               "description" => "Pizza de frango",
               "id" => "70247b75-fd37-4c21-bead-ae4996696f9e",
               "photo" => "https://www.google.com",
               "price" => "30.0"
             } = first_item
    end

    test "when doesn't have item, return a empty array", %{conn: conn} do
      response =
        conn
        |> get(Routes.items_path(conn, :index))
        |> json_response(:ok)

      assert Enum.empty?(response) == true
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn}
    end

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
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")
      {:ok, conn: conn}
    end

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
