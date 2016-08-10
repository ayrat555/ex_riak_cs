defmodule ExRiakCS.MultipartUpload do
  import ExRiakCS.MultipartUpload.Utils
  import ExRiakCS.Config
  alias ExRiakCS.Request

  def initiate_multipart_upload(bucket, key, content_type) do
    path = "/#{bucket}/#{key}?uploads"
    headers = %{"Content-Type" => content_type,
                "x-amz-acl" => acl}
    case  Request.post_request(path, %{}, headers) do
      {:ok, body} -> {:ok, parse_upload_id(body)}
      {:error, body} -> {:error, body}
    end
  end
end
