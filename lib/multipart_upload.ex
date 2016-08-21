defmodule ExRiakCS.MultipartUpload do
  import ExRiakCS.MultipartUpload.Utils
  import ExRiakCS.Utils
  import ExRiakCS.Config
  alias ExRiakCS.Request

  @moduledoc """
  Multipart upload allows you to upload a single object as a set of parts.

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/#multipart-upload
  """

  @doc """
  Initiates a multipart upload and returns {:ok, upload_id} if request was successful, otherwise returns {:error, {response_code, response_body} }

  ## Example

      {:ok, upload_id} = MultipartUpload.initiate_multipart_upload("my-bucket", "my-key", "audio/mpeg")

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/s3/initiate-multipart-upload/
  """
  def initiate_multipart_upload(bucket, key, content_type) do
    path = "/#{bucket}/#{key}?uploads"
    headers = %{"Content-Type" => content_type,
                "x-amz-acl" => acl}
    case Request.request(:post, path, %{}, headers) do
      %{status_code: 200, body: body} -> {:ok, parse_upload_id(body)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  @doc """
  Uploads a part in a multipart upload and returns {:ok, part_etag} if request was successful, otherwise returns {:error, {response_code, response_body} }

  ## Example

      {:ok, part_etag} =  MultipartUpload.upload_part("my-bucket", "my-key", "upload_id", 1, "data")

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/s3/upload-part/
  """

  def upload_part(bucket, key, upload_id, number, data) do
    path = "/#{bucket}/#{key}?partNumber=#{number}&uploadId=#{upload_id}"
    headers = %{"Content-Type" => ""}
    case Request.request(:put, path, %{}, headers, data) do
      %{status_code: 200, headers: headers} -> {:ok, part_etag(headers)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  @doc """
   Generates part upload url with signature parameters

  ## Example

    url = ExRiakCS.MultipartUpload.signed_part_url("bucket", "key", "upload_id", 1)
  """

  def signed_part_url(bucket, key, upload_id, number) do
    path = "/#{bucket}/#{key}?partNumber=#{number}&uploadId=#{upload_id}"
    request_url(:put, path)
  end

  @doc """
  Completes a multipart upload and assembles previously uploaded parts and returns {:ok, file_etag} if request was successful, otherwise returns {:error, {response_code, response_body} }

  ## Example

      parts = [{1, "part_etag1"}, {2, "part_etag2"}]
      {:ok, etag} = MultipartUpload.complete_multipart_upload("my-bucket", "my-key", "upload_id", parts)

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/s3/complete-multipart-upload/
  """

  def complete_multipart_upload(bucket, key, upload_id, parts) do
    path = "/#{bucket}/#{key}?uploadId=#{upload_id}"
    xml_parts_body = xml_parts(parts)
    case Request.request(:post, path, %{}, %{"Content-Type" => ""}, xml_parts_body) do
      %{status_code: 200, body: body} -> {:ok, parse_file_etag(body)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  @doc """
  Aborts a multipart upload and eventually frees storage consumed by previously uploaded parts and returns {:ok, nil} if request was successful, otherwise returns {:error, {response_code, response_body} }

  ## Example

      {:ok, _} = MultipartUpload.abort_multipart_upload("bucket", "key", "upload_id")

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/s3/abort-multipart-upload/
  """

  def abort_multipart_upload(bucket, key, upload_id) do
    path = "/#{bucket}/#{key}?uploadId=#{upload_id}"
    case Request.request(:delete, path) do
      %{status_code: 204} -> {:ok, nil}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  @doc """
   Lists multipart uploads that have not yet been completed or aborted

  ## Example

      {:ok, uploads} = MultipartUpload.list_multipart_uploads('bucket')

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/s3/list-multipart-uploads/
  """

  def list_multipart_uploads(bucket) do
    path = "/#{bucket}/?uploads"
    case Request.request(:get, path) do
      %{status_code: 200, body: body} -> {:ok, parse_uploads(body)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  @doc """
   Lists the parts that have been uploaded for a specific multipart upload

  ## Example

      {:ok, parts} = MultipartUpload.list_parts("bucket", "key", "upload_id")

  More info at: http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/s3/list-multipart-uploads/
  """

  def list_parts(bucket, key, upload_id) do
    path = "/#{bucket}/#{key}?uploadId=#{upload_id}"
    case Request.request(:get, path) do
      %{status_code: 200, body: body} -> {:ok, parse_parts(body)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end
end
