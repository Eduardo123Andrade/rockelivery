defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.User

  def user_params_factory do
    %{
      age: 26,
      address: "Winterfell",
      cep: "00000000",
      cpf: "00000000000",
      email: "email@email",
      password: "123123",
      name: "Stark"
    }
  end

  def user_factory do
    %User{
      age: 26,
      address: "Winterfell",
      cep: "00000000",
      cpf: "00000000000",
      email: "email@email",
      password: "123123",
      name: "Stark",
      id: "957da868-ce7f-4eec-bcdc-97b8c992a60d"
    }
  end
end
