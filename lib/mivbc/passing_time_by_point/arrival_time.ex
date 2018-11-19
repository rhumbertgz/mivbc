defmodule MIVBC.PassingTimeByPoint.ArrivalTime do
  @moduledoc """
  This module ...

  `expectedArrivalTime` refers to the expected arrival time the vehicle
  `lineId` refers to the field `route_short_name` of the GTFS file `routes.txt`
  """
  defstruct expectedArrivalTime: 0, lineId: 0
end
