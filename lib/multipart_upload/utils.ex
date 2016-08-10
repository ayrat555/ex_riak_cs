defmodule ExRiakCS.MultipartUpload.Utils do

  def parse_upload_id(xml) do
    x_path =
      "//InitiateMultipartUploadResult/UploadId/text()"
      |> SweetXml.sigil_x()
    xml |> SweetXml.xpath(x_path)
  end
end
