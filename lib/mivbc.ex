defmodule MIVBC do
  
  @moduledoc """
  MIVBC module ...
  """

  # Attributes 
  @token "ebc7bd3c2764c42c6f836c85f72b5bcc"
  @headers ["Authorization": "Bearer #{@token}", "Accept": "application/json"]
  @endpoint "https://opendata-api.stib-mivb.be/OperationMonitoring/1.0/"
  @vpbl "VehiclePositionByLine/"
  @ptbp "PassingTimeByPoint/"

  #MIVBC API 

  @doc """
  Ensures the httpoison app is started
  """
  def start do
    Application.ensure_started(:httpoison)
  end   

  @doc """
  Returns the position of vehicles of the specified `lines`.
  """
  def vehicle_position_by_Line(lines) do
    {:ok, response} = get(@vpbl, lines)
    process_response_body (response)
  end

  @doc """
  Returns next vehicle passing times at the specified `stop-points`.
  """
  def passing_time_by_point(stops) do
    {:ok, response} = get(@ptbp, stops)
    process_response_body (response)
  end


  # Utilities functions
  defp get(service, params) do
      url = @endpoint <> service <> encode_params(params)
      HTTPoison.get(url, @headers)
  end


  defp process_response_body(response) do
    response.body
    |> Poison.decode!
  end

  defp encode_params(line) when is_integer line do
    Integer.to_string(line) 
  end

  defp encode_params([]) do
    nil
  end

  defp encode_params([a | rest]) do
    acc = Integer.to_string(a)
    encode_params(rest, acc)
  end

  defp encode_params(line) do
    raise "Invalid line value [#{line}]. Only natural numbers are allowed." 
  end

  defp encode_params([], acc) do
    URI.encode_www_form acc
  end

  defp encode_params([a | rest], acc) do
    acc =  acc <> "," <> Integer.to_string(a) 
    encode_params(rest, acc)
  end
end