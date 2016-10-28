defmodule ExRiakCS.Config do

  @moduledoc """
    A set of configuration parameters for Riak CS API

    You can configure ex_riak_cs by setting configuration parameters in your Mix.Config files

        config :ex_riak_cs,
          key_id: "test_id", # your access key
          secret_key: "test_key", # your secret key
          schema: "https://", # your riak cs server schema
          host: "storage-nginx.stage.govermedia.com" # your riak cs server host


    Additional parameters

          exp_days: 2 # number of days, during which a signed upload part url will be valid. default value = 1
          acl: "private" # created file's acl. default value = "public-read"
  """

  def secret_key do
    env_var!(:secret_key)
  end

  def key_id do
    env_var!(:key_id)
  end

  def base_url do
    env_var!(:schema) <> env_var!(:host)
  end

  def acl do
    env_var(:acl, "public-read")
  end

  def exp_days do
    env_var(:exp_days, 1)
  end

  defp env_var!(key) do
    Application.fetch_env!(:ex_riak_cs, key)
  end

  defp env_var(key, default \\ nil) do
    Application.get_env(:ex_riak_cs, key, default)
  end
end
