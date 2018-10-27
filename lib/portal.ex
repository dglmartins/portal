defmodule Portal do
  @moduledoc """
  Documentation for Portal.
  """

  defstruct [:left, :right]

  @doc """
  Starts transfering `data` from `left` to `right`

  """
  def transfer(left, right, data) do
    # First add all data to the portal on the left
    for item <- data do
      Portal.Door.push(left, item)
    end

    # Returns a portal struct we will use next
    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given `portal`
  """

  def push_right(portal) do
    push(portal, :right)
    # Let's return the portal itself
    portal
  end

  def push_left(portal) do
    push(portal, :left)
    # Let's return the portal itself
    portal
  end

  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end

  defp push(portal, direction) do
    source =
      case direction do
        :left -> :right
        :right -> :left
      end

    case Portal.Door.pop(Map.get(portal, source)) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(Map.get(portal, direction), h)
    end
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.pad_leading(left_door, max)} <=> #{right_door}
      #{String.pad_leading(left_data, max)} <=> #{right_data}
    >
    """
  end
end
