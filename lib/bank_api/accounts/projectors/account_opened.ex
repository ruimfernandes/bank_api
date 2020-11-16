defmodule BankAPI.Accounts.Projectors.AccountOpened do
  use Commanded.Event.Handler,
    name: "Accounts.Projectors.AccountOpened",
    application: BankAPI.Events,
    start_from: :origin,
    consistency: :strong

  alias BankAPI.Repo
  alias BankAPI.Accounts.Events.AccountOpened
  alias BankAPI.Accounts.Projections.Account

  def handle(%AccountOpened{} = event, _metadata) do
    case %Account{
      uuid: event.account_uuid,
      current_balance: event.initial_balance
    }
    |> Repo.insert(on_conflict: :nothing) do
      {:ok, _order} -> :ok
      error -> error
    end
  end
end