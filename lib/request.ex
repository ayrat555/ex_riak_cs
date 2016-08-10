defmodule ExRiakCS.Request do
  import ExRiakCS.Config
  import ExRiakCS.Utils

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
    params = encode_params(path, request_type, headers, params)
    base_url <> path <> "&" <> params
  end
end
