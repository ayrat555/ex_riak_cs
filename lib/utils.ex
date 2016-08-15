defmodule ExRiakCS.Utils do
  alias ExRiakCS.Auth
  import ExRiakCS.Config

  @moduledoc false

  def request_url(request_type, path, headers \\ %{}, params \\ %{}) do
    params = encode_params(request_type, path, headers, params)
    base_url <> path_without_params(path) <> "?" <> params
  end

  defp encode_params(request_type, path, headers, params) do
    type =
      request_type
      |> Atom.to_string
      |> String.upcase
    path
    |> Auth.signature_params(type, headers)
    |> Map.merge(params, fn(_k, v1, _v2) -> v1 end)
    |> Map.merge(params_from_path(path), fn(_k, v1, _v2) -> v1 end)
    |> URI.encode_query()
  end

  defp params_from_path(path) do
    params_string =
      path
      |> String.split("?")
      |> Enum.at(1)

    case params_string do
      nil ->
        Map.new
      string ->
        string |> params
    end
  end

  defp path_without_params(path) do
    path
    |> String.split("?")
    |> Enum.at(0)
  end

  defp params(params_string) do
    params_string
    |> String.split("&")
    |> Enum.reduce(%{}, fn(string, map) ->
      case :binary.match(string, "=") do
        {pos, _} ->
          name = string |> String.slice(0, pos)
          value = string |> String.slice(pos + 1, String.length(string))
          Map.put(map, name, value)
        :nomatch ->
          Map.put(map, string, nil)
      end
    end)
  end
end
