defmodule Rockelivery.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rockelivery.{Item, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:address, :comments, :payment_method, :user_id]
  @payment_methods [:money, :credit_card, :debit_card]

  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "orders" do
    field :payment_method, Ecto.Enum, values: @payment_methods
    field :comments, :string
    field :address, :string

    many_to_many :item, Item, join_through: "orders_items"
    belongs_to :user, User

    timestamps()
  end

  def changeset(params, items) do
    changes(%__MODULE__{}, params, items)
  end

  def changeset(struct, params, items) do
    changes(struct, params, items)
  end

  defp changes(struct, params, items) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> put_assoc(:item, items)
    |> validate_length(:address, min: 8)
    |> validate_length(:comments, min: 6)
  end
end
