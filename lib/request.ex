defmodule ExRiakCS.Request do
  import ExRiakCS.Utils

  def post_request(path, params \\ %{}, headers \\ %{}, body \\ []) do
    {:ok, %HTTPoison.Response{
      status_code: code,
      body: body,
      headers: headers}} =
      path
      |> request_url("POST",  headers, params)
      |> HTTPoison.post(body, headers)
    %{status_code: code, body: body, headers: headers}
  end

  def put_request(path, params \\ %{}, headers \\ %{}, body \\ []) do
    {:ok, %HTTPoison.Response{
      status_code: code,
      body: body,
      headers: headers}} =
      path
      |> request_url("PUT",  headers, params)
      |> HTTPoison.put(body, headers)
    %{status_code: code, body: body, headers: headers}
  end

  def delete_request(path, params \\ %{}, headers \\ %{}) do
    {:ok, %HTTPoison.Response{
      status_code: code,
      body: body,
      headers: headers}} =
      path
      |> request_url("DELETE", headers, params)
      |> HTTPoison.delete(headers)
    %{status_code: code, body: body, headers: headers}
  end

  def get_request(path, params \\ %{}, headers \\ %{}) do
    {:ok, %HTTPoison.Response{
      status_code: code,
      body: body,
      headers: headers}} =
      path
      |> request_url("GET", headers, params)
      |> HTTPoison.get(headers)
    %{status_code: code, body: body, headers: headers}
  end
end
