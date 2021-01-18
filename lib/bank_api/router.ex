defmodule BankAPI.Router do
  use Commanded.Commands.Router, application: BankAPI.Events

  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.OpenAccount

  middleware(BankAPI.Middleware.ValidateCommand)

  dispatch([OpenAccount], to: Account, identity: :account_uuid)
end
