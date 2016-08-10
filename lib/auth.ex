defmodule ExRiakCS.Auth do
  import ExRiakCS.Auth.Utils
  import ExRiakCS.Config

  def signature_params(path, request_type, headers \\ %{}, exp_date \\ expiration_date(exp_days)) do
    %{
      AWSAccessKeyId: key_id,
      Expires: exp_date,
      Signature: signature(request_type, exp_date, path, headers)
      }
  end

  defp signature(request_type, exp_date, path, headers) do
    string = string_to_sign(request_type, exp_date, path, headers)
    string |> encrypt(secret_key)
  end

  defp string_to_sign(request_type, exp_date, path, headers) do
    content_type = Map.get(headers, "Content-Type")
    headers = Map.delete(headers, "Content-Type")
    string_to_sign = ""
    string_to_sign = string_to_sign <> request_type <> "\n\n"
    string_to_sign = if content_type, do: string_to_sign <> content_type <> "\n", else: string_to_sign <> "\n"
    string_to_sign = string_to_sign <> Integer.to_string(exp_date) <> "\n"
    string_to_sign = Enum.reduce(headers, string_to_sign, fn(header, string_to_sign) ->
                                                            {key, value} = header
                                                            string_to_sign <> "#{key}:" <> value <> "\n"
                                                          end)
    string_to_sign <> path
  end
end
