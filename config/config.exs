import Config

config :challenge,
  :file_name, "mobile_food_facility_permit.csv"

config :plug_cowboy,
  cowboy_port: 8888,
  log_exceptions_with_status_code: [400..599],
  conn_in_exception_metadata: false
