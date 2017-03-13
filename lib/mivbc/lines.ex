defmodule MIVBC.Lines do

  @moduledoc """
  This module ...

  `lines` refers to a list of MIVBC.Line struct

  """
  @derive [Poison.Encoder]
  defstruct lines: [%MIVBC.Line{}]
end
