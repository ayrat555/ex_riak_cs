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

    {:ok, _} = MultipartUpload.complete_multipart_upload(@bucket, @key, upload_id, parts)
  end

  test "aborts multipart upload" do
    {:ok, upload_id} = MultipartUpload.initiate_multipart_upload(@bucket, @key, "audio/mpeg")
    :ok = MultipartUpload.abort_multipart_upload(@bucket, @key, upload_id)
  end

  test "returns error on aborting not existing multipart upload" do
    {:error, {404, _}} = MultipartUpload.abort_multipart_upload(@bucket, @key, "upload_id")
  end

  test "returns multipart uploads" do
    {:ok, uploads} = MultipartUpload.list_multipart_uploads(@bucket)
    assert uploads.bucket
    upload = hd(uploads.uploads)
    assert upload.initiated
    assert upload.key
    assert upload.upload_id
    assert upload.owner.name
    assert upload.owner.id
    assert upload.initiator.name
    assert upload.initiator.id
  end
end
