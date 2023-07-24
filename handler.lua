local BasePlugin = require "kong.plugins.base_plugin"
local cjson = require "cjson.safe"

local MyLogger = BasePlugin:extend()

MyLogger.PRIORITY = 1000

function MyLogger:new()
  MyLogger.super.new(self, "mylogger")
end

function MyLogger:access(conf)
  MyLogger.super.access(self)

  local req_body, err = kong.request.get_body()
  if err then
    kong.log.err("Could not get request body: ", err)
  else
    kong.log.inspect(req_body)
  end
end

function MyLogger:body_filter(conf)
  MyLogger.super.body_filter(self)

  local res_body = kong.service.response.get_raw_body()
  local decoded_body, err = cjson.decode(res_body)
  if err then
    kong.log.err("Could not decode response body: ", err)
  else
    kong.log.inspect(decoded_body)
  end
end

return MyLogger
