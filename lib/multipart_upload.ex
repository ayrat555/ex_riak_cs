defmodule ExRiakCS.MultipartUpload do
  import ExRiakCS.MultipartUpload.Utils
  import ExRiakCS.Utils
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

  def signed_part_url(bucket, key, upload_id, number) do
    signature_path = "/#{bucket}/#{key}?partNumber=#{number}&uploadId=#{upload_id}"
    path = "/#{bucket}/#{key}"
    params = encode_params(signature_path, "PUT", %{}, %{partNumber: Integer.to_string(number),
                                                         uploadId: upload_id})
    base_url <> path <> "?" <> params
  end
end
