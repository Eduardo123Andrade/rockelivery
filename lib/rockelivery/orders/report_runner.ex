defmodule Rockelivery.Orders.ReportRunner do
  alias Rockelivery.Orders.Report
  use GenServer

  require Logger

  # Client

  def start_link(_initial_stack) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    Logger.info("ReportRunner started...")
    schedule_report_generation()
    {:ok, state}
  end

  @impl true
  # recebe qualquer tipo de mensagem
  # que nao tem handle_call ou handle_cast para receber a mensagem
  def handle_info(:generate, state) do
    Logger.info("Generate report...")

    Report.create()
    schedule_report_generation()
    {:noreply, state}
  end

  defp schedule_report_generation do
    Process.send_after(self(), :generate, 1000 * 20)
  end
end
