defmodule ExRiakCS.Utils do
  alias ExRiakCS.Auth

  def encode_params(signature_path, request_type, headers, params) do
    signature_path
    |> Auth.signature_params(request_type, headers)
    |> Map.merge(params, fn(_k, v1, _v2) -> v1 end)
    |> URI.encode_query()
  end
end
