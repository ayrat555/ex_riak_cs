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
    assert uploads.bucket == @bucket
    upload = hd(uploads.uploads)
    assert upload.initiated
    assert upload.key
    assert upload.upload_id
    assert upload.owner.name
    assert upload.owner.id
    assert upload.initiator.name
    assert upload.initiator.id
  end

  test "lists parts" do
    {:ok, upload_id} = MultipartUpload.initiate_multipart_upload(@bucket, @key, "audio/mpeg")
    MultipartUpload.upload_part(@bucket, @key, upload_id, 1, "part 1")
    MultipartUpload.upload_part(@bucket, @key, upload_id, 2, "part 2")
    {:ok, parts} = MultipartUpload.list_parts(@bucket, @key, upload_id)
    assert parts.bucket == @bucket
    assert parts.key == @key
    assert parts.upload_id == upload_id
    assert parts.owner.name
    assert parts.owner.id
    assert parts.initiator.name
    assert parts.initiator.id
    assert parts.storage_class
    assert Enum.count(parts.parts) == 2
    part = hd(parts.parts)
    assert part.etag
    assert part.last_modified
    assert part.number
    assert part.size
  end

  test "generates valid part url" do
    {:ok, upload_id} = MultipartUpload.initiate_multipart_upload(@bucket, @key, "audio/mpeg")
    url = ExRiakCS.MultipartUpload.signed_part_url(@bucket, @key, upload_id, 1)
    {:ok, %HTTPoison.Response{
      status_code: 200}} =
    HTTPoison.request(:put , url, "555", %{})
  end
end
