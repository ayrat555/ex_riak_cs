defmodule ExRiakCS.MultipartUpload.Utils do
  import SweetXml

  @moduledoc false


  def parse_upload_id(xml) do
    xml |> xpath(~x"//InitiateMultipartUploadResult/UploadId/text()"s)
  end

  def parse_file_etag(xml) do
    xml |> xpath(~x"//CompleteMultipartUploadResult/ETag/text()"s)
  end

  def parse_uploads(xml) do
    xml |> xmap(
      bucket:  ~x"//ListMultipartUploadsResult/Bucket/text()"s,
      uploads: [
        ~x"//ListMultipartUploadsResult/Upload"l,
        key: ~x"./Key/text()",
        upload_id: ~x"./UploadId/text()"s,
        initiated: ~x"./Initiated/text()"s,
        initiator: [
          ~x"./Initiator",
          id:  ~x"./ID/text()"s,
          name:  ~x"./DisplayName/text()"s
        ],
        owner: [
           ~x"./Owner",
          id:  ~x"./ID/text()"s,
          name:  ~x"./DisplayName/text()"s
        ],
        storage_class: ~x"./StorageClass/text()"s
      ]
    )
  end

  def parse_parts(xml) do
    xml |> xmap(
      bucket:  ~x"//ListPartsResult/Bucket/text()"s,
      key:  ~x"//ListPartsResult/Key/text()"s,
      upload_id:  ~x"//ListPartsResult/UploadId/text()"s,
      initiator: [
        ~x"./Initiator",
        id:  ~x"./ID/text()"s,
        name:  ~x"./DisplayName/text()"s
      ],
      owner: [
         ~x"./Owner",
        id:  ~x"./ID/text()"s,
        name:  ~x"./DisplayName/text()"s
      ],
      storage_class: ~x"./StorageClass/text()"s,
      parts: [
        ~x"./Part"l,
        number: ~x"./PartNumber/text()"i,
        last_modified: ~x"./LastModified/text()"s,
        etag: ~x"./ETag/text()"s,
        size: ~x"./Size/text()"i,
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
