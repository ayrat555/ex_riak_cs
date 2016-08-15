defmodule ExRiakCS.Auth.Utils do

  @moduledoc false

  def encrypt(string, key) do
    encrypted = :crypto.hmac(:sha, key, string)
    encrypted |> Base.encode64
  end

  def expiration_date(exp_days) do
    Timex.now
    |> Timex.shift(days: exp_days)
    |> Timex.to_unix()
  end
end
