defmodule ExRiakCS.Request do
  import ExRiakCS.Utils

  def request(type, path, params \\ %{}, headers \\ %{}, body \\ []) do
    url = request_url(type, path, headers, params)
    {:ok, %HTTPoison.Response{
      status_code: code,
      body: body,
      headers: headers}} =
    HTTPoison.request(type, url, body, headers)
    %{status_code: code, body: body, headers: headers}
  end
end
