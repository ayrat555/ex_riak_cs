defmodule ExRiakCS.Config do

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

  def env_var(key, default \\ nil) do
    Application.get_env(:ex_riak_cs, key, default)
  end
end
