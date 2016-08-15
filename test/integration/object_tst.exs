defmodule ExRiakCS.MultipartUploadIntegrationTest do
  use ExUnit.Case, async: true
  import ExRiakCS.ObjectHelpers
  alias ExRiakCS.Object

  @bucket "test-bucket"

  test "deletes file" do
    file = "./test/files/file.mp3"
    key = "key#{:rand.uniform(1000)}"
    {:ok, _} = upload_object(file, @bucket, key, "audio/mp3")
    {:ok, _} = Object.delete(@bucket, key)
  end

  test "gets file headers" do
    file = "./test/files/file.mp3"
    key = "key#{:rand.uniform(1000)}"
    {:ok, _} = upload_object(file, @bucket, key, "audio/mp3")
    {:ok, _} = Object.head(@bucket, key)
  end
end
