defmodule Rockelivery.Users.Get do
  alias Ecto.UUID
  alias Rockelivery.{Error, Repo, User}

  # Just an example
  # def by_id(id) do
  #   with {:ok, uuid} <- UUID.cast(id),
  #        %User{} = user <- Repo.get(User, uuid) do
  #     {:ok, user}
  #   else
  #     :error -> error_message(:bad_request, "Invalid id format")
  #     nil -> error_message(:not_found, "User not found")
  #   end
  # end

  def by_id(id) do
    case UUID.cast(id) do
      :error -> {:error, Error.build_format_error()}
      {:ok, id} -> get(id)
    end
  end

  defp get(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.build_user_not_found_error()}
      user -> {:ok, user}
    end
  end
end
