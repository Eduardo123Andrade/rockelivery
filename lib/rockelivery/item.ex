defmodule Rockelivery.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:category, :description, :price, :photo]
  @items_category [:food, :drink, :desert]

  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "item" do
    field :category, Ecto.Enum, values: @items_category
    field :description, :string
    field :price, :decimal
    field :photo, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> changes(@required_params)
  end

  defp changes(struct, fields) do
    struct
    |> validate_required(fields)
    |> validate_length(:description, min: 6)
    |> validate_number(:price, greater_than: 0)
  end
end
