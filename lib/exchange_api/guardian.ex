defmodule ExchangeApi.Guardian do
  use Guardian, otp_app: :exchange_api

  def subject_for_token(uuid, _claims) do
    sub = uuid
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = ExchangeApi.Accounts.get_user!(id)
    {:ok, resource}
  end
end
