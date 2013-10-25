local keys = function (k)
  return redis.call("KEYS", k)
end

local cond_tonum = function (value, tonum)
  if tonum == true then
    return tonumber(value)
  else
    return value
  end
end

local getHashValues = function (k, attr, tonum)
  local result = {}
  local ks = keys(k)
  for index, key in pairs(ks) do
    local cell = redis.call("HGET", key, attr)
    table.insert(result, cond_tonum(cell, tonum))
  end
  return result
end

local calculate_count = function (key)
  return #keys(key)
end

local calculate_pluck = function (key, attr)
  return getHashValues(key, attr, false)
end

local calculate_max = function (key, attr)
  local res = getHashValues(key, attr, true)
  table.sort(res)
  return res[#res]
end

local calculate_min = function (key, attr)
  local res = getHashValues(key, attr, true)
  table.sort(res)
  return res[1]
end

local calculate_sum = function (key, attr)
  local res = getHashValues(key, attr, true)
  local sum = 0
  for index, s in pairs(res) do
    sum = sum + s
  end
  return sum
end