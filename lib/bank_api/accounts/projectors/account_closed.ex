defmodule BankAPI.Accounts.Projectors.AccountClosed do
  use Commanded.Event.Handler,
    name: "Accounts.Projectors.AccountClosed",
    application: BankAPI.Events,
    start_from: :origin,
    consistency: :strong

  alias BankAPI.Repo
  alias BankAPI.Accounts
  alias BankAPI.Accounts.Events.AccountClosed
  alias BankAPI.Accounts.Projections.Account
  alias Ecto.Changeset

  def handle(%AccountClosed{} = event, _metadata) do
    with {:ok, %Account{} = account} <- Accounts.get_account(event.account_uuid) do
      case account
           |> Changeset.change(status: Account.status().closed)
           |> Repo.update() do
        {:ok, _account} -> :ok
        error -> error
      end
    else
      _ -> nil
    end
  end
end
