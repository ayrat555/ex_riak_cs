# ExRiakCs

ExRiakCs - simple elixir wrapper for [Riak CS API](http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/)

NOTE: The package in early development stage. Any help would be appreciated

## Usage

#### Multipart Upload
to work with Multipart Upload API use ExRiakCS.MultipartUpload module
```elixir
# initiate_multipart_upload - initiates multipart upload.
# returns upload_id
# params - bucket (string)
#          file key (string)
#          mime type (string)

{:ok, upload_id} = ExRiakCS.MultipartUpload.initiate_multipart_upload("test-bucket", "test-key", "video/mp4")

# signed_part_url - returns signed upload part url of multipart upload
# params - bucket (string)
#          file key (string)
#          upload id (string)
#          upload part number (integer)

signed_part_url = ExRiakCS.MultipartUpload.signed_part_url(bucket, key, upload_id, number)
```

## Configuration

in your config file set

```elixir
config :ex_riak_cs,
  key_id: "test_id",
  secret_key: "test_key",
  schema: "https://", # your riak cs server schema
  host: "storage-nginx.stage.govermedia.com" # your riak cs server host
```
Additional parameters
```elixir
  exp_days: 2 # number of days your signed url will be valid. default value - 1
  acl: "private" # created file's acl. default value - "public-read"
```

## Installation
NOTE: the package is not available in Hex yet.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `ex_riak_cs` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_riak_cs, "~> 0.1.0"}]
    end
    ```

  2. Ensure `ex_riak_cs` is started before your application:

    ```elixir
    def application do
      [applications: [:ex_riak_cs]]
    end
    ```
