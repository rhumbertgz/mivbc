defmodule MIVBC.VehiclePositionByLine.Vehicle do
  @moduledoc """
  This module ...

  `directionId` the direction of the vehicle as the terminal `pointId`
  `distanceFromPoint` the distance (in meters) covered by a vehicle since the last point
  `pointId` the last stop crossed by a vehicle

  """
  defstruct directionId: 0, distanceFromPoint: 0, pointId: 0

end
