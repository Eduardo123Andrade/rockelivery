defmodule Rockelivery.ViaCep.Client do
  use Tesla

  alias Rockelivery.Error
  alias Tesla.Env

  plug Tesla.Middleware.BaseUrl, "https://viacep.com.br/ws/"
  plug Tesla.Middleware.JSON

  def get_cep_info(cep) do
    "#{cep}/json"
    |> get()
    |> handle_get()
  end

  defp handle_get({:ok, %Env{body: %{"erro" => true}, status: 200}}) do
    {:error, Error.build(:not_found, "Cep not found")}
  end

  defp handle_get({:ok, %Env{status: 200, body: body}}), do: {:ok, body}

  defp handle_get({:ok, %Env{body: _body, status: 400}}) do
    {:error, Error.build(:not_found, "Invalid cep")}
  end

  defp handle_get({:error, reason}) do
    {:error, Error.build(:not_found, reason)}
  end
end
