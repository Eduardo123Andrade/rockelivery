defmodule Rockelivery.Users.Delete do
  alias Ecto.UUID
  alias Rockelivery.{Repo, User}

  def call(id) do
    case UUID.cast(id) do
      :error -> error_message(:bad_request, "Invalid id format")
      {:ok, id} -> delete(id)
    end
  end

  defp delete(id) do
    case Repo.get(User, id) do
      nil -> error_message(:not_found, "User not found")
      user -> Repo.delete(user)
    end
  end

  defp error_message(status, message), do: {:error, %{status: status, result: message}}
end
