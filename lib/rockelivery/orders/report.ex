defmodule Rockelivery.Orders.Report do
  import Ecto.Query

  alias Rockelivery.Orders.TotalPrice
  alias Rockelivery.{Item, Order, Repo}

  @default_block_size 500

  def create(filename \\ "report.csv") do
    {:ok, order_list} = Repo.transaction(&do_transaction/0, timeout: :infinity)
    File.write(filename, order_list)
  end

  defp do_transaction do
    query = from order in Order, order_by: order.user_id

    query
    |> Repo.stream(max_rows: @default_block_size)
    |> Stream.chunk_every(@default_block_size)
    |> Stream.flat_map(fn chunk -> Repo.preload(chunk, :item) end)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(%Order{user_id: user_id, payment_method: payment_method, item: items}) do
    total_price = TotalPrice.call(items)
    items_string = Enum.map(items, fn item -> items_string(item) end)
    "#{user_id},#{payment_method},#{items_string},#{total_price}\n"

    # line
    # |> String.trim()
    # |> String.split(",")
    # |> List.update_at(2, &String.to_integer/1)
  end

  defp items_string(%Item{category: category, price: price, description: description}) do
    "[#{category},#{description},#{price}]"
  end
end
