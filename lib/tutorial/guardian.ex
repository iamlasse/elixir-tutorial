defmodule Tutorial.Guardian do
  @moduledoc """
    Module to extend guardian
  """
  use Guardian, otp_app: :tutorial
  alias Tutorial.Accounts
  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

   def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    {:ok, %{id: claims["sub"]}}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
