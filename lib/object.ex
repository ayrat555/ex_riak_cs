defmodule ExRiakCS.Object do
  alias ExRiakCS.Request

  def delete(bucket, key) do
    path = "/#{bucket}/#{key}"
    case Request.delete_request(path) do
      %{status_code: 204} -> :ok
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  def head(bucket, key) do
    path = "/#{bucket}/#{key}"
    case Request.head_request(path) do
      %{status_code: 200, headers: headers} -> {:ok, headers}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end
end
