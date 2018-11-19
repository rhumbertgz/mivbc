defmodule MIVBC.PointByLine.Line do
  defstruct destination: %MIVBC.PointByLine.Destination{}, direction: "", lineId: %MIVBC.PointByLine.ID{}, points: [%MIVBC.PointByLine.Point{}]
end
