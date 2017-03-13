defmodule MIVBC.Point do
  @moduledoc """
  This module ...

  `pointId` is used as argument of the operation refers to the fields `stop_id` of the GTFS file `stops.txt`
  `passingTimes` list of next 4 passing times for the specified `pointId`
  """
  @derive [Poison.Encoder]
  defstruct pointId: 0, passingTimes: [%MIVBC.ArrivalTime{}]
end
