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

local is_match_record = function (key, argv)
  for i = 1, #argv, 2 do
    local k = argv[i]
    local value = argv[i+1]
    if (redis.call("HGET", key, k) ~= value) then
      return false
    end
  end
  return true
end

local where_finder = function (key, argv)
  local result = {}
  local ks = keys(key)
  for index, k in pairs(ks) do
    if is_match_record(k, argv) == true then
      table.insert(result, redis.call("HGETALL", k))
    end
  end
  return result
end