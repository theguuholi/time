defmodule DurationParser do
  @valid_formats ~w[: h .]

  @moduledoc """
    Parse a given string as either a time interval or a fractional number of hours
    and return the equivalent number of hours and minutes.

    ## Examples

        iex> DurationParser.parse_minutes("2:15")
        {:ok, 135}

        iex> DurationParser.parse_minutes("02:15")
        {:ok, 135}

        iex> DurationParser.parse_minutes("2h 35m")
        {:ok, 155}

        iex> DurationParser.parse_minutes("10")
        {:ok, 10}

        iex> DurationParser.parse_minutes("0.5h")
        {:ok, 30}

        iex> DurationParser.parse_minutes("0.5")
        {:ok, 30}

        iex> DurationParser.parse_minutes("10.0")
        {:ok, 600}

        iex> DurationParser.parse_minutes("7.5")
        {:ok, 450}

        iex> DurationParser.parse_minutes("24.5")
        {:ok, 1470}

        iex> DurationParser.parse_minutes("a24.5")
        {:error, "expected 2 digits"}
  """
  def parse_minutes(hour) do
    build_result(true, hour)
  end

  defp build_result(false, _), do: {:error, "expected 2 digits"}

  defp build_result(true, hour) do
    @valid_formats
    |> Enum.find(&String.contains?(hour, &1))
    |> convert(hour)
    |> response
  end

  def convert(nil, hour), do: hour |> String.to_integer()

  def convert(".", hour) do
    ((hour
      |> String.to_float()) * 60)
    |> Kernel.trunc()
  end

  def convert(":", hour) do
    hour
    |> String.split(":")
    |> convert_to_minutes
  end

  def convert("h", hour) do
    hour
    |> String.contains?(".")
    |> fractional_value(hour)
  end

  def fractional_value(true, hour) do
    [_hour, hour_f | _] =
      hour
      |> String.split([".", "h"])

    minutes = to_integer(hour_f) * 6

    ["0", minutes |> Integer.to_string()]
    |> convert_to_minutes
  end

  def fractional_value(false, hour) do
    hour
    |> String.replace(" ", "")
    |> String.split(["h", "m"])
    |> convert_to_minutes
  end

  defp convert_to_minutes([hours, minutes | _]) do
    to_integer(hours) * 60 + to_integer(minutes)
  end

  defp to_integer(value), do: value |> String.to_integer()

  defp response(minutes) do
    {:ok, minutes}
  end
end
