# ExRiakCs

ExRiakCs - simple elixir wrapper for [Riak CS API](http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/)

NOTE: not all riak cs api methods are available but new methods can be easily added (read Contributing section).

## Installation

The package can be installed as:

   Add `ex_riak_cs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_riak_cs, "~> 0.1.1"}]
end
```

## Documentation

https://hexdocs.pm/ex_riak_cs/api-reference.html

## Contributing

Start by forking this repo

Pull requests are greatly appreciated

New methods can be easily added. For example, if you want to add the [GET Object method](http://docs.basho.com/riak/cs/2.1.1/references/apis/storage/s3/get-object/), you should send get request using request method from the Request module, passing path to your object and then pattern match the result

```elixir
def get(bucket, key) do
  path = "/#{bucket}/#{key}"
  case Request.request(:get, path) do
    ...
  end
end
```
