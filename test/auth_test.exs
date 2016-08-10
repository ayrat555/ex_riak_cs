defmodule ExRiakCS.AuthTest do
  use ExUnit.Case, async: true

  @exp_time 1471006683

  test "generates valid auth params for multipart upload initiation" do
    headers = %{
      "Content-Type" => "video/mp4",
      "x-amz-acl" => "public-read"}
    %{
      AWSAccessKeyId: id,
      Expires: exp_time,
      Signature: signature
    } = ExRiakCS.Auth.signature_params("/bucket/key?uploads", "POST", headers, @exp_time)
    assert id == "test_id"
    assert exp_time == @exp_time
    assert signature == "Y7LdpKXS/A8kymdVunFxwLR4WfU="
  end
end
