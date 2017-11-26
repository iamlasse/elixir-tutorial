defmodule Tutorial.Tweet do
  @moduledoc """

  """
  import Tutorial.FileReader

  def send(string) do
    IO.puts "Send tweet #{string}"
    ExTwitter.configure(
      :process,
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
      access_token_secret: System.get_env("TWITTER_ACCESS_TOKEN_SECRET")
    )

    ExTwitter.update(string)
  end

  def send_random(file) do
    IO.puts "Send random tweet from file #{file}"
    file
    |> get_strings()
    |> send()
  end
end
