defmodule MIVBC do
  @moduledoc """
  Client for the MIVB Open-Data API
  """

  # Attributes
  @endpoint "https://opendata-api.stib-mivb.be/OperationMonitoring/3.0/"
  @vehiclePosByLine "VehiclePositionByLine/"
  @passingTimeByPoint "PassingTimeByPoint/"

  #MIVBC API

  @doc """
  Ensures the httpoison app is started
  """
  def start do
    Application.ensure_started(:httpoison)
  end

  @doc """
  Returns the position of vehicles of the specified `line(s)`.

  ## Examples
      iex> MIVBC.start
      iex> MIVBC.vehicle_position_by_Line 7, mytoken
      iex> MIVBC.vehicle_position_by_Line [7, 25], mytoken

  """
  def vehicle_position_by_Line(lines, token) do
    case get(@vehiclePosByLine, lines, token) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, response} -> process_response(:vehiclePosByLine, response)
    end
  end

  @doc """
  Returns next vehicle passing times at the specified `stop-point(s)`.

  ## Examples
      iex> MIVBC.start
      iex> MIVBC.passing_time_by_point 5759, mytoken
      iex> MIVBC.passing_time_by_point [5759, 9056], mytoken

  """
  def passing_time_by_point(stops, token) do
    case get(@passingTimeByPoint, stops, token) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, response} -> process_response(:passingTimeByPoint, response)
    end
  end

  # Utilities functions
  defp get(service, params, token) do
      url = @endpoint <> service <> encode_params(params)
      HTTPoison.get(url, build_headers(token))
  end

  defp build_headers(token) do
    ["Authorization": "Bearer #{token}", "Accept": "application/json"]
  end

  defp process_response(:passingTimeByPoint, response) do
    value = response.body
            |> Poison.decode!(as: %MIVBC.Points{points: [%MIVBC.Point{passingTimes: [%MIVBC.ArrivalTime{}]}]})
    value.points
  end

  defp process_response(:vehiclePosByLine, response) do
    value = response.body
            |> Poison.decode!(as: %MIVBC.Lines{lines: [%MIVBC.Line{vehiclePositions: [%MIVBC.VehiclePosition{}]}]})
    value.lines
  end

  defp encode_params(param) when is_integer param do
    Integer.to_string(param)
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
