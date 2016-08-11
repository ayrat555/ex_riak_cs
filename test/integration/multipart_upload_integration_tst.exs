defmodule ExRiakCS.MultipartUploadIntegrationTest do
  use ExUnit.Case, async: true

  @bucket "test-bucket"
  @key "test-key"

  test "uploads file using multipart upload" do
    {:ok, upload_id} = ExRiakCS.MultipartUpload.initiate_multipart_upload(@bucket, @key, "video/mp4")
    {:ok, etag} = ExRiakCS.MultipartUpload.upload_part(@bucket, @key, upload_id, 1, "555")
  end
end
