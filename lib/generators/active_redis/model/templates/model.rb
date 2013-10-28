class <%= class_name %> < ActiveRedis::Base
  attributes <%= actions.map{|a| ":#{a}"}.join(", ") %>
end