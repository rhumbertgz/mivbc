defmodule MIVBC do
  @moduledoc """
  Client for the MIVB Open-Data API
  """
  require Logger

  # Attributes
  @endpoint "https://opendata-api.stib-mivb.be/"
  @vehiclePosByLine "OperationMonitoring/4.0/VehiclePositionByLine/"
  @passingTimeByPoint "OperationMonitoring/4.0/PassingTimeByPoint/"
  @pointByLine "NetworkDescription/1.0/PointByLine/"
  @pointDetail "NetworkDescription/1.0/PointDetail/"

  #MIVBC API

  @doc """
  Returns the position of vehicles of the specified `line(s)`.

  ## Examples
      
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

      iex> MIVBC.passing_time_by_point 5759, mytoken
      iex> MIVBC.passing_time_by_point [5759, 9056], mytoken

  """
  def passing_time_by_point(stops, token) do
    case get(@passingTimeByPoint, stops, token) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, response} -> process_response(:passingTimeByPoint, response)
    end
  end

  @doc """
  Returns an array of “points” and every point item contains the point id,
  the geolocation of the point and the name in French and Dutch

  ## Examples

      iex> MIVBC.point_detail 5759, mytoken
      iex> MIVBC.point_detail [5759, 9056], mytoken

  """
  def point_detail(stops, token) do
    case get(@pointDetail, stops, token) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, response} -> process_response(:pointDetail, response)
    end
  end

  @doc """
  Returns an array of “lines”. Every line item contains two directions.
  Every direction returns a list of points ids (a.k.a stop ids) where the vehicle passes by.

  ## Examples

      iex> MIVBC.point_by_line 5759, mytoken
      iex> MIVBC.point_by_line [5759, 9056], mytoken

  """
  def point_by_line(stops, token) do
    case get(@pointByLine, stops, token) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, response} -> process_response(:pointByLine, response)
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
    try do
      value = response.body
      |> Poison.decode!(as: %MIVBC.PassingTimeByPoint.Reponse{})
      value.points
    rescue
      e ->  content = :io_lib.format("~tp.~n", [e.message])
            :file.write_file("logs/mivbc#{System.monotonic_time}.err", content)
           []
    end
  end

  defp process_response(:vehiclePosByLine, response) do
    try do
      value = response.body
      |> Poison.decode!(as: %MIVBC.VehiclePositionByLine.Response{})
      value.lines
    rescue
      e ->  content = :io_lib.format("~tp.~n", [e.message])
            :file.write_file("logs/mivbc#{System.monotonic_time}.err", content)
           []
    end
  end

  defp process_response(:pointByLine, response) do
    try do
      value = response.body
      |> Poison.decode!(as: %MIVBC.PointByLine.Response{})
      value.lines
    rescue
      e ->  content = :io_lib.format("~tp.~n", [e.message])
            :file.write_file("logs/mivbc#{System.monotonic_time}.err", content)
           []
    end
  end

  defp process_response(:pointDetail, response) do
    try do
      value = response.body
      |> Poison.decode!(as: %MIVBC.PointDetail.Response{})
      value.points
    rescue
      e ->  content = :io_lib.format("~tp.~n", [e.message])
            :file.write_file("logs/mivbc#{System.monotonic_time}.err", content)
           []
    end
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
