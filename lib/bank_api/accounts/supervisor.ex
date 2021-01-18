defmodule BankAPI.Accounts.Supervisor do
  use Supervisor

  alias BankAPI.Accounts
  alias BankAPI.Events

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      Events,
      Accounts.Projectors.AccountOpened
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
