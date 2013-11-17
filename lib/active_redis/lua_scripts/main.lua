-- Split string by pattern
--
-- pString  - input string
-- pPattern - pattern for splitting
--
-- returns: array of string's parts
local split = function (pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
        table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

-- Fetching keys by pattern
--
-- k - pattern for searching
--
-- return: list of keys by pattern
local keys = function (k)
  return redis.call("KEYS", k)
end

-- Specify is record match conditions or not
--
-- key  - record key
-- argv - array with conditions
--
-- return: true if matched or false otherwise
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

-- Splitting input string with key=value to array
--
-- str - string like "attr1=value1, attr2=value2"
--
-- return: array
local fetch_conditions = function(str)
  local t = {}
  for i, value in pairs(split(str, ",")) do
    local res = split(value, "=")
    table.insert(t, res[1])
    table.insert(t, res[2])
  end
  return t
end

-- Applying where conditions for table set
--
-- key      - table name
-- cond_str - conditions represented as string
--
-- return: key of result id list
local apply_where = function(key, cond_str, seed)
  math.randomseed(seed)
  local cond_array = fetch_conditions(cond_str)
  local ks = keys(key)
  local list_name = "templist:"..math.random()
  for index, k in pairs(ks) do
    if is_match_record(k, cond_array) == true then
      redis.call("RPUSH", list_name, redis.call("HGET", k, "id"))
    end
  end
  return list_name
end

-- Applying order conditions to command string
--
-- key      - table name
-- command  - current query to redis
-- cond_str - conditions represented as string
--
-- returns: changed command string with sorting by
local apply_order = function(key, command, cond_str)
  table.insert(command, 'BY')
  if string.len(cond_str) == 0 then
    table.insert(command, 'nosort')
  else
    local cond_array = fetch_conditions(cond_str)
    table.insert(command, key.."->"..cond_array[1])
    table.insert(command, "ALPHA")
    table.insert(command, cond_array[2])
  end
  return command
end

-- Applying limit conditions to command string
--
-- command  - current query to redis
-- cond_str - conditions represented as string
--
-- returns: changed command string with limit
local apply_limit = function(command, cond_str)
  if string.len(cond_str) ~= 0 then
    local cond_array = fetch_conditions(cond_str)
    table.insert(command, "LIMIT")
    table.insert(command, cond_array[1])
    table.insert(command, cond_array[2])
  end
  return command
end

-- Fetching record by table name and id
--
-- key - table name
-- id  - record id
--
-- returns: record hash
local fetch_row = function(key, id)
  local name = string.sub(key, 1, -2)
  name = name..id
  return redis.call("HGETALL", name)
end

-- Fetching objects collection by query params
--
-- key  - table name
-- argv - array with query params
local fetch_collection = function(keys, argv)
  local temp_list = apply_where(keys[1], argv[1], tonumber(keys[2]))
  local sort_command = {"SORT", temp_list}
  sort_command = apply_order(keys[1], sort_command, argv[2])
  sort_command = apply_limit(sort_command, argv[3])
  local ids = redis.call(unpack(sort_command))
  local result = {}
  for index, id in pairs(ids) do
    table.insert(result, fetch_row(keys[1], id))
  end
  return result
end

-- Fetching value from record by field name
--
-- record - record array
-- field  - field name
local fetch_value_by_field = function(record, field)
  for i = 1, #record, 2 do
    if record[i] == field then
      return record[i+1]
    end
  end
  return ""
end

-- Fetching values from specified field to array
--
-- collection - array of objects
-- param      - field name
local fetch_field_values_array = function(collection, field)
  local result = {}
  for index, record in pairs(collection) do
    table.insert(result, fetch_value_by_field(record, param))
  end
  return result
end

local aggregation_functions = {
  -- Applying count aggregation function
  --
  -- collection - array of objects for processing
  -- param      - particular param for aggregation function
  aggregation_count = function(collection, param)
    return #collection
  end,

  -- Applying sum aggregation function
  --
  -- collection - array of objects for processing
  -- param      - particular param for aggregation function
  aggregation_sum = function(collection, param)
    local sum = 0
    for index, record in pairs(collection) do
      sum = sum + tonumber(fetch_value_by_field(record, param))
    end
    return sum
  end,

  -- Applying pluck aggregation function
  --
  -- collection - array of objects for processing
  -- param      - particular param for aggregation function
  aggregation_pluck = function(collection, param)
    return fetch_field_values_array(collection, param)
  end,

  -- Applying min aggregation function
  --
  -- collection - array of objects for processing
  -- param      - particular param for aggregation function
  aggregation_min = function(collection, param)
    local result = fetch_field_values_array(collection, param)
    table.sort(result)
    return result[1]
  end,

  -- Applying max aggregation function
  --
  -- collection - array of objects for processing
  -- param      - particular param for aggregation function
  aggregation_max = function(collection, param)
    local result = fetch_field_values_array(collection, param)
    table.sort(result)
    return result[#result]
  end
}

-- Applying aggregation functions to collection
--
-- collection   - array of objects for processing
-- aggr_options - string with aggregation information
local process_aggregation = function(collection, aggr_options)
  local aggr_arr = split(aggr_options, "=")
  local aggr_function_name = "aggregation_"..aggr_arr[1]
  --return _G[aggr_function_name](collection, aggr_arr[2])
  return aggregation_functions[aggr_function_name](collection, aggr_arr[2])
end

-- Checking if query is single value
--
-- argv - array with query parameters
local is_single_value_query = function(argv)
  return string.len(argv[4]) ~= 0
end

-- Query analyzer for searching
--
-- key  - table name
-- argv - array with query parameters WHERE, ORDER, LIMIT, AGGREGATION
local query_analyzer = function (keys, argv)
  local collection = fetch_collection(keys, argv)
  if is_single_value_query(argv) == true then
    return process_aggregation(collection, argv[4])
  else
    return collection
  end
end
