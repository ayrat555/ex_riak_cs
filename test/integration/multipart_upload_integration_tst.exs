defmodule ExRiakCS.MultipartUploadIntegrationTest do
  use ExUnit.Case, async: true
  alias ExRiakCS.MultipartUpload

  @bucket "test-bucket"
  @key "file"

  test "uploads file using multipart upload" do
    file = "./test/files/file.mp3"
    {:ok, upload_id} = MultipartUpload.initiate_multipart_upload(@bucket, @key, "audio/mpeg")

    parts =
      file
      |> File.stream!([], 1024*1024*5)
      |> Enum.with_index
      |> Enum.reduce([], fn(data, parts) ->
        {data, number} = data
        {:ok, part_etag} =  MultipartUpload.upload_part(@bucket, @key, upload_id, number + 1, data)
        [{number + 1, part_etag} | parts]
      end)
      |> Enum.reverse

    {:ok, file_etag} = MultipartUpload.complete_multipart_upload(@bucket, @key, upload_id, parts)
  end
end
