defmodule ExRiakCS.MultipartUpload.Utils do

  def parse_upload_id(xml) do
    x_path =
      "//InitiateMultipartUploadResult/UploadId/text()"
      |> SweetXml.sigil_x()
    xml |> SweetXml.xpath(x_path)
  end

  def parse_file_etag(xml) do
    x_path =
      "//CompleteMultipartUploadResult/ETag/text()"
      |> SweetXml.sigil_x()
    xml |> SweetXml.xpath(x_path)
  end

  def part_etag(headers) do
    {"ETag", etag} = List.keyfind(headers, "ETag", 0)
    etag
  end

  def xml_parts(parts) do
    xml = "<?xml version=\"1.0\"?>\n"
    xml = xml <> "<CompleteMultipartUpload>\n"
    xml =
    parts
    |> Enum.reduce(xml, fn(part, xml) ->
        {number, etag} = part
        xml = xml <> "  <Part>\n"
        xml = xml <> "    <PartNumber>#{number}</PartNumber>\n"
        xml = xml <> "    <ETag>#{etag}</ETag>\n"
        xml <> "  </Part>\n"
      end)
    xml <> "</CompleteMultipartUpload>\n"
  end
end
