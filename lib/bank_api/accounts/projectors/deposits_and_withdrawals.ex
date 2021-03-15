defmodule BankAPI.Accounts.Projectors.DepositsAndWithdrawals do
  use Commanded.Event.Handler,
    name: "Accounts.Projectors.DepositsAndWithdrawals",
    application: BankAPI.Events,
    start_from: :origin,
    consistency: :strong

  alias BankAPI.Repo
  alias BankAPI.Accounts
  alias BankAPI.Accounts.Events.{DepositedIntoAccount, WithdrawnFromAccount}
  alias BankAPI.Accounts.Projections.Account
  alias Ecto.Changeset

  def handle(%DepositedIntoAccount{} = event, _metadata) do
    with {:ok, %Account{} = account} <- Accounts.get_account(event.account_uuid) do
      case account
           |> Changeset.change(current_balance: event.new_current_balance)
           |> Repo.update() do
        {:ok, _account} ->
          :ok

        error ->
          error
      end
    end
  end

  def handle(%WithdrawnFromAccount{} = event, _metadata) do
    with {:ok, %Account{} = account} <- Accounts.get_account(event.account_uuid) do
      case account
           |> Changeset.change(current_balance: event.new_current_balance)
           |> Repo.update() do
        {:ok, _account} ->
          :ok

        error ->
          error
      end
    end
  end

  # project(%DepositedIntoAccount{} = evt, _metadata, fn multi ->
  #   with {:ok, %Account{} = account} <- Accounts.get_account(evt.account_uuid) do
  #     Multi.update(
  #       multi,
  #       :account,
  #       Changeset.change(
  #         account,
  #         current_balance: evt.new_current_balance
  #       )
  #     )
  #   else
  #     # ignore when this happens
  #     _ -> multi
  #   end
  # end)

  # project(%WithdrawnFromAccount{} = evt, _metadata, fn multi ->
  #   with {:ok, %Account{} = account} <- Accounts.get_account(evt.account_uuid) do
  #     Multi.update(
  #       multi,
  #       :account,
  #       Changeset.change(
  #         account,
  #         current_balance: evt.new_current_balance
  #       )
  #     )
  #   else
  #     # ignore when this happens
  #     _ -> multi
  #   end
  # end)
end
