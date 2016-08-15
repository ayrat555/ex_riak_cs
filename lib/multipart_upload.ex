defmodule ExRiakCS.MultipartUpload do
  import ExRiakCS.MultipartUpload.Utils
  import ExRiakCS.Utils
  import ExRiakCS.Config
  alias ExRiakCS.Request

  def initiate_multipart_upload(bucket, key, content_type) do
    path = "/#{bucket}/#{key}?uploads"
    headers = %{"Content-Type" => content_type,
                "x-amz-acl" => acl}
    case Request.request(:post, path, %{}, headers) do
      %{status_code: 200, body: body} -> {:ok, parse_upload_id(body)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  def upload_part(bucket, key, upload_id, number, data) do
    path = "/#{bucket}/#{key}?partNumber=#{number}&uploadId=#{upload_id}"
    case Request.request(:put, path, %{}, %{}, data) do
      %{status_code: 200, headers: headers} -> {:ok, part_etag(headers)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  def signed_part_url(bucket, key, upload_id, number) do
    path = "/#{bucket}/#{key}?partNumber=#{number}&uploadId=#{upload_id}"
    request_url(path, "PUT")
  end

  def complete_multipart_upload(bucket, key, upload_id, parts) do
    path = "/#{bucket}/#{key}?uploadId=#{upload_id}"
    xml_parts_body = xml_parts(parts)
    case Request.request(:post, path, %{}, %{"Content-Type" => ""}, xml_parts_body) do
      %{status_code: 200, body: body} -> {:ok, parse_file_etag(body)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  def abort_multipart_upload(bucket, key, upload_id) do
    path = "/#{bucket}/#{key}?uploadId=#{upload_id}"
    case Request.request(:delete, path) do
      %{status_code: 204} -> :ok
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  def list_multipart_uploads(bucket) do
    path = "/#{bucket}/?uploads"
    case Request.request(:get, path) do
      %{status_code: 200, body: body} -> {:ok, parse_uploads(body)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end

  def list_parts(bucket, key, upload_id) do
    path = "/#{bucket}/#{key}?uploadId=#{upload_id}"
    case Request.request(:get, path) do
      %{status_code: 200, body: body} -> {:ok, parse_parts(body)}
      %{status_code: code, body: body} -> {:error, {code, body}}
    end
  end
end
