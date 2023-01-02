defmodule Rockelivery.Factory do
  use ExMachina

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
end
