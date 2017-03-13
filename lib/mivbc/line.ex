defmodule MIVBC.Line do

  @moduledoc """
  This module ...

  `lineId` refers to the field “route_short_name” of the GTFS file “routes.txt
  `vehiclePositions` is a list MIVBC.VehiclePosition struct

  """
  @derive [Poison.Encoder]
  defstruct lineId: 0, vehiclePositions: [%MIVBC.VehiclePosition{}]
end
