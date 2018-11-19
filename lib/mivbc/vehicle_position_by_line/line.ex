defmodule MIVBC.VehiclePositionByLine.Line do

  @moduledoc """
  This module ...

  `lineId` refers to the field “route_short_name” of the GTFS file “routes.txt
  `vehiclePositions` is a list MIVBC.VehiclePosition struct

  """
  defstruct lineId: 0, vehiclePositions: [%MIVBC.VehiclePositionByLine.Vehicle{}]
end
