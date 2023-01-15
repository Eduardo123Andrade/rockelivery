defmodule RockeliveryWeb.UsersViewTest do
  alias RockeliveryWeb.UsersView
  use RockeliveryWeb.ConnCase, async: true
  import Phoenix.View
  import Rockelivery.Factory

  test "renders create.json" do
    user = build(:user)
    token = "xpto1234"
    response = render(UsersView, "create.json", user: user, token: token)

    assert %{
             message: "User created",
             token: "xpto1234",
             user: %Rockelivery.User{
               id: "957da868-ce7f-4eec-bcdc-97b8c992a60d",
               age: 26,
               address: "Winterfell",
               cep: "00000000",
               cpf: "00000000000",
               email: "email@email",
               password: "123123",
               password_hash: nil,
               name: "Stark",
               inserted_at: nil,
               updated_at: nil
             }
           } == response
  end
end
