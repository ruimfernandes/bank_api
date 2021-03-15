defmodule BankAPI.Accounts.Lifespan do
  @behaviour Commanded.Aggregates.AggregateLifespan

  alias BankAPI.Accounts.Events.AccountClosed

  def after_event(%AccountClosed{}), do: :stop

  def after_event(_event), do: :infinity

  @doc """
  Aggregate will run indefinitely once started.
  """
  def after_command(_command), do: :infinity

  @doc """
  Aggregate will run indefinitely once started.
  """
  def after_error(_error), do: :infinity
end
