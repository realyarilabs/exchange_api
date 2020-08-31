defmodule ExchangeApi.Repo do
  use Ecto.Repo,
    otp_app: :exchange_api,
    adapter: Ecto.Adapters.Postgres
end
