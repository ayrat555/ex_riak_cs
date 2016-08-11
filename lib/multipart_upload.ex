defmodule ExRiakCS.MultipartUpload do
  import ExRiakCS.MultipartUpload.Utils
  import ExRiakCS.Utils
  import ExRiakCS.Config
  alias ExRiakCS.Request

  def initiate_multipart_upload(bucket, key, content_type) do
    path = "/#{bucket}/#{key}?uploads"
    headers = %{"Content-Type" => content_type,
                "x-amz-acl" => acl}
    case Request.post_request(path, %{}, headers) do
      %{status_code: 200, body: body} -> {:ok, parse_upload_id(body)}
      %{status_code: code, body: body} -> {:error, code, body}
    end
  end

  def upload_part(bucket, key, upload_id, number, data) do
    path = "/#{bucket}/#{key}?partNumber=#{number}&uploadId=#{upload_id}"
    case Request.put_request(path, %{}, %{}, data) do
      %{status_code: 200, headers: headers} -> {:ok, etag(headers)}
      %{status_code: code, body: body} -> {:error, code, body}
    end
  end

  def signed_part_url(bucket, key, upload_id, number) do
    path = "/#{bucket}/#{key}?partNumber=#{number}&uploadId=#{upload_id}"
    request_url(path, "PUT")
  end
end
