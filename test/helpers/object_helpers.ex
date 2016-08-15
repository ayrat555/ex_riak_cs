defmodule ExRiakCS.ObjectHelpers do
  alias ExRiakCS.MultipartUpload

  def upload_object(file_path, bucket, key, mime_type) do
    {:ok, upload_id} = MultipartUpload.initiate_multipart_upload(bucket, key, mime_type)

    parts =
      file_path
      |> File.stream!([], 1024*1024*5)
      |> Enum.with_index
      |> Enum.reduce([], fn(data, parts) ->
        {data, number} = data
        {:ok, part_etag} =  MultipartUpload.upload_part(bucket, key, upload_id, number + 1, data)
        [{number + 1, part_etag} | parts]
      end)
      |> Enum.reverse

    MultipartUpload.complete_multipart_upload(bucket, key, upload_id, parts)
  end
end
