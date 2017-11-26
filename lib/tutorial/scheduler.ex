defmodule Tutorial.Scheduler do
  @moduledoc """

  """
  use Quantum.Scheduler, otp_app: :tutorial
  alias Tutorial.{FileReader, Tweet}

  def schedule_file(file) do
    IO.puts "Running cron job and sending tweet.... #{file}"
    file
    |> Tweet.send_random()
  end

  def schedule_file, do: IO.puts "No file scheduled to run, aborting...."
end
