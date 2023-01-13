defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.{Item, User}

  def user_params_factory do
    %{
      "age" => 26,
      "address" => "Winterfell",
      "cep" => "00000000",
      "cpf" => "00000000000",
      "email" => "email@email",
      "password" => "123123",
      "name" => "Stark"
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

  def item_params_factory do
    %{
      category: :food,
      description: "Pizza de frango",
      photo: "https://www.google.com",
      price: Decimal.new("30.0")
    }
  end

  def item_factory do
    %Item{
      category: :food,
      description: "Pizza de frango",
      photo: "https://www.google.com",
      price: Decimal.new("30.0"),
      id: "70247b75-fd37-4c21-bead-ae4996696f9e"
    }
  end

  def cep_info_factory do
    %{
      "cep" => "01001-000",
      "logradouro" => "Praça da Sé",
      "complemento" => "lado ímpar",
      "bairro" => "Sé",
      "localidade" => "São Paulo",
      "uf" => "SP",
      "ibge" => "3550308",
      "gia" => "1004",
      "ddd" => "11",
      "siafi" => "7107"
    }
  end
end
