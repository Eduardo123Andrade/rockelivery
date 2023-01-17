defmodule Rockelivery.ViaCep.ClientTest do
  alias Plug.Conn
  alias Rockelivery.Error
  alias Rockelivery.ViaCep.Client

  use ExUnit.Case, async: true

  describe "get_cep_info/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when there is a valid cep, return the cep info", %{bypass: bypass} do
      cep = "01001000"

      url = endpoint_url(bypass.port)

      body = ~s({
        "cep": "01001-000",
        "logradouro": "Praça da Sé",
        "complemento": "lado ímpar",
        "bairro": "Sé",
        "localidade": "São Paulo",
        "uf": "SP",
        "ibge": "3550308",
        "gia": "1004",
        "ddd": "11",
        "siafi": "7107"
      })

      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:ok,
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
         }}

      assert expected_response == response
    end

    test "when cep is invalid, return an error", %{bypass: bypass} do
      cep = "123"

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        Conn.resp(conn, 400, "")
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, %Error{result: "Invalid cep", status: :bad_request}}

      assert expected_response == response
    end

    test "when cep was not found, return a error", %{bypass: bypass} do
      cep = "123"

      body = ~s({"erro": true})

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, %Error{result: "Cep not found", status: :not_found}}

      assert expected_response == response
    end

    test "when there is a generic error, return a error", %{bypass: bypass} do
      cep = "00000000"

      url = endpoint_url(bypass.port)

      Bypass.down(bypass)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, %Error{result: :econnrefused, status: :not_found}}

      assert expected_response == response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}/"
  end
end
