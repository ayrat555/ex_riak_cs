defmodule ExRiakCS.Request do
  import ExRiakCS.Config
  alias ExRiakCS.Auth

  def post_request(path, params \\ %{}, headers \\ %{}, body \\ []) do
    {:ok, request} =
      path
      |> request_url("POST",  headers, params)
      |> HTTPoison.post(body, headers)
    case request do
      %HTTPoison.Response{status_code: 200, body: body} -> {:ok, body}
      %HTTPoison.Response{body: body} -> {:error, body}
    end
  end

  defp request_url(path, request_type, headers, params) do
    encoded_params =
      path
      |> Auth.signature_params(request_type, headers)
      |> Map.merge(params, fn(_k, v1, _v2) -> v1 end)
      |> URI.encode_query()
    base_url <> path <> "&" <> encoded_params
  end
end
