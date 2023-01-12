defmodule Rockelivery.Orders.ItemsParams do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}

  @required_params [:id, :quantity]

  @derive {Jason.Encoder, only: @required_params}

  schema "items_params" do
    field :quantity, :integer
  end

  def changeset(params) do
    changes(%__MODULE__{}, params)
  end

  defp changes(struct, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_number(:quantity, greater_than_or_equal_to: 1)
  end
end
