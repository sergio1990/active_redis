class <%= class_name %> < ActiveRedis::Base
  attributes <%= actions.map{|a| str = a.split(':'); "#{str[0]}: :#{str[1]}"}.join(", ") %>
end