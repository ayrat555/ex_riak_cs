defmodule ExRiakCS.MultipartUploadIntegrationTest do
  use ExUnit.Case, async: true
  import ExRiakCS.ObjectHelpers
  alias ExRiakCS.Object

  @bucket "test-bucket"

  test "uploads file using multipart upload" do
    file = "./test/files/file.mp3"
    key = "key#{:rand.uniform(1000)}"
    {:ok, _} = upload_object(file, @bucket, key, "audio/mp3")
    :ok = Object.delete(@bucket, key)
  end
end
