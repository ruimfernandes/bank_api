defmodule BankAPI.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias BankAPI.Repo
  alias BankAPI.Router
  alias BankAPI.Accounts.Commands.{CloseAccount, OpenAccount}
  alias BankAPI.Accounts.Projections.Account

  def uuid_regex do
    ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  end

  def get_account(id) do
    case Repo.get(Account, id) do
      %Account{} = account ->
        {:ok, account}

      _reply ->
        {:error, :not_found}
    end
  end

  def close_account(id) do
    %CloseAccount{
      account_uuid: id
    }
    |> Router.dispatch()
  end

  def open_account(%{"initial_balance" => initial_balance}) do
    account_uuid = UUID.uuid4()

    dispatch_result =
      %OpenAccount{
        initial_balance: initial_balance,
        account_uuid: account_uuid
      }
      |> Router.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        get_account(account_uuid)

      reply ->
        reply
    end
  end

  def open_account(_params), do: {:error, :bad_command}
end
