defmodule ExRiakCS.MultipartUploadIntegrationTest do
  use ExUnit.Case, async: true

  test "initiates multipart upload with valid credentials" do
    {:ok, upload_id} = ExRiakCS.MultipartUpload.initiate_multipart_upload("test-bucket", "test-key", "video/mp4")
  end
end
