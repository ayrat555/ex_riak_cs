defmodule ExRiakCS.Object do
  alias ExRiakCS.Request

  @moduledoc """
  This module contains object-level operations

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/#object-level-operations
  """

  @doc """
  Deletes an object and returns {:ok, nil} if request was successful, otherwise returns {:error, {response_code, response_body} }

  ## Example

      {:ok, _} = Object.delete("test-bucket", "key")

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/s3/delete-object/
  """
  def delete(bucket, key) do
    path = "/#{bucket}/#{key}"
    case Request.request(:delete, path) do
      %{status_code: 204} -> {:ok, nil}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  @doc """
  Retrieves object metadata (not the full content of the object) and returns {:ok, headers} if request was successful, otherwise returns {:error, {response_code, response_body} }

  ## Example

      {:ok, headers} = Object.head("test-bucket", "key")

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/s3/head-object/
  """

  def head(bucket, key) do
    path = "/#{bucket}/#{key}"
    case Request.request(:head, path) do
      %{status_code: 200, headers: headers} -> {:ok, headers}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end
end
