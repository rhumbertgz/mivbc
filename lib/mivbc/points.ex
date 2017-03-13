defmodule MIVBC.Points do

  @moduledoc """
  This module ...

  `lines` refers to a list of MIVBC.Points struct

  """
  @derive [Poison.Encoder]
  defstruct points: [%MIVBC.Point{}]
end
