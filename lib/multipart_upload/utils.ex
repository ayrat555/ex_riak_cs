defmodule ExRiakCS.MultipartUpload.Utils do
  import SweetXml

  def parse_upload_id(xml) do
    xml |> xpath(~x"//InitiateMultipartUploadResult/UploadId/text()")
  end

  def parse_file_etag(xml) do
    xml |> xpath(~x"//CompleteMultipartUploadResult/ETag/text()")
  end

  def parse_uploads(xml) do
    xml |> xmap(
      bucket:  ~x"//ListMultipartUploadsResult/Bucket/text()",
      uploads: [
        ~x"//ListMultipartUploadsResult/Upload"l,
        key: ~x"./Key/text()",
        upload_id: ~x"./UploadId/text()",
        initiated: ~x"./Initiated/text()",
        initiator: [
          ~x"./Initiator",
          id:  ~x"./ID/text()",
          name:  ~x"./DisplayName/text()"
        ],
        owner: [
           ~x"./Owner",
          id:  ~x"./ID/text()",
          name:  ~x"./DisplayName/text()"
        ],
        storage_class: ~x"./StorageClass/text()"
      ]
    )
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
