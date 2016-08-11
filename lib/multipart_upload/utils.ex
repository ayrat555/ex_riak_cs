defmodule ExRiakCS.MultipartUpload.Utils do

  def parse_upload_id(xml) do
    x_path =
      "//InitiateMultipartUploadResult/UploadId/text()"
      |> SweetXml.sigil_x()
    xml |> SweetXml.xpath(x_path)
  end

  def etag(headers) do
    {"ETag", etag} = List.keyfind(headers, "ETag", 0)
    etag
  end
end
