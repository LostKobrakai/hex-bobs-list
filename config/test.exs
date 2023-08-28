import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bob_versions, BobVersionsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "S6K/jNS2V/nSEkcIYdi/yp93Yl5RuLLI+oPaxq9jRK326OSYlrW9vZnA2gMUqGyb",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning
