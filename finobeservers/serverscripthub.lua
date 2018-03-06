local portrange={1911,1980}
local nextport=math.random(1912,1950)

local key="slappystop";

function _G.HttpGet(site,x)
	local x=x or true;
	--local a,b=pcall(function()
		return game:HttpGet(site,x)
	--end)
	--[[if a then
		return b
	else
		return "error"
	end ]]
end 
function _G.HttpPost(site) 
	--pcall(function()
		return game:HttpPost(site)
	--end)
end 

--quick run json!

function JSONfunction() --json parser
-- -*- coding: utf-8 -*-
--
-- Simple JSON encoding and decoding in pure Lua.
--
-- Copyright 2010-2017 Jeffrey Friedl
-- http://regex.info/blog/
-- Latest version: http://regex.info/blog/lua/json
--
-- This code is released under a Creative Commons CC-BY "Attribution" License:
-- http://creativecommons.org/licenses/by/3.0/deed.en_US
--
-- It can be used for any purpose so long as:
--    1) the copyright notice above is maintained
--    2) the web-page links above are maintained
--    3) the 'AUTHOR_NOTE' string below is maintained
--
local VERSION = '20170927.26' -- version history at end of file
local AUTHOR_NOTE = "-[ JSON.lua package by Jeffrey Friedl (http://regex.info/blog/lua/json) version 20170927.26 ]-"

--
-- The 'AUTHOR_NOTE' variable exists so that information about the source
-- of the package is maintained even in compiled versions. It's also
-- included in OBJDEF below mostly to quiet warnings about unused variables.
--
local OBJDEF = {
   VERSION      = VERSION,
   AUTHOR_NOTE  = AUTHOR_NOTE,
}


--
-- Simple JSON encoding and decoding in pure Lua.
-- JSON definition: http://www.json.org/
--
--
--   JSON = assert(loadfile "JSON.lua")() -- one-time load of the routines
--
--   local lua_value = JSON:decode(raw_json_text)
--
--   local raw_json_text    = JSON:encode(lua_table_or_value)
--   local pretty_json_text = JSON:encode_pretty(lua_table_or_value) -- "pretty printed" version for human readability
--
--
--
-- DECODING (from a JSON string to a Lua table)
--
--
--   JSON = assert(loadfile "JSON.lua")() -- one-time load of the routines
--
--   local lua_value = JSON:decode(raw_json_text)
--
--   If the JSON text is for an object or an array, e.g.
--     { "what": "books", "count": 3 }
--   or
--     [ "Larry", "Curly", "Moe" ]
--
--   the result is a Lua table, e.g.
--     { what = "books", count = 3 }
--   or
--     { "Larry", "Curly", "Moe" }
--
--
--   The encode and decode routines accept an optional second argument,
--   "etc", which is not used during encoding or decoding, but upon error
--   is passed along to error handlers. It can be of any type (including nil).
--
--
--
-- ERROR HANDLING DURING DECODE
--
--   With most errors during decoding, this code calls
--
--      JSON:onDecodeError(message, text, location, etc)
--
--   with a message about the error, and if known, the JSON text being
--   parsed and the byte count where the problem was discovered. You can
--   replace the default JSON:onDecodeError() with your own function.
--
--   The default onDecodeError() merely augments the message with data
--   about the text and the location (and, an 'etc' argument had been
--   provided to decode(), its value is tacked onto the message as well),
--   and then calls JSON.assert(), which itself defaults to Lua's built-in
--   assert(), and can also be overridden.
--
--   For example, in an Adobe Lightroom plugin, you might use something like
--
--          function JSON:onDecodeError(message, text, location, etc)
--             LrErrors.throwUserError("Internal Error: invalid JSON data")
--          end
--
--   or even just
--
--          function JSON.assert(message)
--             LrErrors.throwUserError("Internal Error: " .. message)
--          end
--
--   If JSON:decode() is passed a nil, this is called instead:
--
--      JSON:onDecodeOfNilError(message, nil, nil, etc)
--
--   and if JSON:decode() is passed HTML instead of JSON, this is called:
--
--      JSON:onDecodeOfHTMLError(message, text, nil, etc)
--
--   The use of the 'etc' argument allows stronger coordination between
--   decoding and error reporting, especially when you provide your own
--   error-handling routines. Continuing with the the Adobe Lightroom
--   plugin example:
--
--          function JSON:onDecodeError(message, text, location, etc)
--             local note = "Internal Error: invalid JSON data"
--             if type(etc) = 'table' and etc.photo then
--                note = note .. " while processing for " .. etc.photo:getFormattedMetadata('fileName')
--             end
--             LrErrors.throwUserError(note)
--          end
--
--            :
--            :
--
--          for i, photo in ipairs(photosToProcess) do
--               :             
--               :             
--               local data = JSON:decode(someJsonText, { photo = photo })
--               :             
--               :             
--          end
--
--
--
--   If the JSON text passed to decode() has trailing garbage (e.g. as with the JSON "[123]xyzzy"),
--   the method
--
--       JSON:onTrailingGarbage(json_text, location, parsed_value, etc)
--
--   is invoked, where:
--
--       'json_text' is the original JSON text being parsed,
--       'location' is the count of bytes into 'json_text' where the garbage starts (6 in the example),
--       'parsed_value' is the Lua result of what was successfully parsed ({123} in the example),
--       'etc' is as above.
--
--   If JSON:onTrailingGarbage() does not abort, it should return the value decode() should return,
--   or nil + an error message.
--
--     local new_value, error_message = JSON:onTrailingGarbage()
--
--   The default JSON:onTrailingGarbage() simply invokes JSON:onDecodeError("trailing garbage"...),
--   but you can have this package ignore trailing garbage via
--
--      function JSON:onTrailingGarbage(json_text, location, parsed_value, etc)
--         return parsed_value
--      end
--
--
-- DECODING AND STRICT TYPES
--
--   Because both JSON objects and JSON arrays are converted to Lua tables,
--   it's not normally possible to tell which original JSON type a
--   particular Lua table was derived from, or guarantee decode-encode
--   round-trip equivalency.
--
--   However, if you enable strictTypes, e.g.
--
--      JSON = assert(loadfile "JSON.lua")() --load the routines
--      JSON.strictTypes = true
--
--   then the Lua table resulting from the decoding of a JSON object or
--   JSON array is marked via Lua metatable, so that when re-encoded with
--   JSON:encode() it ends up as the appropriate JSON type.
--
--   (This is not the default because other routines may not work well with
--   tables that have a metatable set, for example, Lightroom API calls.)
--
--
-- ENCODING (from a lua table to a JSON string)
--
--   JSON = assert(loadfile "JSON.lua")() -- one-time load of the routines
--
--   local raw_json_text    = JSON:encode(lua_table_or_value)
--   local pretty_json_text = JSON:encode_pretty(lua_table_or_value) -- "pretty printed" version for human readability
--   local custom_pretty    = JSON:encode(lua_table_or_value, etc, { pretty = true, indent = "|  ", align_keys = false })
--
--   On error during encoding, this code calls:
--
--     JSON:onEncodeError(message, etc)
--
--   which you can override in your local JSON object. Also see "HANDLING UNSUPPORTED VALUE TYPES" below.
--
--   The 'etc' in the error call is the second argument to encode() and encode_pretty(), or nil if it wasn't provided.
--
--
--
--
-- ENCODING OPTIONS
--
--   An optional third argument, a table of options, can be provided to encode().
--
--       encode_options =  {
--           -- options for making "pretty" human-readable JSON (see "PRETTY-PRINTING" below)
--           pretty         = true,   -- turn pretty formatting on
--           indent         = "   ",  -- use this indent for each level of an array/object
--           align_keys     = false,  -- if true, align the keys in a way that sounds like it should be nice, but is actually ugly
--           array_newline  = false,  -- if true, array elements become one to a line rather than inline
--           
--           -- other output-related options
--           null           = "\0",   -- see "ENCODING JSON NULL VALUES" below
--           stringsAreUtf8 = false,  -- see "HANDLING UNICODE LINE AND PARAGRAPH SEPARATORS FOR JAVA" below
--       }
--  
--       json_string = JSON:encode(mytable, etc, encode_options)
--
--
--
-- For reference, the defaults are:
--
--           pretty         = false
--           null           = nil,
--           stringsAreUtf8 = false,
--
--
--
-- PRETTY-PRINTING
--
--   Enabling the 'pretty' encode option helps generate human-readable JSON.
--
--     pretty = JSON:encode(val, etc, {
--                                       pretty = true,
--                                       indent = "   ",
--                                       align_keys = false,
--                                     })
--
--   encode_pretty() is also provided: it's identical to encode() except
--   that encode_pretty() provides a default options table if none given in the call:
--
--       { pretty = true, indent = "  ", align_keys = false, array_newline = false }
--
--   For example, if
--
--      JSON:encode(data)
--
--   produces:
--
--      {"city":"Kyoto","climate":{"avg_temp":16,"humidity":"high","snowfall":"minimal"},"country":"Japan","wards":11}
--
--   then
--
--      JSON:encode_pretty(data)
--
--   produces:
--
--      {
--        "city": "Kyoto",
--        "climate": {
--          "avg_temp": 16,
--          "humidity": "high",
--          "snowfall": "minimal"
--        },
--        "country": "Japan",
--        "wards": 11
--      }
--
--   The following lines all return identical strings:
--       JSON:encode_pretty(data)
--       JSON:encode_pretty(data, nil, { pretty = true, indent = "  ", align_keys = false, array_newline = false})
--       JSON:encode_pretty(data, nil, { pretty = true, indent = "  " })
--       JSON:encode       (data, nil, { pretty = true, indent = "  " })
--
--   An example of setting your own indent string:
--
--     JSON:encode_pretty(data, nil, { pretty = true, indent = "|    " })
--
--   produces:
--
--      {
--      |    "city": "Kyoto",
--      |    "climate": {
--      |    |    "avg_temp": 16,
--      |    |    "humidity": "high",
--      |    |    "snowfall": "minimal"
--      |    },
--      |    "country": "Japan",
--      |    "wards": 11
--      }
--
--   An example of setting align_keys to true:
--
--     JSON:encode_pretty(data, nil, { pretty = true, indent = "  ", align_keys = true })
--  
--   produces:
--   
--      {
--           "city": "Kyoto",
--        "climate": {
--                     "avg_temp": 16,
--                     "humidity": "high",
--                     "snowfall": "minimal"
--                   },
--        "country": "Japan",
--          "wards": 11
--      }
--
--   which I must admit is kinda ugly, sorry. This was the default for
--   encode_pretty() prior to version 20141223.14.
--
--
--  HANDLING UNICODE LINE AND PARAGRAPH SEPARATORS FOR JAVA
--
--    If the 'stringsAreUtf8' encode option is set to true, consider Lua strings not as a sequence of bytes,
--    but as a sequence of UTF-8 characters.
--
--    Currently, the only practical effect of setting this option is that Unicode LINE and PARAGRAPH
--    separators, if found in a string, are encoded with a JSON escape instead of being dumped as is.
--    The JSON is valid either way, but encoding this way, apparently, allows the resulting JSON
--    to also be valid Java.
--
--  AMBIGUOUS SITUATIONS DURING THE ENCODING
--
--   During the encode, if a Lua table being encoded contains both string
--   and numeric keys, it fits neither JSON's idea of an object, nor its
--   idea of an array. To get around this, when any string key exists (or
--   when non-positive numeric keys exist), numeric keys are converted to
--   strings.
--
--   For example, 
--     JSON:encode({ "one", "two", "three", SOMESTRING = "some string" }))
--   produces the JSON object
--     {"1":"one","2":"two","3":"three","SOMESTRING":"some string"}
--
--   To prohibit this conversion and instead make it an error condition, set
--      JSON.noKeyConversion = true
--
--
-- ENCODING JSON NULL VALUES
--
--   Lua tables completely omit keys whose value is nil, so without special handling there's
--   no way to represent JSON object's null value in a Lua table.  For example
--      JSON:encode({ username = "admin", password = nil })
--
--   produces:
--
--      {"username":"admin"}
--
--   In order to actually produce
--
--      {"username":"admin", "password":null}
--

--   one can include a string value for a "null" field in the options table passed to encode().... 
--   any Lua table entry with that value becomes null in the JSON output:
--
--      JSON:encode({ username = "admin", password = "xyzzy" }, -- First arg is the Lua table to encode as JSON.
--                  nil,                                        -- Second arg is the 'etc' value, ignored here
--                  { null = "xyzzy" })                         -- Third arg is th options table
--
--   produces:
--
--      {"username":"admin", "password":null}
--
--   Just be sure to use a string that is otherwise unlikely to appear in your data.
--   The string "\0" (a string with one null byte) may well be appropriate for many applications.
--
--   The "null" options also applies to Lua tables that become JSON arrays.
--      JSON:encode({ "one", "two", nil, nil })
--
--   produces
--
--      ["one","two"]
--
--   while
--
--      NullPlaceholder = "\0"
--      encode_options = { null = NullPlaceholder }
--      JSON:encode({ "one", "two", NullPlaceholder, NullPlaceholder}, nil, encode_options)
--   produces
--
--      ["one","two",null,null]
--
--
--
-- HANDLING LARGE AND/OR PRECISE NUMBERS
--
--
--   Without special handling, numbers in JSON can lose precision in Lua.
--   For example:
--   
--      T = JSON:decode('{  "small":12345, "big":12345678901234567890123456789, "precise":9876.67890123456789012345  }')
--
--      print("small:   ",  type(T.small),    T.small)
--      print("big:     ",  type(T.big),      T.big)
--      print("precise: ",  type(T.precise),  T.precise)
--   
--   produces
--   
--      small:          number  12345
--      big:            number  1.2345678901235e+28
--      precise:        number  9876.6789012346
--
--   Precision is lost with both 'big' and 'precise'.
--
--   This package offers ways to try to handle this better (for some definitions of "better")...
--
--   The most precise method is by setting the global:
--   
--      JSON.decodeNumbersAsObjects = true
--   
--   When this is set, numeric JSON data is encoded into Lua in a form that preserves the exact
--   JSON numeric presentation when re-encoded back out to JSON, or accessed in Lua as a string.
--
--   This is done by encoding the numeric data with a Lua table/metatable that returns
--   the possibly-imprecise numeric form when accessed numerically, but the original precise
--   representation when accessed as a string.
--
--   Consider the example above, with this option turned on:
--
--      JSON.decodeNumbersAsObjects = true
--      
--      T = JSON:decode('{  "small":12345, "big":12345678901234567890123456789, "precise":9876.67890123456789012345  }')
--
--      print("small:   ",  type(T.small),    T.small)
--      print("big:     ",  type(T.big),      T.big)
--      print("precise: ",  type(T.precise),  T.precise)
--   
--   This now produces:
--   
--      small:          table   12345
--      big:            table   12345678901234567890123456789
--      precise:        table   9876.67890123456789012345
--   
--   However, within Lua you can still use the values (e.g. T.precise in the example above) in numeric
--   contexts. In such cases you'll get the possibly-imprecise numeric version, but in string contexts
--   and when the data finds its way to this package's encode() function, the original full-precision
--   representation is used.
--
--   You can force access to the string or numeric version via
--        JSON:forceString()
--        JSON:forceNumber()
--   For example,
--        local probably_okay = JSON:forceNumber(T.small) -- 'probably_okay' is a number
--
--   Code the inspects the JSON-turned-Lua data using type() can run into troubles because what used to
--   be a number can now be a table (e.g. as the small/big/precise example above shows). Update these
--   situations to use JSON:isNumber(item), which returns nil if the item is neither a number nor one
--   of these number objects. If it is either, it returns the number itself. For completeness there's
--   also JSON:isString(item).
--
--   If you want to try to avoid the hassles of this "number as an object" kludge for all but really
--   big numbers, you can set JSON.decodeNumbersAsObjects and then also set one or both of
--            JSON:decodeIntegerObjectificationLength
--            JSON:decodeDecimalObjectificationLength
--   They refer to the length of the part of the number before and after a decimal point. If they are
--   set and their part is at least that number of digits, objectification occurs. If both are set,
--   objectification occurs when either length is met.
--
--   -----------------------
--
--   Even without using the JSON.decodeNumbersAsObjects option, you can encode numbers in your Lua
--   table that retain high precision upon encoding to JSON, by using the JSON:asNumber() function:
--
--      T = {
--         imprecise =                123456789123456789.123456789123456789,
--         precise   = JSON:asNumber("123456789123456789.123456789123456789")
--      }
--
--      print(JSON:encode_pretty(T))
--
--   This produces:
--
--      { 
--         "precise": 123456789123456789.123456789123456789,
--         "imprecise": 1.2345678912346e+17
--      }
--
--
--   -----------------------
--
--   A different way to handle big/precise JSON numbers is to have decode() merely return the exact
--   string representation of the number instead of the number itself. This approach might be useful
--   when the numbers are merely some kind of opaque object identifier and you want to work with them
--   in Lua as strings anyway.
--   
--   This approach is enabled by setting
--
--      JSON.decodeIntegerStringificationLength = 10
--
--   The value is the number of digits (of the integer part of the number) at which to stringify numbers.
--   NOTE: this setting is ignored if JSON.decodeNumbersAsObjects is true, as that takes precedence.
--
--   Consider our previous example with this option set to 10:
--
--      JSON.decodeIntegerStringificationLength = 10
--      
--      T = JSON:decode('{  "small":12345, "big":12345678901234567890123456789, "precise":9876.67890123456789012345  }')
--
--      print("small:   ",  type(T.small),    T.small)
--      print("big:     ",  type(T.big),      T.big)
--      print("precise: ",  type(T.precise),  T.precise)
--
--   This produces:
--
--      small:          number  12345
--      big:            string  12345678901234567890123456789
--      precise:        number  9876.6789012346
--
--   The long integer of the 'big' field is at least JSON.decodeIntegerStringificationLength digits
--   in length, so it's converted not to a Lua integer but to a Lua string. Using a value of 0 or 1 ensures
--   that all JSON numeric data becomes strings in Lua.
--
--   Note that unlike
--      JSON.decodeNumbersAsObjects = true
--   this stringification is simple and unintelligent: the JSON number simply becomes a Lua string, and that's the end of it.
--   If the string is then converted back to JSON, it's still a string. After running the code above, adding
--      print(JSON:encode(T))
--   produces
--      {"big":"12345678901234567890123456789","precise":9876.6789012346,"small":12345}
--   which is unlikely to be desired.
--
--   There's a comparable option for the length of the decimal part of a number:
--
--      JSON.decodeDecimalStringificationLength
--
--   This can be used alone or in conjunction with
--
--      JSON.decodeIntegerStringificationLength
--
--   to trip stringification on precise numbers with at least JSON.decodeIntegerStringificationLength digits after
--   the decimal point. (Both are ignored if JSON.decodeNumbersAsObjects is true.)
--
--   This example:
--
--      JSON.decodeIntegerStringificationLength = 10
--      JSON.decodeDecimalStringificationLength =  5
--
--      T = JSON:decode('{  "small":12345, "big":12345678901234567890123456789, "precise":9876.67890123456789012345  }')
--      
--      print("small:   ",  type(T.small),    T.small)
--      print("big:     ",  type(T.big),      T.big)
--      print("precise: ",  type(T.precise),  T.precise)
--
--  produces:
--
--      small:          number  12345
--      big:            string  12345678901234567890123456789
--      precise:        string  9876.67890123456789012345
--
--
--  HANDLING UNSUPPORTED VALUE TYPES
--
--   Among the encoding errors that might be raised is an attempt to convert a table value that has a type
--   that this package hasn't accounted for: a function, userdata, or a thread. You can handle these types as table
--   values (but not as table keys) if you supply a JSON:unsupportedTypeEncoder() method along the lines of the
--   following example:
--        
--        function JSON:unsupportedTypeEncoder(value_of_unsupported_type)
--           if type(value_of_unsupported_type) == 'function' then
--              return "a function value"
--           else
--              return nil
--           end
--        end
--        
--   Your unsupportedTypeEncoder() method is actually called with a bunch of arguments:
--
--      self:unsupportedTypeEncoder(value, parents, etc, options, indent, for_key)
--
--   The 'value' is the function, thread, or userdata to be converted to JSON.
--
--   The 'etc' and 'options' arguments are those passed to the original encode(). The other arguments are
--   probably of little interest; see the source code. (Note that 'for_key' is never true, as this function
--   is invoked only on table values; table keys of these types still trigger the onEncodeError method.)
--
--   If your unsupportedTypeEncoder() method returns a string, it's inserted into the JSON as is.
--   If it returns nil plus an error message, that error message is passed through to an onEncodeError invocation.
--   If it returns only nil, processing falls through to a default onEncodeError invocation.
--
--   If you want to handle everything in a simple way:
--
--        function JSON:unsupportedTypeEncoder(value)
--           return tostring(value)
--        end
--
--
-- SUMMARY OF METHODS YOU CAN OVERRIDE IN YOUR LOCAL LUA JSON OBJECT
--
--    assert
--    onDecodeError
--    onDecodeOfNilError
--    onDecodeOfHTMLError
--    onTrailingGarbage
--    onEncodeError
--    unsupportedTypeEncoder
--
--  If you want to create a separate Lua JSON object with its own error handlers,
--  you can reload JSON.lua or use the :new() method.
--
---------------------------------------------------------------------------

local default_pretty_indent  = "  "
local default_pretty_options = { pretty = true, indent = default_pretty_indent, align_keys = false, array_newline = false }

local isArray  = { __tostring = function() return "JSON array"         end }  isArray.__index  = isArray
local isObject = { __tostring = function() return "JSON object"        end }  isObject.__index = isObject

function OBJDEF:newArray(tbl)
   return setmetatable(tbl or {}, isArray)
end

function OBJDEF:newObject(tbl)
   return setmetatable(tbl or {}, isObject)
end




local function getnum(op)
   return type(op) == 'number' and op or op.N
end

local isNumber = {
   __tostring = function(T)  return T.S        end,
   __unm      = function(op) return getnum(op) end,

   __concat   = function(op1, op2) return tostring(op1) .. tostring(op2) end,
   __add      = function(op1, op2) return getnum(op1)   +   getnum(op2)  end,
   __sub      = function(op1, op2) return getnum(op1)   -   getnum(op2)  end,
   __mul      = function(op1, op2) return getnum(op1)   *   getnum(op2)  end,
   __div      = function(op1, op2) return getnum(op1)   /   getnum(op2)  end,
   __mod      = function(op1, op2) return getnum(op1)   %   getnum(op2)  end,
   __pow      = function(op1, op2) return getnum(op1)   ^   getnum(op2)  end,
   __lt       = function(op1, op2) return getnum(op1)   <   getnum(op2)  end,
   __eq       = function(op1, op2) return getnum(op1)   ==  getnum(op2)  end,
   __le       = function(op1, op2) return getnum(op1)   <=  getnum(op2)  end,
}
isNumber.__index = isNumber

function OBJDEF:asNumber(item)

   if getmetatable(item) == isNumber then
      -- it's already a JSON number object.
      return item
   elseif type(item) == 'table' and type(item.S) == 'string' and type(item.N) == 'number' then
      -- it's a number-object table that lost its metatable, so give it one
      return setmetatable(item, isNumber)
   else
      -- the normal situation... given a number or a string representation of a number....
      local holder = {
         S = tostring(item), -- S is the representation of the number as a string, which remains precise
         N = tonumber(item), -- N is the number as a Lua number.
      }
      return setmetatable(holder, isNumber)
   end
end

--
-- Given an item that might be a normal string or number, or might be an 'isNumber' object defined above,
-- return the string version. This shouldn't be needed often because the 'isNumber' object should autoconvert
-- to a string in most cases, but it's here to allow it to be forced when needed.
--
function OBJDEF:forceString(item)
   if type(item) == 'table' and type(item.S) == 'string' then
      return item.S
   else
      return tostring(item)
   end
end

--
-- Given an item that might be a normal string or number, or might be an 'isNumber' object defined above,
-- return the numeric version.
--
function OBJDEF:forceNumber(item)
   if type(item) == 'table' and type(item.N) == 'number' then
      return item.N
   else
      return tonumber(item)
   end
end

--
-- If the given item is a number, return it. Otherwise, return nil.
-- This, this can be used both in a conditional and to access the number when you're not sure its form.
--
function OBJDEF:isNumber(item)
   if type(item) == 'number' then
      return item
   elseif type(item) == 'table' and type(item.N) == 'number' then
      return item.N
   else
      return nil
   end
end

function OBJDEF:isString(item)
   if type(item) == 'string' then
      return item
   elseif type(item) == 'table' and type(item.S) == 'string' then
      return item.S
   else
      return nil
   end
end


local function unicode_codepoint_as_utf8(codepoint)
   --
   -- codepoint is a number
   --
   if codepoint <= 127 then
      return string.char(codepoint)

   elseif codepoint <= 2047 then
      --
      -- 110yyyxx 10xxxxxx         <-- useful notation from http://en.wikipedia.org/wiki/Utf8
      --
      local highpart = math.floor(codepoint / 0x40)
      local lowpart  = codepoint - (0x40 * highpart)
      return string.char(0xC0 + highpart,
                         0x80 + lowpart)

   elseif codepoint <= 65535 then
      --
      -- 1110yyyy 10yyyyxx 10xxxxxx
      --
      local highpart  = math.floor(codepoint / 0x1000)
      local remainder = codepoint - 0x1000 * highpart
      local midpart   = math.floor(remainder / 0x40)
      local lowpart   = remainder - 0x40 * midpart

      highpart = 0xE0 + highpart
      midpart  = 0x80 + midpart
      lowpart  = 0x80 + lowpart

      --
      -- Check for an invalid character (thanks Andy R. at Adobe).
      -- See table 3.7, page 93, in http://www.unicode.org/versions/Unicode5.2.0/ch03.pdf#G28070
      --
      if ( highpart == 0xE0 and midpart < 0xA0 ) or
         ( highpart == 0xED and midpart > 0x9F ) or
         ( highpart == 0xF0 and midpart < 0x90 ) or
         ( highpart == 0xF4 and midpart > 0x8F )
      then
         return "?"
      else
         return string.char(highpart,
                            midpart,
                            lowpart)
      end

   else
      --
      -- 11110zzz 10zzyyyy 10yyyyxx 10xxxxxx
      --
      local highpart  = math.floor(codepoint / 0x40000)
      local remainder = codepoint - 0x40000 * highpart
      local midA      = math.floor(remainder / 0x1000)
      remainder       = remainder - 0x1000 * midA
      local midB      = math.floor(remainder / 0x40)
      local lowpart   = remainder - 0x40 * midB

      return string.char(0xF0 + highpart,
                         0x80 + midA,
                         0x80 + midB,
                         0x80 + lowpart)
   end
end

function OBJDEF:onDecodeError(message, text, location, etc)
   if text then
      if location then
         message = string.format("%s at byte %d of: %s", message, location, text)
      else
         message = string.format("%s: %s", message, text)
      end
   end

   if etc ~= nil then
      message = message .. " (" .. OBJDEF:encode(etc) .. ")"
   end

   if self.assert then
      self.assert(false, message)
   else
      assert(false, message)
   end
end

function OBJDEF:onTrailingGarbage(json_text, location, parsed_value, etc)
   return self:onDecodeError("trailing garbage", json_text, location, etc)
end

OBJDEF.onDecodeOfNilError  = OBJDEF.onDecodeError
OBJDEF.onDecodeOfHTMLError = OBJDEF.onDecodeError

function OBJDEF:onEncodeError(message, etc)
   if etc ~= nil then
      message = message .. " (" .. OBJDEF:encode(etc) .. ")"
   end

   if self.assert then
      self.assert(false, message)
   else
      assert(false, message)
   end
end

local function grok_number(self, text, start, options)
   --
   -- Grab the integer part
   --
   local integer_part = text:match('^-?[1-9]%d*', start)
                     or text:match("^-?0",        start)

   if not integer_part then
      self:onDecodeError("expected number", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   local i = start + integer_part:len()

   --
   -- Grab an optional decimal part
   --
   local decimal_part = text:match('^%.%d+', i) or ""

   i = i + decimal_part:len()

   --
   -- Grab an optional exponential part
   --
   local exponent_part = text:match('^[eE][-+]?%d+', i) or ""

   i = i + exponent_part:len()

   local full_number_text = integer_part .. decimal_part .. exponent_part

   if options.decodeNumbersAsObjects then

      local objectify = false

      if not options.decodeIntegerObjectificationLength and not options.decodeDecimalObjectificationLength then
         -- no options, so objectify
         objectify = true

      elseif (options.decodeIntegerObjectificationLength
          and
         (integer_part:len() >= options.decodeIntegerObjectificationLength or exponent_part:len() > 0))

          or
         (options.decodeDecimalObjectificationLength 
          and
          (decimal_part:len() >= options.decodeDecimalObjectificationLength  or exponent_part:len() > 0))
      then
         -- have options and they are triggered, so objectify
         objectify = true
      end

      if objectify then
         return OBJDEF:asNumber(full_number_text), i
      end
      -- else, fall through to try to return as a straight-up number

   else

      -- Not always decoding numbers as objects, so perhaps encode as strings?

      --
      -- If we're told to stringify only under certain conditions, so do.
      -- We punt a bit when there's an exponent by just stringifying no matter what.
      -- I suppose we should really look to see whether the exponent is actually big enough one
      -- way or the other to trip stringification, but I'll be lazy about it until someone asks.
      --
      if (options.decodeIntegerStringificationLength
          and
         (integer_part:len() >= options.decodeIntegerStringificationLength or exponent_part:len() > 0))

          or

         (options.decodeDecimalStringificationLength 
          and
          (decimal_part:len() >= options.decodeDecimalStringificationLength or exponent_part:len() > 0))
      then
         return full_number_text, i -- this returns the exact string representation seen in the original JSON
      end

   end


   local as_number = tonumber(full_number_text)

   if not as_number then
      self:onDecodeError("bad number", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   return as_number, i
end


local function grok_string(self, text, start, options)

   if text:sub(start,start) ~= '"' then
      self:onDecodeError("expected string's opening quote", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   local i = start + 1 -- +1 to bypass the initial quote
   local text_len = text:len()
   local VALUE = ""
   while i <= text_len do
      local c = text:sub(i,i)
      if c == '"' then
         return VALUE, i + 1
      end
      if c ~= '\\' then
         VALUE = VALUE .. c
         i = i + 1
      elseif text:match('^\\b', i) then
         VALUE = VALUE .. "\b"
         i = i + 2
      elseif text:match('^\\f', i) then
         VALUE = VALUE .. "\f"
         i = i + 2
      elseif text:match('^\\n', i) then
         VALUE = VALUE .. "\n"
         i = i + 2
      elseif text:match('^\\r', i) then
         VALUE = VALUE .. "\r"
         i = i + 2
      elseif text:match('^\\t', i) then
         VALUE = VALUE .. "\t"
         i = i + 2
      else
         local hex = text:match('^\\u([0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])', i)
         if hex then
            i = i + 6 -- bypass what we just read

            -- We have a Unicode codepoint. It could be standalone, or if in the proper range and
            -- followed by another in a specific range, it'll be a two-code surrogate pair.
            local codepoint = tonumber(hex, 16)
            if codepoint >= 0xD800 and codepoint <= 0xDBFF then
               -- it's a hi surrogate... see whether we have a following low
               local lo_surrogate = text:match('^\\u([dD][cdefCDEF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])', i)
               if lo_surrogate then
                  i = i + 6 -- bypass the low surrogate we just read
                  codepoint = 0x2400 + (codepoint - 0xD800) * 0x400 + tonumber(lo_surrogate, 16)
               else
                  -- not a proper low, so we'll just leave the first codepoint as is and spit it out.
               end
            end
            VALUE = VALUE .. unicode_codepoint_as_utf8(codepoint)

         else

            -- just pass through what's escaped
            VALUE = VALUE .. text:match('^\\(.)', i)
            i = i + 2
         end
      end
   end

   self:onDecodeError("unclosed string", text, start, options.etc)
   return nil, start -- in case the error method doesn't abort, return something sensible
end

local function skip_whitespace(text, start)

   local _, match_end = text:find("^[ \n\r\t]+", start) -- [http://www.ietf.org/rfc/rfc4627.txt] Section 2
   if match_end then
      return match_end + 1
   else
      return start
   end
end

local grok_one -- assigned later

local function grok_object(self, text, start, options)

   if text:sub(start,start) ~= '{' then
      self:onDecodeError("expected '{'", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   local i = skip_whitespace(text, start + 1) -- +1 to skip the '{'

   local VALUE = self.strictTypes and self:newObject { } or { }

   if text:sub(i,i) == '}' then
      return VALUE, i + 1
   end
   local text_len = text:len()
   while i <= text_len do
      local key, new_i = grok_string(self, text, i, options)

      i = skip_whitespace(text, new_i)

      if text:sub(i, i) ~= ':' then
         self:onDecodeError("expected colon", text, i, options.etc)
         return nil, i -- in case the error method doesn't abort, return something sensible
      end

      i = skip_whitespace(text, i + 1)

      local new_val, new_i = grok_one(self, text, i, options)

      VALUE[key] = new_val

      --
      -- Expect now either '}' to end things, or a ',' to allow us to continue.
      --
      i = skip_whitespace(text, new_i)

      local c = text:sub(i,i)

      if c == '}' then
         return VALUE, i + 1
      end

      if text:sub(i, i) ~= ',' then
         self:onDecodeError("expected comma or '}'", text, i, options.etc)
         return nil, i -- in case the error method doesn't abort, return something sensible
      end

      i = skip_whitespace(text, i + 1)
   end

   self:onDecodeError("unclosed '{'", text, start, options.etc)
   return nil, start -- in case the error method doesn't abort, return something sensible
end

local function grok_array(self, text, start, options)
   if text:sub(start,start) ~= '[' then
      self:onDecodeError("expected '['", text, start, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   local i = skip_whitespace(text, start + 1) -- +1 to skip the '['
   local VALUE = self.strictTypes and self:newArray { } or { }
   if text:sub(i,i) == ']' then
      return VALUE, i + 1
   end

   local VALUE_INDEX = 1

   local text_len = text:len()
   while i <= text_len do
      local val, new_i = grok_one(self, text, i, options)

      -- can't table.insert(VALUE, val) here because it's a no-op if val is nil
      VALUE[VALUE_INDEX] = val
      VALUE_INDEX = VALUE_INDEX + 1

      i = skip_whitespace(text, new_i)

      --
      -- Expect now either ']' to end things, or a ',' to allow us to continue.
      --
      local c = text:sub(i,i)
      if c == ']' then
         return VALUE, i + 1
      end
      if text:sub(i, i) ~= ',' then
         self:onDecodeError("expected comma or ']'", text, i, options.etc)
         return nil, i -- in case the error method doesn't abort, return something sensible
      end
      i = skip_whitespace(text, i + 1)
   end
   self:onDecodeError("unclosed '['", text, start, options.etc)
   return nil, i -- in case the error method doesn't abort, return something sensible
end


grok_one = function(self, text, start, options)
   -- Skip any whitespace
   start = skip_whitespace(text, start)

   if start > text:len() then
      self:onDecodeError("unexpected end of string", text, nil, options.etc)
      return nil, start -- in case the error method doesn't abort, return something sensible
   end

   if text:find('^"', start) then
      return grok_string(self, text, start, options.etc)

   elseif text:find('^[-0123456789 ]', start) then
      return grok_number(self, text, start, options)

   elseif text:find('^%{', start) then
      return grok_object(self, text, start, options)

   elseif text:find('^%[', start) then
      return grok_array(self, text, start, options)

   elseif text:find('^true', start) then
      return true, start + 4

   elseif text:find('^false', start) then
      return false, start + 5

   elseif text:find('^null', start) then
      return options.null, start + 4

   else
      self:onDecodeError("can't parse JSON", text, start, options.etc)
      return nil, 1 -- in case the error method doesn't abort, return something sensible
   end
end

function OBJDEF:decode(text, etc, options)
   --
   -- If the user didn't pass in a table of decode options, make an empty one.
   --
   if type(options) ~= 'table' then
      options = {}
   end

   --
   -- If they passed in an 'etc' argument, stuff it into the options.
   -- (If not, any 'etc' field in the options they passed in remains to be used)
   --
   if etc ~= nil then
      options.etc = etc
   end


   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      local error_message = "JSON:decode must be called in method format"
      OBJDEF:onDecodeError(error_message, nil, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible
   end

   if text == nil then
      local error_message = "nil passed to JSON:decode()"
      self:onDecodeOfNilError(error_message, nil, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible

   elseif type(text) ~= 'string' then
      local error_message = "expected string argument to JSON:decode()"
      self:onDecodeError(string.format("%s, got %s", error_message, type(text)), nil, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible
   end

   if text:match('^%s*$') then
      -- an empty string is nothing, but not an error
      return nil
   end

   if text:match('^%s*<') then
      -- Can't be JSON... we'll assume it's HTML
      local error_message = "HTML passed to JSON:decode()"
      self:onDecodeOfHTMLError(error_message, text, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible
   end

   --
   -- Ensure that it's not UTF-32 or UTF-16.
   -- Those are perfectly valid encodings for JSON (as per RFC 4627 section 3),
   -- but this package can't handle them.
   --
   if text:sub(1,1):byte() == 0 or (text:len() >= 2 and text:sub(2,2):byte() == 0) then
      local error_message = "JSON package groks only UTF-8, sorry"
      self:onDecodeError(error_message, text, nil, options.etc)
      return nil, error_message -- in case the error method doesn't abort, return something sensible
   end

   --
   -- apply global options
   --
   if options.decodeNumbersAsObjects == nil then
      options.decodeNumbersAsObjects = self.decodeNumbersAsObjects
   end
   if options.decodeIntegerObjectificationLength == nil then
      options.decodeIntegerObjectificationLength = self.decodeIntegerObjectificationLength
   end
   if options.decodeDecimalObjectificationLength == nil then
      options.decodeDecimalObjectificationLength = self.decodeDecimalObjectificationLength
   end
   if options.decodeIntegerStringificationLength == nil then
      options.decodeIntegerStringificationLength = self.decodeIntegerStringificationLength
   end
   if options.decodeDecimalStringificationLength == nil then
      options.decodeDecimalStringificationLength = self.decodeDecimalStringificationLength
   end


   --
   -- Finally, go parse it
   --
   local success, value, next_i = pcall(grok_one, self, text, 1, options)

   if success then

      local error_message = nil
      if next_i ~= #text + 1 then
         -- something's left over after we parsed the first thing.... whitespace is allowed.
         next_i = skip_whitespace(text, next_i)

         -- if we have something left over now, it's trailing garbage
         if next_i ~= #text + 1 then
            value, error_message = self:onTrailingGarbage(text, next_i, value, options.etc)
         end
      end
      return value, error_message

   else

      -- If JSON:onDecodeError() didn't abort out of the pcall, we'll have received
      -- the error message here as "value", so pass it along as an assert.
      local error_message = value
      if self.assert then
         self.assert(false, error_message)
      else
         assert(false, error_message)
      end
      -- ...and if we're still here (because the assert didn't throw an error),
      -- return a nil and throw the error message on as a second arg
      return nil, error_message

   end
end

local function backslash_replacement_function(c)
   if c == "\n" then
      return "\\n"
   elseif c == "\r" then
      return "\\r"
   elseif c == "\t" then
      return "\\t"
   elseif c == "\b" then
      return "\\b"
   elseif c == "\f" then
      return "\\f"
   elseif c == '"' then
      return '\\"'
   elseif c == '\\' then
      return '\\\\'
   else
      return string.format("\\u%04x", c:byte())
   end
end

local chars_to_be_escaped_in_JSON_string
   = '['
   ..    '"'    -- class sub-pattern to match a double quote
   ..    '%\\'  -- class sub-pattern to match a backslash
   ..    '%z'   -- class sub-pattern to match a null
   ..    '\001' .. '-' .. '\031' -- class sub-pattern to match control characters
   .. ']'


local LINE_SEPARATOR_as_utf8      = unicode_codepoint_as_utf8(0x2028)
local PARAGRAPH_SEPARATOR_as_utf8 = unicode_codepoint_as_utf8(0x2029)
local function json_string_literal(value, options)
   local newval = value:gsub(chars_to_be_escaped_in_JSON_string, backslash_replacement_function)
   if options.stringsAreUtf8 then
      --
      -- This feels really ugly to just look into a string for the sequence of bytes that we know to be a particular utf8 character,
      -- but utf8 was designed purposefully to make this kind of thing possible. Still, feels dirty.
      -- I'd rather decode the byte stream into a character stream, but it's not technically needed so
      -- not technically worth it.
      --
      newval = newval:gsub(LINE_SEPARATOR_as_utf8, '\\u2028'):gsub(PARAGRAPH_SEPARATOR_as_utf8,'\\u2029')
   end
   return '"' .. newval .. '"'
end

local function object_or_array(self, T, etc)
   --
   -- We need to inspect all the keys... if there are any strings, we'll convert to a JSON
   -- object. If there are only numbers, it's a JSON array.
   --
   -- If we'll be converting to a JSON object, we'll want to sort the keys so that the
   -- end result is deterministic.
   --
   local string_keys = { }
   local number_keys = { }
   local number_keys_must_be_strings = false
   local maximum_number_key

   for key in pairs(T) do
      if type(key) == 'string' then
         table.insert(string_keys, key)
      elseif type(key) == 'number' then
         table.insert(number_keys, key)
         if key <= 0 or key >= math.huge then
            number_keys_must_be_strings = true
         elseif not maximum_number_key or key > maximum_number_key then
            maximum_number_key = key
         end
      elseif type(key) == 'boolean' then
         table.insert(string_keys, tostring(key))
      else
         self:onEncodeError("can't encode table with a key of type " .. type(key), etc)
      end
   end

   if #string_keys == 0 and not number_keys_must_be_strings then
      --
      -- An empty table, or a numeric-only array
      --
      if #number_keys > 0 then
         return nil, maximum_number_key -- an array
      elseif tostring(T) == "JSON array" then
         return nil
      elseif tostring(T) == "JSON object" then
         return { }
      else
         -- have to guess, so we'll pick array, since empty arrays are likely more common than empty objects
         return nil
      end
   end

   table.sort(string_keys)

   local map
   if #number_keys > 0 then
      --
      -- If we're here then we have either mixed string/number keys, or numbers inappropriate for a JSON array
      -- It's not ideal, but we'll turn the numbers into strings so that we can at least create a JSON object.
      --

      if self.noKeyConversion then
         self:onEncodeError("a table with both numeric and string keys could be an object or array; aborting", etc)
      end

      --
      -- Have to make a shallow copy of the source table so we can remap the numeric keys to be strings
      --
      map = { }
      for key, val in pairs(T) do
         map[key] = val
      end

      table.sort(number_keys)

      --
      -- Throw numeric keys in there as strings
      --
      for _, number_key in ipairs(number_keys) do
         local string_key = tostring(number_key)
         if map[string_key] == nil then
            table.insert(string_keys , string_key)
            map[string_key] = T[number_key]
         else
            self:onEncodeError("conflict converting table with mixed-type keys into a JSON object: key " .. number_key .. " exists both as a string and a number.", etc)
         end
      end
   end

   return string_keys, nil, map
end

--
-- Encode
--
-- 'options' is nil, or a table with possible keys:
--
--    pretty         -- If true, return a pretty-printed version.
--
--    indent         -- A string (usually of spaces) used to indent each nested level.
--
--    align_keys     -- If true, align all the keys when formatting a table. The result is uglier than one might at first imagine.
--                      Results are undefined if 'align_keys' is true but 'pretty' is not.
--
--    array_newline  -- If true, array elements are formatted each to their own line. The default is to all fall inline.
--                      Results are undefined if 'array_newline' is true but 'pretty' is not.
--
--    null           -- If this exists with a string value, table elements with this value are output as JSON null.
--
--    stringsAreUtf8 -- If true, consider Lua strings not as a sequence of bytes, but as a sequence of UTF-8 characters.
--                      (Currently, the only practical effect of setting this option is that Unicode LINE and PARAGRAPH
--                       separators, if found in a string, are encoded with a JSON escape instead of as raw UTF-8.
--                       The JSON is valid either way, but encoding this way, apparently, allows the resulting JSON
--                       to also be valid Java.)
--
--
local function encode_value(self, value, parents, etc, options, indent, for_key)

   --
   -- keys in a JSON object can never be null, so we don't even consider options.null when converting a key value
   --
   if value == nil or (not for_key and options and options.null and value == options.null) then
      return 'null'

   elseif type(value) == 'string' then
      return json_string_literal(value, options)

   elseif type(value) == 'number' then
      if value ~= value then
         --
         -- NaN (Not a Number).
         -- JSON has no NaN, so we have to fudge the best we can. This should really be a package option.
         --
         return "null"
      elseif value >= math.huge then
         --
         -- Positive infinity. JSON has no INF, so we have to fudge the best we can. This should
         -- really be a package option. Note: at least with some implementations, positive infinity
         -- is both ">= math.huge" and "<= -math.huge", which makes no sense but that's how it is.
         -- Negative infinity is properly "<= -math.huge". So, we must be sure to check the ">="
         -- case first.
         --
         return "1e+9999"
      elseif value <= -math.huge then
         --
         -- Negative infinity.
         -- JSON has no INF, so we have to fudge the best we can. This should really be a package option.
         --
         return "-1e+9999"
      else
         return tostring(value)
      end

   elseif type(value) == 'boolean' then
      return tostring(value)

   elseif type(value) ~= 'table' then

      if self.unsupportedTypeEncoder then
         local user_value, user_error = self:unsupportedTypeEncoder(value, parents, etc, options, indent, for_key)
         -- If the user's handler returns a string, use that. If it returns nil plus an error message, bail with that.
         -- If only nil returned, fall through to the default error handler.
         if type(user_value) == 'string' then
            return user_value
         elseif user_value ~= nil then
            self:onEncodeError("unsupportedTypeEncoder method returned a " .. type(user_value), etc)
         elseif user_error then
            self:onEncodeError(tostring(user_error), etc)
         end
      end

      self:onEncodeError("can't convert " .. type(value) .. " to JSON", etc)

   elseif getmetatable(value) == isNumber then
      return tostring(value)
   else
      --
      -- A table to be converted to either a JSON object or array.
      --
      local T = value

      if type(options) ~= 'table' then
         options = {}
      end
      if type(indent) ~= 'string' then
         indent = ""
      end

      if parents[T] then
         self:onEncodeError("table " .. tostring(T) .. " is a child of itself", etc)
      else
         parents[T] = true
      end

      local result_value

      local object_keys, maximum_number_key, map = object_or_array(self, T, etc)
      if maximum_number_key then
         --
         -- An array...
         --
         local key_indent
         if options.array_newline then
            key_indent = indent .. tostring(options.indent or "")
         else
            key_indent = indent
         end

         local ITEMS = { }
         for i = 1, maximum_number_key do
            table.insert(ITEMS, encode_value(self, T[i], parents, etc, options, key_indent))
         end

         if options.array_newline then
            result_value = "[\n" .. key_indent .. table.concat(ITEMS, ",\n" .. key_indent) .. "\n" .. indent .. "]"
         elseif options.pretty then
            result_value = "[ " .. table.concat(ITEMS, ", ") .. " ]"
         else
            result_value = "["  .. table.concat(ITEMS, ",")  .. "]"
         end

      elseif object_keys then
         --
         -- An object
         --
         local TT = map or T

         if options.pretty then

            local KEYS = { }
            local max_key_length = 0
            for _, key in ipairs(object_keys) do
               local encoded = encode_value(self, tostring(key), parents, etc, options, indent, true)
               if options.align_keys then
                  max_key_length = math.max(max_key_length, #encoded)
               end
               table.insert(KEYS, encoded)
            end
            local key_indent = indent .. tostring(options.indent or "")
            local subtable_indent = key_indent .. string.rep(" ", max_key_length) .. (options.align_keys and "  " or "")
            local FORMAT = "%s%" .. string.format("%d", max_key_length) .. "s: %s"

            local COMBINED_PARTS = { }
            for i, key in ipairs(object_keys) do
               local encoded_val = encode_value(self, TT[key], parents, etc, options, subtable_indent)
               table.insert(COMBINED_PARTS, string.format(FORMAT, key_indent, KEYS[i], encoded_val))
            end
            result_value = "{\n" .. table.concat(COMBINED_PARTS, ",\n") .. "\n" .. indent .. "}"

         else

            local PARTS = { }
            for _, key in ipairs(object_keys) do
               local encoded_val = encode_value(self, TT[key],       parents, etc, options, indent)
               local encoded_key = encode_value(self, tostring(key), parents, etc, options, indent, true)
               table.insert(PARTS, string.format("%s:%s", encoded_key, encoded_val))
            end
            result_value = "{" .. table.concat(PARTS, ",") .. "}"

         end
      else
         --
         -- An empty array/object... we'll treat it as an array, though it should really be an option
         --
         result_value = "[]"
      end

      parents[T] = false
      return result_value
   end
end

local function top_level_encode(self, value, etc, options)
   local val = encode_value(self, value, {}, etc, options)
   if val == nil then
      --PRIVATE("may need to revert to the previous public verison if I can't figure out what the guy wanted")
      return val
   else
      return val
   end
end

function OBJDEF:encode(value, etc, options)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onEncodeError("JSON:encode must be called in method format", etc)
   end

   --
   -- If the user didn't pass in a table of decode options, make an empty one.
   --
   if type(options) ~= 'table' then
      options = {}
   end

   return top_level_encode(self, value, etc, options)
end

function OBJDEF:encode_pretty(value, etc, options)
   if type(self) ~= 'table' or self.__index ~= OBJDEF then
      OBJDEF:onEncodeError("JSON:encode_pretty must be called in method format", etc)
   end

   --
   -- If the user didn't pass in a table of decode options, use the default pretty ones
   --
   if type(options) ~= 'table' then
      options = default_pretty_options
   end

   return top_level_encode(self, value, etc, options)
end

function OBJDEF.__tostring()
   return "JSON encode/decode package"
end

OBJDEF.__index = OBJDEF

function OBJDEF:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   return setmetatable(new, OBJDEF)
end
--
-- Version history:
--
--   20170927.26   Use option.null in decoding as well. Thanks to Max Sindwani for the bump, and sorry to Oliver Hitz
--                 whose first mention of it four years ago was completely missed by me.
--
--   20170823.25   Added support for JSON:unsupportedTypeEncoder().
--                 Thanks to Chronos Phaenon Eosphoros (https://github.com/cpeosphoros) for the idea.
--
--   20170819.24   Added support for boolean keys in tables.
--
--   20170416.23   Added the "array_newline" formatting option suggested by yurenchen (http://www.yurenchen.com/)
--
--   20161128.22   Added:
--                   JSON:isString()
--                   JSON:isNumber()
--                   JSON:decodeIntegerObjectificationLength
--                   JSON:decodeDecimalObjectificationLength
--
--   20161109.21   Oops, had a small boo-boo in the previous update.
--
--   20161103.20   Used to silently ignore trailing garbage when decoding. Now fails via JSON:onTrailingGarbage()
--                 http://seriot.ch/parsing_json.php
--
--                 Built-in error message about "expected comma or ']'" had mistakenly referred to '['
--
--                 Updated the built-in error reporting to refer to bytes rather than characters.
--
--                 The decode() method no longer assumes that error handlers abort.
--
--                 Made the VERSION string a string instead of a number
--

--   20160916.19   Fixed the isNumber.__index assignment (thanks to Jack Taylor)
--   
--   20160730.18   Added JSON:forceString() and JSON:forceNumber()
--
--   20160728.17   Added concatenation to the metatable for JSON:asNumber()
--
--   20160709.16   Could crash if not passed an options table (thanks jarno heikkinen <jarnoh@capturemonkey.com>).
--
--                 Made JSON:asNumber() a bit more resilient to being passed the results of itself.
--
--   20160526.15   Added the ability to easily encode null values in JSON, via the new "null" encoding option.
--                 (Thanks to Adam B for bringing up the issue.)
--
--                 Added some support for very large numbers and precise floats via
--                    JSON.decodeNumbersAsObjects
--                    JSON.decodeIntegerStringificationLength
--                    JSON.decodeDecimalStringificationLength
--
--                 Added the "stringsAreUtf8" encoding option. (Hat tip to http://lua-users.org/wiki/JsonModules )
--
--   20141223.14   The encode_pretty() routine produced fine results for small datasets, but isn't really
--                 appropriate for anything large, so with help from Alex Aulbach I've made the encode routines
--                 more flexible, and changed the default encode_pretty() to be more generally useful.
--
--                 Added a third 'options' argument to the encode() and encode_pretty() routines, to control
--                 how the encoding takes place.
--
--                 Updated docs to add assert() call to the loadfile() line, just as good practice so that
--                 if there is a problem loading JSON.lua, the appropriate error message will percolate up.
--
--   20140920.13   Put back (in a way that doesn't cause warnings about unused variables) the author string,
--                 so that the source of the package, and its version number, are visible in compiled copies.
--
--   20140911.12   Minor lua cleanup.
--                 Fixed internal reference to 'JSON.noKeyConversion' to reference 'self' instead of 'JSON'.
--                 (Thanks to SmugMug's David Parry for these.)
--
--   20140418.11   JSON nulls embedded within an array were being ignored, such that
--                     ["1",null,null,null,null,null,"seven"],
--                 would return
--                     {1,"seven"}
--                 It's now fixed to properly return
--                     {1, nil, nil, nil, nil, nil, "seven"}
--                 Thanks to "haddock" for catching the error.
--
--   20140116.10   The user's JSON.assert() wasn't always being used. Thanks to "blue" for the heads up.
--
--   20131118.9    Update for Lua 5.3... it seems that tostring(2/1) produces "2.0" instead of "2",
--                 and this caused some problems.
--
--   20131031.8    Unified the code for encode() and encode_pretty(); they had been stupidly separate,
--                 and had of course diverged (encode_pretty didn't get the fixes that encode got, so
--                 sometimes produced incorrect results; thanks to Mattie for the heads up).
--
--                 Handle encoding tables with non-positive numeric keys (unlikely, but possible).
--
--                 If a table has both numeric and string keys, or its numeric keys are inappropriate
--                 (such as being non-positive or infinite), the numeric keys are turned into
--                 string keys appropriate for a JSON object. So, as before,
--                         JSON:encode({ "one", "two", "three" })
--                 produces the array
--                         ["one","two","three"]
--                 but now something with mixed key types like
--                         JSON:encode({ "one", "two", "three", SOMESTRING = "some string" }))
--                 instead of throwing an error produces an object:
--                         {"1":"one","2":"two","3":"three","SOMESTRING":"some string"}
--
--                 To maintain the prior throw-an-error semantics, set
--                      JSON.noKeyConversion = true
--                 
--   20131004.7    Release under a Creative Commons CC-BY license, which I should have done from day one, sorry.
--
--   20130120.6    Comment update: added a link to the specific page on my blog where this code can
--                 be found, so that folks who come across the code outside of my blog can find updates
--                 more easily.
--
--   20111207.5    Added support for the 'etc' arguments, for better error reporting.
--
--   20110731.4    More feedback from David Kolf on how to make the tests for Nan/Infinity system independent.
--
--   20110730.3    Incorporated feedback from David Kolf at http://lua-users.org/wiki/JsonModules:
--
--                   * When encoding lua for JSON, Sparse numeric arrays are now handled by
--                     spitting out full arrays, such that
--                        JSON:encode({"one", "two", [10] = "ten"})
--                     returns
--                        ["one","two",null,null,null,null,null,null,null,"ten"]
--
--                     In 20100810.2 and earlier, only up to the first non-null value would have been retained.
--
--                   * When encoding lua for JSON, numeric value NaN gets spit out as null, and infinity as "1+e9999".
--                     Version 20100810.2 and earlier created invalid JSON in both cases.
--
--                   * Unicode surrogate pairs are now detected when decoding JSON.
--
--   20100810.2    added some checking to ensure that an invalid Unicode character couldn't leak in to the UTF-8 encoding
--
--   20100731.1    initial public release
--
--end json decoder
return OBJDEF:new()
end 
JSON=JSONfunction()

---end of json, eofjson

_G.grabkey=nil;

--- template
-- {"file/gametitle",maxplayers}
--coming soon, gear types, server alive time, auto shutdown
-- game id, max players, "gameid", nsfw
local games={

{"[conSub] Derby.rbxl",24},
{"[conSub] Infomaniac.rbxl",24},
{"[conSub] Jac0b.rbxl",24},
{"[conSub] legokid.rbxl",24},
{"[conSub] Lollolland.rbxl",24},
{"[conSub] Porkyminch.rbxl",24},
{"[conSub] TypicalName.rbxl",24},
{"[conSub] Nickoakz.rbxl",24},


{"[Nickoakz] Unfair Minigames.rbxl",120,nil,nil,"Nickoakz"}, --apbs game

{"[NoobyNub] Ultimate Build Elite.rbxl",24},

{"[Noble] FightPlace v3.rbxl",24},
{"[Noble] MazeFPS v3.rbxl",24},
{"[Noble] MurderMystery v3.rbxl",24},
{"[Noble] MurderMystery v20.rbxl",75},
{"[Noble] Playground v3.rbxl",24},
{"[Noble] Prison v3.rbxl",24},
{"[Noble] RPPlace v3.rbxl",24},

{"[demo] ControlPoints.rbxl",10},

{"[Figurized] 2012 Dream Hangout.rbxl",24},

{"[pixelpower] Finobe City.rbxl",50,nil,nil,"pixelpower"}, --apbs game

{"[d4ve] BaseWars.rbxl",24},
{"[dotard] Just Chat v4.rbxl",24},

{"[actualaudino] GROW & RAISE A BRICK.rbxl",24},
{"[ApolloBlue] 2011 Skate Down a City.rbxl",24},
{"[chadwarden] Destroy The Towers.rbxl",24},
{"[coke] Catch that Man.rbxl",24},
{"[coke] Robloxpolice's vehicles.rbxl",24},
{"[coke] Six Flags Great Robloxia.rbxl",24},
{"[coke] the many ways to kill spongebob.rbxl",24},
{"[denmincartdimonds] Finobe Starter Place.rbxl",24},
{"[Derby] 2008 Ultimate Build.rbxl",24},
{"[dotard] Stuck in a Box.rbxl",24},
{"[dotart] Stuck in a Box v2.rbxl",24},
{"[FizzyFuz] 2006 City.rbxl",24},
{"[FizzyFuz] 5324 Tank Terrain Course.rbxl",24},
{"[FizzyFuz] Crossroads Winter.rbxl",24},
{"[FizzyFuz] Graphictoria HQ.rbxl",24},
{"[FizzyFuz] Hide and Seek lando64000 for older versions.rbxl",24},
{"[FizzyFuz] Hide and Seek lando64000.rbxl",24},
{"[FizzyFuz] Iron Cafe.rbxl",24},
{"[Flareguy] 2007 The Front Lines.rbxl",24},
{"[Flory] Destroy the Wall.rbxl",24},
{"[Flory] Train Crashing.rbxl",24},
{"[genericusername1231] Murder in Old ROBLOX v1.10.rbxl",24},
{"[Groovy] Build to survive the zombies 2012.rbxl",24},
{"[ItsGamerGr] Nuke the Whales.rbxl",24},
{"[kittenchilly] 2012 Galleons v5.2.rbxl",24},
{"[Lampara] 2013 Control Points.rbxl",24},
{"[Lampara] 2013 Escape the Flood Obby.rbxl",24},
{"[Lampara] CATCH THAT MAN.rbxl",24},
{"[Lampara] Classic Prison.rbxl",24},
{"[Lampara] Fencing.rbxl",24},
{"[lowelfesteeme] A Time Back To 07 v2.75.rbxl",24},
{"[lykakspars] memcity.rbxl",24},
{"[MrPikachu] 2012 SCP Containment Breach.rbxl",24},
{"[MrPikachu] Bowling Alley.rbxl",24},
{"[MrTeakettle] Dodge the Teapots.rbxl",24},
{"[muramasu] 2007 Brickbattle.rbxl",24},
{"[NikeBoy] Chaos Tower.rbxl",24},
{"[NikeBoy] Christmas vs Holloween.rbxl",24},
{"[NikeBoy] City Under Fire Ltd. Server Network.rbxl",24},
{"[NikeBoy] The Great Wall Of China Palace.rbxl",24},
{"[NikeBoy] Travelers Tale.rbxl",24},
{"[PacMania67] Glass Houses.rbxl",24},
{"[plausibly] 2009 Bl0x B0x.rbxl",24},
{"[plausibly] Super Mario 64 for older versions.rbxl",24},
{"[playtitanium] Terrain Freebuild.rbxl",24},
{"[porkyminch] After the Flash Sandstorm.rbxl",24},
{"[rocket] Scorching Caverns.rbxl",24},
{"[Ruin] Datines Reason 4 Life The Swamp.rbxl",24},
{"[Ruin] Ruin Cafe v12.rbxl",24},
{"[socialistenweeallvis] 2011 Communist Disaster Survival.rbxl",24},
{"[Stormer] Stormers Big World.rbxl",24},
{"[Super163] Train2.rbxl",24},
{"[superstarxalien] Boys vs Girls 2 Treehouse Rumble.rbxl",24},
{"[superstarxalien] King of the Hill v1.5.rbxl",24},
{"[tonyleechicken1] Net Neutrality Wars.rbxl",24},
{"[Trout] 2006 DoomSpire and Towers.rbxl",24},
{"[TypicalName] A Small Town.rbxl",24},
{"[TypicalName] Bricksville v2.rbxl",24},
{"[TypicalName] Bricksville v3.rbxl",24},
{"[TypicalName] Bricksville v4.rbxl",24},
{"[TypicalName] Bricksville v5.rbxl",24},
{"[TypicalName] Bricksville v6.rbxl",24},
{"[TypicalName] Bricksville v7.rbxl",24},
{"[umadman] Loli Cafe After the flash Deep Winter.rbxl",24},
{"[You] King Of The Hill V1.5.rbxl",24},
{"[You] SandboxUnpacked.rbxl",24},


{"[nickoakz] starterMAPdev.rbxl",50},

{"[josh] Build to Survive the Creepers.rbxl",24},
{"[josh] Build to Survive the Creeper.rbxl",24},
{"[josh] Survive the Plane Crash.rbxl",24},

{"[ROBL0X] After The Flash Sandstorm [RP].rbxl",24}, --robl0x user

{"NickoCasino.rbxl",75},

{"[FMPv1] 2005 Pirate Ship.rbxl",24},
{"[FMPv1] 2005 Start Place.rbxl",24},
{"[FMPv1] 2006 Crossroads.rbxl",24},
{"[FMPv1] 2006 DoomSpire and Towers.rbxl",24},
{"[FMPv1] 2006 King of the Hill.rbxl",24},
{"[FMPv1] 2006 Lava Rush.rbxl",24},
{"[FMPv1] 2006 Santas Winter Stronghold.rbxl",24},
{"[FMPv1] 2006 Stairway to Heaven.rbxl",24},
{"[FMPv1] 2006 Yorick's Resting Place.rbxl",24},
{"[FMPv1] 2006 Yoricks Resting Place.rbxl",24},
{"[FMPv1] 2007 bboy.rbxl",24},
{"[FMPv1] 2007 Chaos Canyon.rbxl",24},
{"[FMPv1] 2007 Climb the Tallest Ladder in Roblox.rbxl",24},
{"[FMPv1] 2007 Climb The Tallest Ladder In The Roblox World.rbxl",24},
{"[FMPv1] 2007 Community Construction.rbxl",24},
{"[FMPv1] 2007 Destroy The Giant Marios.rbxl",24},
{"[FMPv1] 2007 Dodge the Teapots of doom.rbxl",24},
{"[FMPv1] 2007 Elemental Lake.rbxl",24},
{"[FMPv1] 2007 Emerald Forest.rbxl",24},
{"[FMPv1] 2007 extreme four corners.rbxl",24},
{"[FMPv1] 2007 Glass Houses.rbxl",24},
{"[FMPv1] 2007 Haunted Mansion.rbxl",24},
{"[FMPv1] 2007 leo's place.rbxl",24},
{"[FMPv1] 2007 OH NOES! The moon is falling!.rbxl",24},
{"[FMPv1] 2007 Pinball Wizards!.rbxl",24},
{"[FMPv1] 2007 PONG.rbxl",24},
{"[FMPv1] 2007 ROBLOX Bowling.rbxl",24},
{"[FMPv1] 2007 Rocket  Arena.rbxl",24},
{"[FMPv1] 2007 Script Builder.rbxl",24},
{"[FMPv1] 2007 Sunset Plain.rbxl",24},
{"[FMPv1] 2007 Sword Fight on the Heights I.rbxl",24},
{"[FMPv1] 2007 Sword Fight on the Heights II.rbxl",24},
{"[FMPv1] 2007 Sword Fight on the Heights III.rbxl",24},
{"[FMPv1] 2007 Timmy and the Killbots.rbxl",24},
{"[FMPv1] 2008 Bread Factory Tycoon.rbxl",24},
{"[FMPv1] 2008 build your city.rbxl",24},
{"[FMPv1] 2008 canyon.rbxl",24},
{"[FMPv1] 2008 cart ride into the epic duck.rbxl",24},
{"[FMPv1] 2008 Chess Tournament.rbxl",24},
{"[FMPv1] 2008 Dead Space.rbxl",24},
{"[FMPv1] 2008 Enjoy A Sinking Ships last voyage.rbxl",24},
{"[FMPv1] 2008 escape school.rbxl",24},
{"[FMPv1] 2008 Frozen Peak.rbxl",24},
{"[FMPv1] 2008 Heli-Wars Desert Attack.rbxl",24},
{"[FMPv1] 2008 How Long Can You Survive Minigames.rbxl",24},
{"[FMPv1] 2008 How Long Can You Survive.rbxl",24},
{"[FMPv1] 2008 minigames5.rbxl",24},
{"[FMPv1] 2008 Nuke the Whales!.rbxl",24},
{"[FMPv1] 2008 Nuke the Whales.rbxl",24},
{"[FMPv1] 2008 Obstakle course!!!.rbxl",24},
{"[FMPv1] 2008 Olympics.rbxl",24},
{"[FMPv1] 2008 paint ball war.rbxl",24},
{"[FMPv1] 2008 Pinball Wizards!.rbxl",24},
{"[FMPv1] 2008 Pirate Army HQ.rbxl",24},
{"[FMPv1] 2008 Plane Crash.rbxl",24},
{"[FMPv1] 2008 ROBLOX Bowling.rbxl",24},
{"[FMPv1] 2008 ROBLOX HQ.rbxl",24},
{"[FMPv1] 2008 RockPaperScissors.rbxl",24},
{"[FMPv1] 2008 ROtris.rbxl",24},
{"[FMPv1] 2008 RoWar PlanetProtection.rbxl",24},
{"[FMPv1] 2008 Space I.rbxl",24},
{"[FMPv1] 2008 SURVIVE THE GALACTIC STORM.rbxl",24},
{"[FMPv1] 2008 Sword Fight on The Heights IV.rbxl",24},
--{"[FMPv1] 2008 Telamon's Big World (eventually remade into 2011 starter).rbxl",24},
{"[FMPv1] 2008 The Undead Coming v1.2.rbxl",24},
{"[FMPv1] 2008 ThrillVille.rbxl",24},
{"[FMPv1] 2008 TimeReversalUpgraded.rbxl",24},
{"[FMPv1] 2008 Transformers Obby 1.rbxl",24},
{"[FMPv1] 2008 Transformers Obby 2.rbxl",24},
{"[FMPv1] 2008 Ultimate Build.rbxl",24},
{"[FMPv1] 2008 Ultimate Paintball.rbxl",24},
{"[FMPv1] 2008 WaffleRunners.rbxl",24},
{"[FMPv1] 2008 War Place.rbxl",24},
{"[FMPv1] 2008 Welcome to ROBLOX.rbxl",24},
{"[FMPv1] 2008 Wizard Wars.rbxl",24},
{"[FMPv1] 2008-2010 UnderGroundWars.rbxl",24},
{"[FMPv1] 2009 Deep Digz 2-D.rbxl",24},
{"[FMPv1] 2009 Desert Warzone Classic.rbxl",24},
{"[FMPv1] 2009 Fall Down the Stairs (XMAS VERSION).rbxl",24},
{"[FMPv1] 2009 Futuristic Dog-Fight.rbxl",24},
{"[FMPv1] 2009 Glass Houses 2.rbxl",24},
{"[FMPv1] 2009 Hide and Seek (Lance7).rbxl",24},
{"[FMPv1] 2009 HIGH SPEED TRAIN!.rbxl",24},
{"[FMPv1] 2009 NoobTrap.rbxl",24},
{"[FMPv1] 2009 pacman ctf.rbxl",24},
{"[FMPv1] 2009 Paint tycoon.rbxl",24},
{"[FMPv1] 2009 Survive the End of Robloxia.rbxl",24},
{"[FMPv1] 2009 Survive the Spheres ORIGINAL.rbxl",24},
{"[FMPv1] 2009 Tropical Obby.rbxl",24},
{"[FMPv1] 2009 Twoshues Hide n' Seek.rbxl",24},
{"[FMPv1] 2010 Base Wars.rbxl",24},
{"[FMPv1] 2010 Calc.rbxl",24},
{"[FMPv1] 2010 Crossroads.rbxl",24},
{"[FMPv1] 2010 Disaster Hotel.rbxl",24},
{"[FMPv1] 2010 Doomspires.rbxl",24},
{"[FMPv1] 2010 Flood Escape.rbxl",24},
{"[FMPv1] 2010 Freeze tag.rbxl",24},
{"[FMPv1] 2010 Frost Nova.rbxl",24},
{"[FMPv1] 2010 Happy Home (Telamons Big World).rbxl",24},
{"[FMPv1] 2010 Haunted Hotel.rbxl",24},
{"[FMPv1] 2010 Lando's Apartment.rbxl",24},
{"[FMPv1] 2010 McDonalds Vs KFC.rbxl",24},
{"[FMPv1] 2010 Nintendo Minigames.rbxl",24},
{"[FMPv1] 2010 Noob Test Obby.rbxl",24},
{"[FMPv1] 2010 R.U.N.rbxl",24},
{"[FMPv1] 2010 Reason 2 Die.rbxl",24},
{"[FMPv1] 2010 Ride a rocket to the space station and moon!.rbxl",24},
{"[FMPv1] 2010 Ro-Pictionary.rbxl",24},
{"[FMPv1] 2010 ROBLOX Arcade.rbxl",24},
{"[FMPv1] 2010 ROBLOX Mall Tycoon.rbxl",24},
{"[FMPv1] 2010 Rocket Builder.rbxl",24},
{"[FMPv1] 2010 Script Builder.rbxl",24},
{"[FMPv1] 2010 Town of Robloxia.rbxl",24},
{"[FMPv1] 2010 Work at a Pizza Place.rbxl",24},
{"[FMPv1] 2010 Zombie Tower.rbxl",24},
{"[FMPv1] 2010NoobTrap2.rbxl",24},
{"[FMPv1] 2011 Cart Ride into an Epic Duck!.rbxl",24},
{"[FMPv1] 2011 Domo Island Obby Tycoon (2).rbxl",24},
{"[FMPv1] 2011 Domo Island Obby Tycoon.rbxl",24},
{"[FMPv1] 2011 Natural disasters survival.rbxl",24},
{"[FMPv1] 2011 R.U.N.rbxl",24},
{"[FMPv1] 2011 Ride a rocket to the ISS or MOON!.rbxl",24},
{"[FMPv1] 2011 Survive the Disasters.rbxl",24},
{"[FMPv1] 2011 The Mega Fun and Colorful Obby!.rbxl",24},
{"[FMPv1] 2012 Mario Kart ROBLOX Dash.rbxl",24},
{"[FMPv1] 2012 Pokemon Elemental Brawlers.rbxl",24},
{"[FMPv1] 2013 Get Crushed by a Speeding Wall!.rbxl",24},
{"[FMPv1] 2015 Urban Terror Brickbattle.rbxl",24},
{"[FMPv1] 2016 Lego's Zombie Survival.rbxl",24},
{"[FMPv1] 2016 Nobelium Town V2.rbxl",24},
{"[FMPv1] 2016 Old Cars.rbxl",24},
{"[FMPv1] 2016 Public Graffiti.rbxl",24},
{"[FMPv1] 2017 Hot Knief Fight.rbxl",24},
{"[FMPv1] 2017 Lego's Obby.rbxl",24},
{"[FMPv1] 2017 Lego's Plane Wars.rbxl",24},
{"[FMPv1] 2017 Lego's Race War Simulator.rbxl",24},
{"[FMPv1] 2017 Lego's Tower Climb 2.rbxl",24},
{"[FMPv1] UberObby.rbxl",24},
{"[FMPv1] UnderwaterObby.rbxl",24},

{"[muramasu] deathrun",24},

{"[winsupermario-pm] Archway Hangout.rbxl",24},
{"[winsupermario-pm] Basic Ultimate Build.rbxl",24},
{"[winsupermario-pm] Big Slide.rbxl",24},
{"[winsupermario-pm] Crashing Cars.rbxl",24},
{"[winsupermario-pm] Destroy the Buildings.rbxl",24},
{"[winsupermario-pm] Destroy the TALL Doomspire.rbxl",24},
{"[winsupermario-pm] My house.rbxl",24},
{"[winsupermario-pm] Neighborhood.rbxl",24},
{"[winsupermario-pm] New WinCo HQ.rbxl",24},
{"[winsupermario-pm] Old Cars v2.rbxl",24},
{"[winsupermario-pm] Old Cars v3.rbxl",24},
{"[winsupermario-pm] RBLXDev Hangout Area.rbxl",24},
{"[winsupermario-pm] Rocket Jeep Racing.rbxl",24},
{"[winsupermario-pm] Rocket to Space.rbxl",24},
{"[winsupermario-pm] Win's House Modified.rbxl",24},
{"[winsupermario-pm] Win's House RBLXDev Server.rbxl",24},
{"[winsupermario-pm] Win's Junkyard.rbxl",24},
{"[winsupermario-pm] WinCo HQ.rbxl",24},
{"[winsupermario-pm] Winsupermario HQ.rbxl",24},
{"[winsupermario-pm] WSM's Place.rbxl",24},
{"[winsupermario] 2005 Bridge It! #2.rbxl",24},
{"[winsupermario] 2005 Bridge It!.rbxl",24},
{"[winsupermario] 2006 Crossroads (2).rbxl",24},
{"[winsupermario] 2006 Crossroads baseplate with studs.rbxl",24},
{"[winsupermario] 2006 Crossroads fixed Hideout with common tools and no sword.rbxl",24},
{"[winsupermario] 2006 Crossroads fixed Hideout with common tools.rbxl",24},
{"[winsupermario] 2006 Crossroads fixed Hideout.rbxl",24},
{"[winsupermario] 2006 Crossroads Pizzaboyzmvp version.rbxl",24},
{"[winsupermario] 2006 Crossroads with early weapons.rbxl",24},
{"[winsupermario] 2006 Crossroads with epic and tools.rbxl",24},
{"[winsupermario] 2006 Crossroads with fixed Freebricks.rbxl",24},
{"[winsupermario] 2006 Crossroads with Freebricks reduced.rbxl",24},
{"[winsupermario] 2006 Crossroads with Freebricks.rbxl",24},
{"[winsupermario] 2006 Crossroads with Mjolnir.rbxl",24},
{"[winsupermario] 2006 Crossroads with modern weapons.rbxl",24},
{"[winsupermario] 2006 Crossroads with Old Bomb.rbxl",24},
{"[winsupermario] 2006 Crossroads.rbxl",24},
{"[winsupermario] 2006 Doll Place.rbxl",24},
{"[winsupermario] 2006 DoomSpire and Towers 2.rbxl",24},
{"[winsupermario] 2006 DoomSpire and Towers with taller tower fixed more.rbxl",24},
{"[winsupermario] 2006 DoomSpire and Towers with taller tower.rbxl",24},
{"[winsupermario] 2006 DoomSpire and Towers.rbxl",24},
{"[winsupermario] 2006 Lava Rush.rbxl",24},
{"[winsupermario] 2006 Maze of Doom.rbxl",24},
{"[winsupermario] 2006 Mountain with 2006 weapons.rbxl",24},
{"[winsupermario] 2006 Mountain.rbxl",24},
{"[winsupermario] 2006 Roblox HQ.rbxl",24},
{"[winsupermario] 2006 Stairway to Heaven.rbxl",24},
{"[winsupermario] 2006 Starter Place.rbxl",24},
{"[winsupermario] 2006 The Original Idea of Crossroads from screenshot.rbxl",24},
{"[winsupermario] 2006 The Original Idea of Crossroads.rbxl",24},
{"[winsupermario] 2006 Ultimate Paintball.rbxl",24},
{"[winsupermario] 2006 Weird Place.rbxl",24},
{"[winsupermario] 2006_Starter.rbxl",24},
{"[winsupermario] 2006_Starter_revised.rbxl",24},
{"[winsupermario] 2007 Bastion of Horsey.rbxl",24},
{"[winsupermario] 2007 BlOX MART.rbxl",24},
{"[winsupermario] 2007 Bread Factory.rbxl",24},
{"[winsupermario] 2007 Builderman Suite.rbxl",24},
{"[winsupermario] 2007 Castle Warfare.rbxl",24},
{"[winsupermario] 2007 Chaos Canyon with old Bomb.rbxl",24},
{"[winsupermario] 2007 Chaos Canyon with original weapons.rbxl",24},
{"[winsupermario] 2007 Chaos Canyon.rbxl",24},
{"[winsupermario] 2007 Community Construction Site 2.rbxl",24},
{"[winsupermario] 2007 COmmunity Construction.rbxl",24},
{"[winsupermario] 2007 Crossroads in 2006.rbxl",24},
{"[winsupermario] 2007 Crossroads with 2006 weapons and better Time Bomb.rbxl",24},
{"[winsupermario] 2007 Crossroads with 2006 weapons.rbxl",24},
{"[winsupermario] 2007 Crossroads.rbxl",24},
{"[winsupermario] 2007 Cube World.rbxl",24},
{"[winsupermario] 2007 Dodge the Teapots!.rbxl",24},
{"[winsupermario] 2007 DOmino Rally.rbxl",24},
{"[winsupermario] 2007 Doomspire 4 tower battle.rbxl",24},
{"[winsupermario] 2007 DoomSpire from World of roblox.rbxl",24},
{"[winsupermario] 2007 DoomSpire.rbxl",24},
{"[winsupermario] 2007 Earlu Crossroads with 2006 weapons and two temples.rbxl",24},
{"[winsupermario] 2007 Earlu Crossroads with 2006 weapons.rbxl",24},
{"[winsupermario] 2007 Elemental Lake.rbxl",24},
{"[winsupermario] 2007 Emerald Forest.rbxl",24},
{"[winsupermario] 2007 Four Towers Bridge Battle.rbxl",24},
{"[winsupermario] 2007 FWM.rbxl",24},
{"[winsupermario] 2007 Get Crushed by a Speeding Wall!.rbxl",24},
{"[winsupermario] 2007 Glass Houses.rbxl",24},
{"[winsupermario] 2007 Grey City with normal weapons.rbxl",24},
{"[winsupermario] 2007 Grey City.rbxl",24},
{"[winsupermario] 2007 Guitar Gods.rbxl",24},
{"[winsupermario] 2007 Happy Home.rbxl",24},
{"[winsupermario] 2007 Haunted Mansion.rbxl",24},
{"[winsupermario] 2007 LIMAL MESSAGE.rbxl",24},
{"[winsupermario] 2007 Mission to the Moon.rbxl",24},
{"[winsupermario] 2007 Nevermoors BLight fixed.rbxl",24},
{"[winsupermario] 2007 Nevermoors BLight.rbxl",24},
{"[winsupermario] 2007 Ninja vs. Samurai.rbxl",24},
{"[winsupermario] 2007 Normal Grey City with LASER and old weapons Might fixed wall.rbxl",24},
{"[winsupermario] 2007 Normal Grey City with LASER and old weapons.rbxl",24},
{"[winsupermario] 2007 Normal Grey City with LASER.rbxl",24},
{"[winsupermario] 2007 Normal Grey City.rbxl",24},
{"[winsupermario] 2007 Nuke the Whales!.rbxl",24},
{"[winsupermario] 2007 OH NOES! The moon is falling! Moon up up and away.rbxl",24},
{"[winsupermario] 2007 OH NOES! The moon is falling!.rbxl",24},
{"[winsupermario] 2007 PilotLuke's Cloud City with 2006 tools and new rocket and physics.rbxl",24},
{"[winsupermario] 2007 PilotLuke's Cloud City with 2006 tools and new rocket.rbxl",24},
{"[winsupermario] 2007 PilotLuke's Cloud City with 2006 tools.rbxl",24},
{"[winsupermario] 2007 PilotLuke's Cloud City with new Rocket.rbxl",24},
{"[winsupermario] 2007 PilotLuke's Cloud City.rbxl",24},
{"[winsupermario] 2007 Pinball Wizards! with more balls lol.rbxl",24},
{"[winsupermario] 2007 Pinball Wizards! with more balls.rbxl",24},
{"[winsupermario] 2007 Pinball Wizards!.rbxl",24},
{"[winsupermario] 2007 Pirate Ship with original weapons.rbxl",24},
{"[winsupermario] 2007 Pirate Ship.rbxl",24},
{"[winsupermario] 2007 Rail System.rbxl",24},
{"[winsupermario] 2007 ROBLOX Bowling.rbxl",24},
{"[winsupermario] 2007 ROBLOX HQ with Mjolnir.rbxl",24},
{"[winsupermario] 2007 ROBLOX HQ with normal weapons.rbxl",24},
{"[winsupermario] 2007 ROBLOX HQ with Old Bomb and Old Rocket and no sword and no paintball gun.rbxl",24},
{"[winsupermario] 2007 ROBLOX HQ with Old Bomb and Old Rocket.rbxl",24},
{"[winsupermario] 2007 ROBLOX HQ with Old Bomb.rbxl",24},
{"[winsupermario] 2007 ROBLOX HQ.rbxl",24},
{"[winsupermario] 2007 ROBLOXPit4op54y.rbxl",24},
{"[winsupermario] 2007 Rocket  Arena.rbxl",24},
{"[winsupermario] 2007 Rocket Fight Advanced with baseplate.rbxl",24},
{"[winsupermario] 2007 Rocket Fight Advanced.rbxl",24},
{"[winsupermario] 2007 Santas Winter Stronghold.rbxl",24},
{"[winsupermario] 2007 Script Builder.rbxl",24},
{"[winsupermario] 2007 Spawn Elevator.rbxl",24},
{"[winsupermario] 2007 Starting Brickbattle Map.rbxl",24},
{"[winsupermario] 2007 Strange Place.rbxl",24},
{"[winsupermario] 2007 Sunset Plain with 2006 weapons.rbxl",24},
{"[winsupermario] 2007 Sunset Plain.rbxl",24},
{"[winsupermario] 2007 Sword Fight on the Heights I.rbxl",24},
{"[winsupermario] 2007 Sword Fight on the Heights II.rbxl",24},
{"[winsupermario] 2007 Sword Fight on the Heights III.rbxl",24},
{"[winsupermario] 2007 Tabula Rasa.rbxl",24},
{"[winsupermario] 2007 TEAPOT ALERT.rbxl",24},
{"[winsupermario] 2007 The daleks.rbxl",24},
{"[winsupermario] 2007 The DoomSpire.rbxl",24},
{"[winsupermario] 2007 The Vanishing Point.rbxl",24},
{"[winsupermario] 2007 Trampoline Sword Fight.rbxl",24},
{"[winsupermario] 2007 Unknown Place.rbxl",24},
{"[winsupermario] 2007 Wishing Castle.rbxl",24},
{"[winsupermario] 2007 YRP.rbxl",24},
{"[winsupermario] 2007_Get_Crushed_by_a_Speeding_Wall.rbxl",24},
{"[winsupermario] 2007_Ladder.rbxl",24},
{"[winsupermario] 2008 A Bridge Too Far fixed almost done.rbxl",24},
{"[winsupermario] 2008 A Bridge Too Far.rbxl",24},
{"[winsupermario] 2008 Bread Factory Tycoon.rbxl",24},
{"[winsupermario] 2008 Brickbattle Medieval Mayhem.rbxl",24},
{"[winsupermario] 2008 Castle Destruction.rbxl",24},
{"[winsupermario] 2008 Chaos Canyon.rbxl",24},
{"[winsupermario] 2008 Chess Tournament.rbxl",24},
{"[winsupermario] 2008 Crossroads with 2008 tools.rbxl",24},
{"[winsupermario] 2008 Crossroads without custom skybox.rbxl",24},
{"[winsupermario] 2008 Crossroads.rbxl",24},
{"[winsupermario] 2008 Defaultio Bowling.rbxl",24},
{"[winsupermario] 2008 Dodge the Teapots!.rbxl",24},
{"[winsupermario] 2008 Doomspire 3 tower battle.rbxl",24},
{"[winsupermario] 2008 Fixed Rube.rbxl",24},
{"[winsupermario] 2008 FREE COOL STUFF - DEMOS.rbxl",24},
{"[winsupermario] 2008 Fun with Mjoinir with sulaster.rbxl",24},
{"[winsupermario] 2008 Fun with Mjoinir.rbxl",24},
{"[winsupermario] 2008 Get Crushed by a Speeding Wall!.rbxl",24},
{"[winsupermario] 2008 Glass Houses with original weapons.rbxl",24},
{"[winsupermario] 2008 Glass Houses.rbxl",24},
{"[winsupermario] 2008 Gold Digger HACKED.rbxl",24},
{"[winsupermario] 2008 Gold Digger.rbxl",24},
{"[winsupermario] 2008 Grow a Slime.rbxl",24},
{"[winsupermario] 2008 Happy Home with better starter sign.rbxl",24},
{"[winsupermario] 2008 Happy Home.rbxl",24},
{"[winsupermario] 2008 Martian Invasion.rbxl",24},
{"[winsupermario] 2008 Pinball Wizards!.rbxl",24},
{"[winsupermario] 2008 ROBLOX HQ from Explore ROBLOX.rbxl",24},
{"[winsupermario] 2008 ROBLOX HQ with Mjolnir.rbxl",24},
{"[winsupermario] 2008 ROBLOX HQ.rbxl",24},
{"[winsupermario] 2008 Rocket  Arena.rbxl",24},
{"[winsupermario] 2008 Rube Goldburg with glass cup.rbxl",24},
{"[winsupermario] 2008 Rube Goldburg.rbxl",24},
{"[winsupermario] 2008 Shirts and Pants breaking place.rbxl",24},
{"[winsupermario] 2008 Starting Brickbattle Map.rbxl",24},
{"[winsupermario] 2008 SURVIVE THE GALACTIC STORM.rbxl",24},
{"[winsupermario] 2008 Sword Fight on the Heights IV.rbxl",24},
{"[winsupermario] 2008 Telamon's Big World with extended path and more cars and regens.rbxl",24},
{"[winsupermario] 2008 Telamon's Big World with extended path and more cars.rbxl",24},
{"[winsupermario] 2008 Telamon's Big World with extended path.rbxl",24},
{"[winsupermario] 2008 Telamon's Big World.rbxl",24},
{"[winsupermario] 2008 The Barren Ice Sheets of Frostmoor.rbxl",24},
{"[winsupermario] 2008 Timmy and the Killbots.rbxl",24},
{"[winsupermario] 2008 Uber-Mini-Golf.rbxl",24},
{"[winsupermario] 2008 Welcome to ROBLOX.rbxl",24},
{"[winsupermario] 2008 Wizard Wars.rbxl",24},
{"[winsupermario] 2008 zombie survival 2013.rbxl",24},
{"[winsupermario] 2008_Chess_Tournament.rbxl",24},
{"[winsupermario] 2008_Get_Crushed_by_a_Speeding_Wall.rbxl",24},
{"[winsupermario] 2008_Grow_a_Slime.rbxl",24},
{"[winsupermario] 2008_Olympics.rbxl",24},
{"[winsupermario] 2008_ROtris.rbxl",24},
{"[winsupermario] 2008_Space_I.rbxl",24},
{"[winsupermario] 2009 Build your Own Game.rbxl",24},
{"[winsupermario] 2009 Crossroads in the wintertime.rbxl",24},
{"[winsupermario] 2009 Desert Warzone Classic.rbxl",24},
{"[winsupermario] 2009 Exploding Buildings.rbxl",24},
{"[winsupermario] 2009 Fall down the stairs.rbxl",24},
{"[winsupermario] 2009 FWM.rbxl",24},
{"[winsupermario] 2009 Glass Houses 2.rbxl",24},
{"[winsupermario] 2009 Happy Home server v2.rbxl",24},
{"[winsupermario] 2009 Happy Home.rbxl",24},
{"[winsupermario] 2009 Lol.rbxl",24},
{"[winsupermario] 2009 SlingyShoty Valley.rbxl",24},
{"[winsupermario] 2009 Tabula Rasa.rbxl",24},
{"[winsupermario] 2009-ish Happy Home with even more freebricks.rbxl",24},
{"[winsupermario] 2009-ish Happy Home with more freebricks.rbxl",24},
{"[winsupermario] 2009-ish Happy Home.rbxl",24},
{"[winsupermario] 2009_Futuristic_Dog-Fight.rbxl",24},
{"[winsupermario] 2010 Crazy Car Wars.rbxl",24},
{"[winsupermario] 2010 Freeze tag.rbxl",24},
--{"[winsupermario] 2010 Happy Home (USE WITH 2010 ROBLOX STUDIO client) with more hopperbins and more cars.rbxl",24},
--{"[winsupermario] 2010 Happy Home (USE WITH 2010 ROBLOX STUDIO client) with more hopperbins.rbxl",24},
--{"[winsupermario] 2010 Happy Home (USE WITH 2010 ROBLOX STUDIO client).rbxl",24},
{"[winsupermario] 2010 Happy Home ORIGINAL.rbxl",24},
{"[winsupermario] 2010 Universe.rbxl",24},
{"[winsupermario] 2010destructionderby.rbxl",24},
{"[winsupermario] 2010happyhome.rbxl",24},
{"[winsupermario] 2012 Happy Home.rbxl",24},
{"[winsupermario] 2013  FUll Doll Place.rbxl",24},
{"[winsupermario] 2013 CLIMB.rbxl",24},
{"[winsupermario] 2013 COmmunity Construction.rbxl",24},
{"[winsupermario] 2013 Domino Test.rbxl",24},
{"[winsupermario] 2013 Get Crushed by a Speeding Wall! Old.rbxl",24},
{"[winsupermario] 2013 Grey City 2.rbxl",24},
{"[winsupermario] 2013 Hug the Teapots!.rbxl",24},
{"[winsupermario] 2013 Lovebots.rbxl",24},
{"[winsupermario] 2013 NUKE THE TEAPOTS.rbxl",24},
{"[winsupermario] 2013 PilotLuke's Cloud City.rbxl",24},
{"[winsupermario] 2013 Pinball Game 2.rbxl",24},
{"[winsupermario] 2013 Pinball Game.rbxl",24},
{"[winsupermario] 2013 Recreation of Stairway to Heaven.rbxl",24},
{"[winsupermario] 2013 Recreation of Thrillville.rbxl",24},
{"[winsupermario] 2013 ROBLOX HQ.rbxl",24},
{"[winsupermario] 2013 Rocket Place.rbxl",24},
{"[winsupermario] 2013 Strange Place.rbxl",24},
{"[winsupermario] 2013 Tabula Rasa.rbxl",24},
{"[winsupermario] 2013 Telamon's Village.rbxl",24},
{"[winsupermario] 2013 Trampoline Testing 2.rbxl",24},
{"[winsupermario] 2013 Trampoline Testing.rbxl",24},
{"[winsupermario] 2013 Winter Rocket  Arena.rbxl",24},
{"[winsupermario] 2014 Blown Up Happy Home.rbxl",24},
{"[winsupermario] 2014 Boring Happy Home.rbxl",24},
{"[winsupermario] 2014 Cube WOOOOORRLLRLRLD.rbxl",24},
{"[winsupermario] 2014 Lol Happy Home.rbxl",24},
{"[winsupermario] 2014 Morph test place.rbxl",24},
{"[winsupermario] 2014 Woah Happy Home.rbxl",24},
{"[winsupermario] A Pirates Life.rbxl",24},
{"[winsupermario] air simulator.rbxl",24},
{"[winsupermario] arcade.rbxl",24},
{"[winsupermario] Arkitect's office building.rbxl",24},
{"[winsupermario] Armored Patrol.rbxl",24},
{"[winsupermario] Armored Ship Battle.rbxl",24},
{"[winsupermario] Autumn.rbxl",24},
{"[winsupermario] Balance.rbxl",24},
{"[winsupermario] Base for sale I.rbxl",24},
{"[winsupermario] Base Wars.rbxl",24},
{"[winsupermario] Basketball.rbxl",24},
{"[winsupermario] Battle-For-Supremacy-Tycoon-III.rbxl",24},
{"[winsupermario] Be crushed by speeding wall.rbxl",24},
{"[winsupermario] Beachside Parlour.rbxl",24},
{"[winsupermario] Bedroom Build UPDATE.rbxl",24},
{"[winsupermario] bedroom2.rbxl",24},
{"[winsupermario] billiland reverse time.rbxl",24},
{"[winsupermario] Biplane_Dogfight.rbxl",24},
{"[winsupermario] Blazing man v3.1.8.rbxl",24},
{"[winsupermario] Blockcraft.rbxl",24},
{"[winsupermario] Bounty Hunter.rbxl",24},
{"[winsupermario] Bowling.rbxl",24},
{"[winsupermario] Build a Raft and Sail TO YOUR DOOOOOM! .rbxl",24},
{"[winsupermario] Build to Survive the Zombies.rbxl",24},
{"[winsupermario] Build2SurviveZombies.rbxl",24},
{"[winsupermario] Builderman Suite.rbxl",24},
{"[winsupermario] buildermanhotel.rbxl",24},
{"[winsupermario] Building Room.rbxl",24},
{"[winsupermario] Build_a_Raft_and_Sail_TO_YOUR_DOOOOOM_.rbxl",24},
{"[winsupermario] burial.rbxl",24},
{"[winsupermario] Burned.rbxl",24},
{"[winsupermario] Canoe Without A Paddle.rbxl",24},
{"[winsupermario] car crash simulator.rbxl",24},
{"[winsupermario] cars v2.rbxl",24},
{"[winsupermario] cart ride into.rbxl",24},
{"[winsupermario] Chaos Canyon.rbxl",24},
{"[winsupermario] Chaos Tower.rbxl",24},
{"[winsupermario] Choices - GollyGreg.rbxl",24},
{"[winsupermario] chrisdude's Place.rbxl",24},
{"[winsupermario] Christmas vs holloween.rbxl",24},
{"[winsupermario] City Under Fire Ltd. Server Network.rbxl",24},
{"[winsupermario] ClassicBlox Solo Map.rbxl",24},
{"[winsupermario] Climb a giant tower to winners.rbxl",24},
{"[winsupermario] climb big tower 2.rbxl",24},
{"[winsupermario] Climb_The_Tallest_Ladder_In_The_Roblox_World.rbxl",24},
{"[winsupermario] Cloud City.rbxl",24},
{"[winsupermario] coaster creator.rbxl",24},
{"[winsupermario] Cobalt Legion Capital City.rbxl",24},
{"[winsupermario] Cold Stone Homestore.rbxl",24},
{"[winsupermario] Combat League BETA.rbxl",24},
{"[winsupermario] Community construction.rbxl",24},
{"[winsupermario] communityconstruct2.rbxl",24},
{"[winsupermario] Contamination.rbxl",24},
{"[winsupermario] Cops and Robbers.rbxl",24},
{"[winsupermario] Cops vs. Robbers Classic.rbxl",24},
{"[winsupermario] Creed.rbxl",24},
{"[winsupermario] Crossroads 2.rbxl",24},
{"[winsupermario] Crossroads with bricks.rbxl",24},
{"[winsupermario] Crossroads with bricks2.rbxl",24},
{"[winsupermario] Crossroads with bricks3.rbxl",24},
{"[winsupermario] Crossroads with unanchored Trampoline.rbxl",24},
{"[winsupermario] Crossroads-RBLXDEV.rbxl",24},
{"[winsupermario] Crossroads.rbxl",24},
{"[winsupermario] CustomBrickBattle.rbxl",24},
{"[winsupermario] DeadSpace.rbxl",24},
{"[winsupermario] Deathrun (2).rbxl",24},
{"[winsupermario] Deathrun.rbxl",24},
{"[winsupermario] deathrunold.rbxl",24},
{"[winsupermario] desert castle wars default place recreation.rbxl",24},
{"[winsupermario] Desert.rbxl",24},
{"[winsupermario] destroy giant freemodels.rbxl",24},
{"[winsupermario] destroy rblx hq.rbxl",24},
{"[winsupermario] destroy the giant marios 2008.rbxl",24},
{"[winsupermario] Destroy the TALL Doomspire.rbxl",24},
{"[winsupermario] destroy the tower.rbxl",24},
{"[winsupermario] Destruction Derby Fanta Edition.rbxl",24},
{"[winsupermario] Destruction Derby Original xml.rbxl",24},
{"[winsupermario] Disaster Hotel 2011.rbxl",24},
{"[winsupermario] Disaster Hotel.rbxl",24},
{"[winsupermario] Dodge the Teapots.rbxl",24},
{"[winsupermario] dodgeball - alexnewtron.rbxl",24},
{"[winsupermario] DodgeBall.rbxl",24},
{"[winsupermario] Doll Place.rbxl",24},
{"[winsupermario] Domo Island Tycoon.rbxl",24},
{"[winsupermario] DoomSpire Tower Battle.rbxl",24},
{"[winsupermario] doomspires.rbxl",24},
{"[winsupermario] Dots by Brandonhare.rbxl",24},
{"[winsupermario] Dragon Ball Z Online Adventures..rbxl",24},
{"[winsupermario] Dragon Ball Z Online Adventures.rbxl",24},
{"[winsupermario] Driveblox Unlimited for Rbxpri.rbxl",24},
{"[winsupermario] Driveblox Unlimited.rbxl",24},
{"[winsupermario] DUCK - clockwork.rbxl",24},
{"[winsupermario] EaglesCastle.rbxl",24},
{"[winsupermario] Eat Or Make The Food For Mc.Donalds Or PizzaHut!.rbxl",24},
{"[winsupermario] escapeschool.rbxl",24},
{"[winsupermario] Escape_the_Desert_Obby.rbxl",24},
{"[winsupermario] Fairy Tail Revelations ail Revelations ventures.rbxl",24},
{"[winsupermario] Fake Crossroads.rbxl",24},
{"[winsupermario] Fall Down Stairs CHRISTMAS VERSION.rbxl",24},
{"[winsupermario] Falling Crossroads.rbxl",24},
{"[winsupermario] Falling Crossroads2.rbxl",24},
{"[winsupermario] Fall_Down_Stairs_CHRISTMAS_VERSION.rbxl",24},
{"[winsupermario] fear games.rbxl",24},
{"[winsupermario] fearhq.rbxl",24},
{"[winsupermario] Fencing - Stolen.rbxl",24},
{"[winsupermario] Fencing.rbxl",24},
{"[winsupermario] Fenrier place.rbxl",24},
{"[winsupermario] First Crossroads.rbxl",24},
{"[winsupermario] Fixed Work at a Pizza Place v1.01.rbxl",24},
{"[winsupermario] flamethrowertesting.rbxl",24},
{"[winsupermario] flesk_studio.rbxl",24},
{"[winsupermario] Forest.rbxl",24},
{"[winsupermario] Fort For Sale 8.rbxl",24},
{"[winsupermario] Fort wolf 2.rbxl",24},
{"[winsupermario] FPS Patrol.rbxl",24},
{"[winsupermario] Friend-Only Starting BrickBattle Map.rbxl",24},
{"[winsupermario] fun with mjolnir.rbxl",24},
{"[winsupermario] Galleons52.rbxl",24},
{"[winsupermario] Garnold Survival Apocalypse.rbxl",24},
{"[winsupermario] generic obby.rbxl",24},
{"[winsupermario] Get Crushed by a Speeding Wall!.rbxl",24},
{"[winsupermario] GGR-Capital-City-Coruscant.rbxl",24},
{"[winsupermario] giant rocket arena.rbxl",24},
{"[winsupermario] giant rocket arena2.rbxl",24},
{"[winsupermario] Glass Houses.rbxl",24},
{"[winsupermario] Godzilla's House.rbxl",24},
{"[winsupermario] Gravity chamber.rbxl",24},
{"[winsupermario] Grey City (2).rbxl",24},
{"[winsupermario] Grey City.rbxl",24},
{"[winsupermario] gt_construct.rbxl",24},
{"[winsupermario] happy home in robloxia 2009 SNOW.rbxl",24},
{"[winsupermario] Happy home in Robloxia 2010.rbxl",24},
{"[winsupermario] Happy Home in Robloxia 2012.rbxl",24},
{"[winsupermario] Happy Home In Robloxia, Dev.rbxl",24},
{"[winsupermario] happyhome.rbxl",24},
{"[winsupermario] Haunted Mansion.rbxl",24},
{"[winsupermario] Helghast-Legion-Autarches-Palace.rbxl",24},
{"[winsupermario] Helghast-Legion-Fort-Rebirth.rbxl",24},
{"[winsupermario] heli wars.rbxl",24},
{"[winsupermario] Hide and seek - Lance7.rbxl",24},
{"[winsupermario] High Speed Train.rbxl",24},
{"[winsupermario] Holewall.rbxl",24},
{"[winsupermario] Immortals - NEMESlS - Alakazard.rbxl",24},
{"[winsupermario] Improved Fort Archway.rbxl",24},
{"[winsupermario] iron cafe.rbxl",24},
{"[winsupermario] Jail break - StickMasterLuke.rbxl",24},
{"[winsupermario] Jeopardy.rbxl",24},
{"[winsupermario] jepordy - alexnewtron.rbxl",24},
{"[winsupermario] jk323's Place Restored.rbxl",24},
{"[winsupermario] killing_machine_91's Place.rbxl",24},
{"[winsupermario] Kingofhill.rbxl",24},
{"[winsupermario] kool_killer.rbxl",24},
{"[winsupermario] Laser Tanks 2.0.rbxl",24},
{"[winsupermario] LaserTag1.rbxl",24},
{"[winsupermario] LaserTag2.rbxl",24},
{"[winsupermario] Last 1 Alive.rbxl",24},
{"[winsupermario] Last1Alive.rbxl",24},
{"[winsupermario] legossummergay.rbxl",24},
{"[winsupermario] Lighting Intervals - Dignity.rbxl",24},
{"[winsupermario] Live in 5 star resort.rbxl",24},
{"[winsupermario] LukeJacobuilder's Plaza.rbxl",24},
{"[winsupermario] Lumber Tycoon.rbxl",24},
{"[winsupermario] Mac Workin's Place Refurbished.rbxl",24},
{"[winsupermario] mace's luxury tower.rbxl",24},
{"[winsupermario] making something don't know yet.rbxl",24},
{"[winsupermario] Mario Kart.rbxl",24},
{"[winsupermario] Mc Donalds Vs KFC.rbxl",24},
{"[winsupermario] Medieval Mountains.rbxl",24},
{"[winsupermario] Memory Lane Hangout.rbxl",24},
{"[winsupermario] metagros.rbxl",24},
{"[winsupermario] Miked_labs.rbxl",24},
{"[winsupermario] MinigamesNintendo.rbxl",24},
{"[winsupermario] MinigameWorld.rbxl",24},
{"[winsupermario] mission to the moon.rbxl",24},
{"[winsupermario] Mod-Venture.rbxl",24},
{"[winsupermario] MovieMaker3D.rbxl",24},
{"[winsupermario] My_private_hut_2008.rbxl",24},
{"[winsupermario] Natural Disaster Survival.rbxl",24},
{"[winsupermario] naturaldisastersurvival.rbxl",24},
{"[winsupermario] NaturalDisasterSurvivalWORKING.rbxl",24},
{"[winsupermario] Nexx Real Life Company Tycoon 2011.rbxl",24},
{"[winsupermario] nice place.rbxl",24},
{"[winsupermario] NoobTrapOne.rbxl",24},
{"[winsupermario] NoobTrapTwo.rbxl",24},
{"[winsupermario] Nuke The Whales! -RLBXDEV.rbxl",24},
{"[winsupermario] Nuke the Whales.rbxl",24},
{"[winsupermario] NxtGenGunFight.rbxl",24},
{"[winsupermario] Oasis - Samacado.rbxl",24},
{"[winsupermario] obby1.rbxl",24},
{"[winsupermario] obby2.rbxl",24},
{"[winsupermario] Old Models Original.rbxl",24},
{"[winsupermario] old_cars_2_2011.rbxl",24},
{"[winsupermario] omaha 2008 v2.rbxl",24},
{"[winsupermario] Original ThrillVille.rbxl",24},
{"[winsupermario] owocasino.rbxl",24},
{"[winsupermario] Paintball.rbxl",24},
{"[winsupermario] Parody - GollyGreg.rbxl",24},
{"[winsupermario] Perilous Skys - crazyman32.rbxl",24},
{"[winsupermario] PerilousSkies.rbxl",24},
{"[winsupermario] Perlious Skies.rbxl",24},
{"[winsupermario] Person299 Minigames.rbxl",24},
{"[winsupermario] Personal Server Map.rbxl",24},
{"[winsupermario] PFCity.rbxl",24},
{"[winsupermario] Phoenixs_Aqua_Beach_Party_Contest_Entry.rbxl",24},
{"[winsupermario] Pinball Wizards.rbxl",24},
{"[winsupermario] pinewood hq.rbxl",24},
{"[winsupermario] Pirate Army HQ.rbxl",24},
{"[winsupermario] Pirate Ship Fight.rbxl",24},
{"[winsupermario] Pixels_Summer_Map.rbxl",24},
{"[winsupermario] Place1.rbxl",24},
{"[winsupermario] Place10.rbxl",24},
{"[winsupermario] Place11.rbxl",24},
{"[winsupermario] Place12.rbxl",24},
{"[winsupermario] Place13.rbxl",24},
{"[winsupermario] Place14.rbxl",24},
{"[winsupermario] Place15.rbxl",24},
{"[winsupermario] Place16.rbxl",24},
{"[winsupermario] Place17.rbxl",24},
{"[winsupermario] Place18.rbxl",24},
{"[winsupermario] Place19.rbxl",24},
{"[winsupermario] Place2.rbxl",24},
{"[winsupermario] Place20.rbxl",24},
{"[winsupermario] Place212.rbxl",24},
{"[winsupermario] Place22.rbxl",24},
{"[winsupermario] Place23.rbxl",24},
{"[winsupermario] Place24.rbxl",24},
{"[winsupermario] Place25.rbxl",24},
{"[winsupermario] Place26.rbxl",24},
{"[winsupermario] Place27.rbxl",24},
{"[winsupermario] Place28.rbxl",24},
{"[winsupermario] Place29.rbxl",24},
{"[winsupermario] Place3.rbxl",24},
{"[winsupermario] Place30.rbxl",24},
{"[winsupermario] Place4.rbxl",24},
{"[winsupermario] Place5.rbxl",24},
{"[winsupermario] Place6.rbxl",24},
{"[winsupermario] Place7.rbxl",24},
{"[winsupermario] Place8.rbxl",24},
{"[winsupermario] Place9.rbxl",24},
{"[winsupermario] Plane Crash.rbxl",24},
{"[winsupermario] PlaneFlying2.rbxl",24},
{"[winsupermario] PONG.rbxl",24},
{"[winsupermario] publicgraffiti.rbxl",24},
{"[winsupermario] public_grafitti_2016.rbxl",24},
{"[winsupermario] R.U.N.rbxl",24},
{"[winsupermario] r2dclassic (hopefully fixed).rbxl",24},
{"[winsupermario] Raise a dancing banana - MARIOSTAR6464.rbxl",24},
{"[winsupermario] RBLXDEVHQ.rbxl",24},
{"[winsupermario] realgroundbase.rbxl",24},
{"[winsupermario] Reason 2 Die.rbxl",24},
{"[winsupermario] Reason2DieV2.rbxl",24},
{"[winsupermario] Red Base.rbxl",24},
{"[winsupermario] RetroFloodEscape.rbxl",24},
{"[winsupermario] Revised Bowling.rbxl",24},
{"[winsupermario] Revolver Tournament.rbxl",24},
{"[winsupermario] RFL.rbxl",24},
{"[winsupermario] ride a box.rbxl",24},
{"[winsupermario] Ride a rocket to the ISS or the moon.rbxl",24},
{"[winsupermario] ROBLOX Bowling.rbxl",24},
{"[winsupermario] Roblox Building - ROBLOX.rbxl",24},
{"[winsupermario] Roblox City.rbxl",24},
{"[winsupermario] ROBLOX Derby.rbxl",24},
{"[winsupermario] roblox evil 5.rbxl",24},
{"[winsupermario] ROBLOX evil game idk - stolen.rbxl",24},
{"[winsupermario] Roblox HQ.rbxl",24},
{"[winsupermario] Robloxanators HQ.rbxl",24},
{"[winsupermario] RobloxPolice's Unreleased Vehicles.rbxl",24},
{"[winsupermario] ROBLOXShootout2.rbxl",24},
{"[winsupermario] RobloxTeamMiniGames.rbxl",24},
{"[winsupermario] ROBLOX_Bowling_Alley.rbxl",24},
{"[winsupermario] Rocket Arena.rbxl",24},
{"[winsupermario] Rocket Car Rally.rbxl",24},
{"[winsupermario] room_environment.rbxl",24},
{"[winsupermario] room_environment_blue.rbxl",24},
{"[winsupermario] ropictionary - alexnewtron.rbxl",24},
{"[winsupermario] run.rbxl",24},
{"[winsupermario] S-H-O-C-K-Arena-3-Tycoon.rbxl",24},
{"[winsupermario] Samurai_Pagoda_Battle.rbxl",24},
{"[winsupermario] Sand Police's Sky World.rbxl",24},
{"[winsupermario] Sandbox - REDALERT2.rbxl",24},
{"[winsupermario] Sandbox BC version.rbxl",24},
{"[winsupermario] Santas Winter Stronghold.rbxl",24},
{"[winsupermario] Sattalite - clockwork.rbxl",24},
{"[winsupermario] SCR Base.rbxl",24},
{"[winsupermario] Scrambling Eggs.rbxl",24},
{"[winsupermario] SFOTHIV.rbxl",24},
{"[winsupermario] Shrine of the Fallen Hero - Minish.rbxl",24},
{"[winsupermario] SimplesTest_2.rbxl",24},
{"[winsupermario] simple_swordfight.rbxl",24},
{"[winsupermario] Simpson tycoon.rbxl",24},
{"[winsupermario] slip'a'slide'n'die.rbxl",24},
{"[winsupermario] Solar Star Cafe.rbxl",24},
{"[winsupermario] some strange map idk what the fuck it is.rbxl",24},
{"[winsupermario] SP - GollyGreg.rbxl",24},
{"[winsupermario] Space I.rbxl",24},
{"[winsupermario] Space Ships.rbxl",24},
{"[winsupermario] Space Shuttle.rbxl",24},
{"[winsupermario] SpeedySeat Chair Racing.rbxl",24},
{"[winsupermario] Stairway to Heaven.rbxl",24},
{"[winsupermario] StamperToolTest's place.rbxl",24},
{"[winsupermario] Starter Place.rbxl",24},
{"[winsupermario] StoneSanctuary.rbxl",24},
{"[winsupermario] Stranded - crazyman32.rbxl",24},
{"[winsupermario] Strange Place.rbxl",24},
{"[winsupermario] succopolis blooper.rbxl",24},
{"[winsupermario] succopolis christmas.rbxl",24},
{"[winsupermario] succopolis downhill.rbxl",24},
{"[winsupermario] succopolis.rbxl",24},
{"[winsupermario] Summer Fun by Legodude50.rbxl",24},
{"[winsupermario] Summer_contest_aka_project_finobeee.rbxl",24},
{"[winsupermario] Sunset Plain.rbxl",24},
{"[winsupermario] Super Robloxian Smash!.rbxl",24},
{"[winsupermario] Survive The 90 Disasters.rbxl",24},
{"[winsupermario] Survive The 90 Disasters2.rbxl",24},
{"[winsupermario] Survive The 90 Disasters_001.rbxl",24},
{"[winsupermario] Survive the Disasters (Random).rbxl",24},
{"[winsupermario] Survive the disasters V7 [Whimee].rbxl",24},
{"[winsupermario] Survive The DrakkoBloxxers.rbxl",24},
{"[winsupermario] Survive the Glitch Train 2008.rbxl",24},
{"[winsupermario] Survive the Glitch Train.rbxl",24},
{"[winsupermario] Sword Fighting Tournament.rbxl",24},
{"[winsupermario] Sword Fights On The Heights-RBLXDEV.rbxl",24},
{"[winsupermario] Tabula Rasa.rbxl",24},
{"[winsupermario] Techy.rbxl",24},
{"[winsupermario] TestBase.rbxl",24},
{"[winsupermario] The Basement OLD.rbxl",24},
{"[winsupermario] The Big Slide's Place.rbxl",24},
{"[winsupermario] The Carnival's Place.rbxl",24},
{"[winsupermario] THE CITY!!!!!!!.rbxl",24},
{"[winsupermario] The complex.rbxl",24},
{"[winsupermario] The Great Wall Of China Palace.rbxl",24},
{"[winsupermario] The Infection.rbxl",24},
{"[winsupermario] The Legente Airship.rbxl",24},
{"[winsupermario] The Lords of Ranges Cape.rbxl",24},
{"[winsupermario] The Many Ways to Kill SpongeBob.rbxl",24},
{"[winsupermario] The-Imperium-of-Man-Recruitment-Center.rbxl",24},
{"[winsupermario] The-Imperium-of-Man-Training-Academy.rbxl",24},
{"[winsupermario] TheGamer101.rbxl",24},
{"[winsupermario] TheGamer101s place 10-22-2011.rbxl",24},
{"[winsupermario] TheLittleMen.rbxl",24},
{"[winsupermario] TheUndergroundWar.rbxl",24},
{"[winsupermario] this_old_house_map.rbxl",24},
{"[winsupermario] ThrillVille.rbxl",24},
{"[winsupermario] Torture Chamber! Created by Stealth Pilot.rbxl",24},
{"[winsupermario] TowerDefence.rbxl",24},
{"[winsupermario] Train2.rbxl",24},
{"[winsupermario] Traveler's Tale.rbxl",24},
{"[winsupermario] Tropical Obby.rbxl",24},
{"[winsupermario] Turkey Hunt 2011 - ROBLOX.rbxl",24},
{"[winsupermario] Two Player War Tycoon.rbxl",24},
{"[winsupermario] UberObby.rbxl",24},
{"[winsupermario] Ultimate Build.rbxl",24},
{"[winsupermario] Ultimate Community Construction.rbxl",24},
{"[winsupermario] ultimate DEPLOY.rbxl",24},
{"[winsupermario] Ultimate Lazer Tag.rbxl",24},
{"[winsupermario] Ultimate Paintball Fighting.rbxl",24},
{"[winsupermario] Ultimate Paintball.rbxl",24},
{"[winsupermario] UnderGroundWars - Stolen.rbxl",24},
{"[winsupermario] UnderGroundWars.rbxl",24},
{"[winsupermario] UnderwaterObby.rbxl",24},
{"[winsupermario] Updated Mann Vs. Machine.rbxl",24},
{"[winsupermario] Urban terror.rbxl",24},
{"[winsupermario] Urban Warfare.rbxl",24},
{"[winsupermario] Vault.rbxl",24},
{"[winsupermario] Vhetration Tag.rbxl",24},
{"[winsupermario] Virde Cova - Stolen.rbxl",24},
{"[winsupermario] VirtualPaintball.rbxl",24},
{"[winsupermario] WarZone.rbxl",24},
{"[winsupermario] watch a ship sink.rbxl",24},
{"[winsupermario] Weird Place.rbxl",24},
{"[winsupermario] Welcome To Roblox Building.rbxl",24},
{"[winsupermario] Welcome to roblox.rbxl",24},
{"[winsupermario] Welcome to the town of robloxia - 1dev2.rbxl",24},
{"[winsupermario] Welcome to the Town of Robloxia REAL REAL REAL.rbxl",24},
{"[winsupermario] wheel of fortune - alexnewtron.rbxl",24},
{"[winsupermario] who killed dantdm.rbxl",24},
{"[winsupermario] WIJ Training facility skywards.rbxl",24},
{"[winsupermario] Winter rocket arena.rbxl",24},
{"[winsupermario] Work At a Pizza Place!.rbxl",24},
{"[winsupermario] Work At A Pizza Place.rbxl",24},
{"[winsupermario] WorkAtAPizzaPlace!.rbxl",24},
{"[winsupermario] Work_At_the_Krusty_Krabs_or_the_Chum_Bucket.rbxl",24},
{"[winsupermario] Yoricksrestingplace.rbxl",24},
{"[winsupermario] Z-E-T-A-Online-RPG.rbxl",24},
{"[winsupermario] Zombes.rbxl",24},
{"[winsupermario] Zombie Defence II.rbxl",24},
{"[winsupermario] Zombie Defence III.rbxl",24},
{"[winsupermario] zombie halloween 2010 game.rbxl",24},



{"[Thinking] Ultimate Build EX.rbxl",24},

{"[d_ayum] Ultimate Build.rbxl",24},

{"[lse] A Time Back to 2007.rbxl",24},
{"[lse] A Time Back to 2007 v2.rbxl",24},

{"[Ruin] 2006 Crossroads.rbxl",24},
{"[Ruin] 2006 DoomSpire and Towers.rbxl",24},
{"[Ruin] 2006 King of the Hill.rbxl",24},
{"[Ruin] 2006 Lava Rush.rbxl",24},
{"[Ruin] 2006 Santas Winter Stronghold.rbxl",24},
-- {"[Ruin] 2006 Stairway to Heaven.rbxl",24},
{"[Ruin] 2006 Yorick's Resting Place.rbxl",24},
{"[Ruin] 2006 Yoricks Resting Place.rbxl",24},
{"[Ruin] 2006_The_Big_Slide.rbxl",24},
{"[Ruin] 2006_The_Big_Slide_v1.11.rbxl",24},
{"[Ruin] 2007 bboy.rbxl",24},
{"[Ruin] 2007 Bread Factory.rbxl",24},
{"[Ruin] 2007 Builderman Suite.rbxl",24},
{"[Ruin] 2007 Chaos Canyon.rbxl",24},
{"[Ruin] 2007 Climb the Tallest Ladder in Roblox.rbxl",24},
{"[Ruin] 2007 Climb The Tallest Ladder In The Roblox World.rbxl",24},
{"[Ruin] 2007 Community Construction.rbxl",24},
{"[Ruin] 2007 Destroy The Giant Marios.rbxl",24},
{"[Ruin] 2007 Dodge the Teapots of doom.rbxl",24},
{"[Ruin] 2007 Elemental Lake.rbxl",24},
{"[Ruin] 2007 Emerald Forest.rbxl",24},
{"[Ruin] 2007 extreme four corners.rbxl",24},
{"[Ruin] 2007 Glass Houses.rbxl",24},
{"[Ruin] 2007 Haunted Mansion.rbxl",24},
{"[Ruin] 2007 leo's place.rbxl",24},
{"[Ruin] 2007 Mission to the Moon.rbxl",24},
{"[Ruin] 2007 Ninja vs. Samurai.rbxl",24},
{"[Ruin] 2007 Normal Grey City with LASER and old weapons Might fixed wall.rbxl",24},
{"[Ruin] 2007 Nuke the Whales!.rbxl",24},
{"[Ruin] 2007 OH NOES! The moon is falling!.rbxl",24},
{"[Ruin] 2007 Pinball Wizards!.rbxl",24},
{"[Ruin] 2007 PONG.rbxl",24},
{"[Ruin] 2007 ROBLOX Bowling.rbxl",24},
{"[Ruin] 2007 ROBLOX HQ with normal weapons.rbxl",24},
{"[Ruin] 2007 Sword Fight on the Heights I (1).rbxl",24},
{"[Ruin] 2007 Sword Fight on the Heights I.rbxl",24},
{"[Ruin] 2007 Sword Fight on the Heights II.rbxl",24},
{"[Ruin] 2007 Sword Fight on the Heights III.rbxl",24},
{"[Ruin] 2007_BlOX_MART.rbxl",24},
{"[Ruin] 2007_Get_Crushed_by_a_Speeding_Wall.rbxl",24},
{"[Ruin] 2007_Spawn_Elevator.rbxl",24},
{"[Ruin] 2008 Bread Factory Tycoon.rbxl",24},
{"[Ruin] 2008 Defaultio Bowling.rbxl",24},
{"[Ruin] 2008 Dodge the Teapots!.rbxl",24},
{"[Ruin] 2008 FREE COOL STUFF - DEMOS.rbxl",24},
{"[Ruin] 2008 Get Crushed by a Speeding Wall!.rbxl",24},
{"[Ruin] 2008 Happy Home.rbxl",24},
{"[Ruin] 2008 Rocket Arena.rbxl",24},
{"[Ruin] 2008 Starting Brickbattle Map.rbxl",24},
{"[Ruin] 2008 Sword Fight on the Heights IV.rbxl",24},
{"[Ruin] 2008 Telamon's Big World with extended path and more cars and regens.rbxl",24},
{"[Ruin] 2008 Wizard Wars.rbxl",24},
{"[Ruin] 2008-2010 UnderGroundWars.rbxl",24},
{"[Ruin] 2010 Crazy Car Wars.rbxl",24},
{"[Ruin] 2010 Crossroads.rbxl",24},
{"[Ruin] 2010 Disaster Hotel.rbxl",24},
{"[Ruin] 2010 Doomspires.rbxl",24},
{"[Ruin] 2010 Flood Escape.rbxl",24},
{"[Ruin] 2010 Freeze tag.rbxl",24},
{"[Ruin] 2010 Frost Nova.rbxl",24},
{"[Ruin] 2010 Happy Home (Telamons Big World).rbxl",24},
{"[Ruin] 2010 Haunted Hotel.rbxl",24},
{"[Ruin] 2010 Lando's Apartment.rbxl",24},
{"[Ruin] 2010 McDonalds Vs KFC.rbxl",24},
{"[Ruin] 2010 Nintendo Minigames.rbxl",24},
{"[Ruin] 2010 R.U.N.rbxl",24},
{"[Ruin] 2010 Reason 2 Die.rbxl",24},
{"[Ruin] 2010 Ride a rocket to the space station and moon!.rbxl",24},
{"[Ruin] 2010 Ro-Pictionary.rbxl",24},
{"[Ruin] 2010 ROBLOX Arcade.rbxl",24},
{"[Ruin] 2010 ROBLOX Mall Tycoon.rbxl",24},
{"[Ruin] 2010 Rocket Builder.rbxl",24},
{"[Ruin] 2010 Script Builder.rbxl",24},
{"[Ruin] 2010 Town of Robloxia.rbxl",24},
{"[Ruin] 2010 Universe.rbxl",24},
{"[Ruin] 2010 Work at a Pizza Place.rbxl",24},
{"[Ruin] 2010 Zombie Tower.rbxl",24},
{"[Ruin] 2010NoobTrap2.rbxl",24},
{"[Ruin] Build2SurviveZombies.rbxl",24},
{"[Ruin] Build_a_Raft_and_Sail_TO_YOUR_DOOOOOM_.rbxl",24},
{"[Ruin] Build_to_survive.rbxl",24},
{"[Ruin] iron cafe.rbxl",24},
{"[Ruin] survive the disasters.rbxl",24},
{"[Ruin] Survive_The_DrakkoBloxxers.rbxl",24},
{"[Ruin] Thrillville 2008.rbxl",24},


{"[thinking] Iron Cafe.rbxl",24},

{"[NickoPorted] Viodacity Script Builder x3.rbxl",100},

{"[dotard] Stuck In A Box (with admin!).rbxl",24},
{"[dotard] Get Crushed by Speeding Wall 2007.rbxl",24},

{"[TypicalName] 2013studio.rbxl",24},
{"[TypicalName] 86.rbxl",24},
{"[TypicalName] abigcity.rbxl",24},
{"[TypicalName] advanced.rbxl",24},
{"[TypicalName] asmalltown.rbxl",24},
{"[TypicalName] asmalltownrevamp.rbxl",24},
{"[TypicalName] asmallvillage.rbxl",24},
{"[TypicalName] Baseplate.rbxl",24},
{"[TypicalName] beach.rbxl",24},
{"[TypicalName] bigcity.rbxl",24},
{"[TypicalName] billboards.rbxl",24},
{"[TypicalName] bricksville - Copy (10).rbxl",24},
{"[TypicalName] bricksville - Copy (11).rbxl",24},
{"[TypicalName] bricksville - Copy (2).rbxl",24},
{"[TypicalName] bricksville - Copy (3).rbxl",24},
{"[TypicalName] bricksville - Copy (4).rbxl",24},
{"[TypicalName] bricksville - Copy (5).rbxl",24},
{"[TypicalName] bricksville - Copy (6).rbxl",24},
{"[TypicalName] bricksville - Copy (7).rbxl",24},
{"[TypicalName] bricksville - Copy (8).rbxl",24},
{"[TypicalName] bricksville - Copy (9).rbxl",24},
{"[TypicalName] bricksville - Copy.rbxl",24},
{"[TypicalName] bricksville.rbxl",24},
{"[TypicalName] bricksville2.rbxl",24},
{"[TypicalName] bricksville2fixed.rbxl",24},
{"[TypicalName] bricksvillerevamped.rbxl",24},
{"[TypicalName] build.rbxl",24},
{"[TypicalName] cafe.rbxl",24},
{"[TypicalName] car template.rbxl",24},
{"[TypicalName] car.rbxl",24},
{"[TypicalName] cart ride.rbxl",24},
{"[TypicalName] city.rbxl",24},
{"[TypicalName] city2.rbxl",24},
{"[TypicalName] club.rbxl",24},
{"[TypicalName] coldsmoke suggestinos.rbxl",24},
{"[TypicalName] crash.rbxl",24},
{"[TypicalName] disaster.rbxl",24},
{"[TypicalName] erik castle.rbxl",24},
{"[TypicalName] event asmalltown.rbxl",24},
{"[TypicalName] final game..rbxl",24},
{"[TypicalName] fps uwot.rbxl",24},
{"[TypicalName] goodcity.rbxl",24},
{"[TypicalName] gtcity.rbxl",24},
{"[TypicalName] guitest.rbxl",24},
{"[TypicalName] hangout.rbxl",24},
{"[TypicalName] happyhouse.rbxl",24},
{"[TypicalName] home.rbxl",24},
{"[TypicalName] hotel.rbxl",24},
{"[TypicalName] house build.rbxl",24},
{"[TypicalName] jail.rbxl",24},
{"[TypicalName] lonelyvillage.rbxl",24},
{"[TypicalName] make a home.rbxl",24},
{"[TypicalName] neighborhood.rbxl",24},
{"[TypicalName] night club.rbxl",24},
{"[TypicalName] nuke.rbxl",24},
{"[TypicalName] nuke2.rbxl",24},
{"[TypicalName] Obby.rbxl",24},
{"[TypicalName] paintball.rbxl",24},
{"[TypicalName] parkcentral.rbxl",24},
{"[TypicalName] Place1.rbxl",24},
{"[TypicalName] pmltgw (1).rbxl",24},
{"[TypicalName] pmltgw.rbxl",24},
{"[TypicalName] race.rbxl",24},
{"[TypicalName] rocket.rbxl",24},
{"[TypicalName] roller coaster.rbxl",24},
{"[TypicalName] skate 2013.rbxl",24},
{"[TypicalName] skateboard.rbxl",24},
{"[TypicalName] skyscraper.rbxl",24},
{"[TypicalName] studio.rbxl",24},
{"[TypicalName] suggestion.rbxl",24},
{"[TypicalName] terrainbuild - Copy (2).rbxl",24},
{"[TypicalName] terrainbuild - Copy.rbxl",24},
{"[TypicalName] terrainbuild.rbxl",24},
{"[TypicalName] terrainbuild2.rbxl",24},
{"[TypicalName] terrainbuild22.rbxl",24},
{"[TypicalName] terrainbuild2backup.rbxl",24},
{"[TypicalName] terrainbuild2backup2 - Copy.rbxl",24},
{"[TypicalName] terrainbuild2backup2.rbxl",24},
{"[TypicalName] the brick genereator.rbxl",24},
{"[TypicalName] the world.rbxl",24},
{"[TypicalName] Tokyo.rbxl",24},
{"[TypicalName] tornado.rbxl",24},
{"[TypicalName] tornadofinobe.rbxl",24},
{"[TypicalName] town and tsunami.rbxl",24},
{"[TypicalName] track.rbxl",24},
{"[TypicalName] track2.rbxl",24},
{"[TypicalName] tsunami.rbxl",24},
{"[TypicalName] typicalsworld.rbxl",24},
{"[TypicalName] uwot9777build.rbxl",24},
{"[TypicalName] uwottown v3 pvp graphictoria.rbxl",24},
{"[TypicalName] uwottown v4 pvp graphictoria.rbxl",24},
{"[TypicalName] wdwdawsdw.rbxl",24},
{"[TypicalName] welcome to uwot9777s town.rbxl",24},
{"[TypicalName] wotville.rbxl",24},



{"Work at a Pizza Place AlmstCompltlyWrks2008.rbxl",24},


{"best in 2008 bricks instead of wobbles SFOTH.rbxl",24},
{"Normal Sword Fights on The Heights IV.rbxl",24},
{"[Whimee] Sword_Fight_on_the_Heights_IV.rbxl",24},

{"[WinSM1234] Big Slide.rbxl",24},
{"[WinSM1234] Destroy the Buildings.rbxl",24},
{"[WinSM1234] Old Cars v2.rbxl",24},
{"[WinSM1234] Rocket Car Crash Simulator.rbxl",24},
{"[WinSM1234] Rocket Jeep Racing.rbxl",24},
{"[WinSM1234] Winsupermario HQ.rbxl",24},

{"[Whimee] Survive the Spheres.rbxl",24},
{"[Whimee] 2005 Bridge It! 2.rbxl",24},
{"[Whimee] 2006 Crossroads baseplate with studs.rbxl",24},
{"[Whimee] 2006 Crossroads fixed Hideout with common tools.rbxl",24},
{"[Whimee] 2006 Crossroads with early weapons.rbxl",24},
{"[Whimee] 2006 Crossroads with epic and tools.rbxl",24},
{"[Whimee] 2006 Crossroads with fixed Freebricks.rbxl",24},
{"[Whimee] 2006 Crossroads with Freebricks.rbxl",24},
{"[Whimee] 2006 Crossroads with modern weapons.rbxl",24},
{"[Whimee] 2006 Crossroads with Old Bomb.rbxl",24},
{"[Whimee] 2006 DoomSpire and Towers 2.rbxl",24},
{"[Whimee] 2006 DoomSpire and Towers with taller tower fixed more.rbxl",24},
{"[Whimee] 2006 DoomSpire and Towers with taller tower.rbxl",24},
{"[Whimee] 2006 DoomSpire and Towers.rbxl",24},
{"[Whimee] 2006 Maze of Doom.rbxl",24},
{"[Whimee] 2006 Mountain with 2006 weapons.rbxl",24},
{"[Whimee] 2006 Pirate Army HQ.rbxl",24},
{"[Whimee] 2006 Stairway to Heaven.rbxl",24},
{"[Whimee] 2006 Starter Place.rbxl",24},
{"[Whimee] 2006 The Original Idea of Crossroads from screenshot.rbxl",24},
{"[Whimee] 2006 Ultimate Paintball.rbxl",24},
{"[Whimee] 2006 Weird Place.rbxl",24},
{"[Whimee] 2007 Bastion of Horsey.rbxl",24},
{"[Whimee] 2007 BlOX MART.rbxl",24},
{"[Whimee] 2007 Builderman Suite.rbxl",24},
{"[Whimee] 2007 Castle Warfare.rbxl",24},
{"[Whimee] 2007 Chaos Canyon with old Bomb.rbxl",24},
{"[Whimee] 2007 Community Construction Site 2.rbxl",24},
{"[Whimee] 2007 COmmunity Construction.rbxl",24},
{"[Whimee] 2007 Crossroads in 2006.rbxl",24},
{"[Whimee] 2007 Crossroads with 2006 weapons.rbxl",24},
{"[Whimee] 2007 Crossroads.rbxl",24},
{"[Whimee] 2007 Cube World.rbxl",24},
{"[Whimee] 2007 Dodge the Teapots!.rbxl",24},
{"[Whimee] 2007 DOmino Rally.rbxl",24},
{"[Whimee] 2007 Doomspire 4 tower battle.rbxl",24},
{"[Whimee] 2007 DoomSpire from World of roblox.rbxl",24},
{"[Whimee] 2007 DoomSpire.rbxl",24},
{"[Whimee] 2007 Earlu Crossroads with 2006 weapons and two temples.rbxl",24},
{"[Whimee] 2007 Elemental Lake.rbxl",24},
{"[Whimee] 2007 Four Towers Bridge Battle.rbxl",24},
{"[Whimee] 2007 Get Crushed by a Speeding Wall!.rbxl",24},
{"[Whimee] 2007 Grey City with normal weapons.rbxl",24},
{"[Whimee] 2007 Guitar Gods.rbxl",24},
{"[Whimee] 2007 Haunted Mansion.rbxl",24},
{"[Whimee] 2007 LIMAL MESSAGE.rbxl",24},
{"[Whimee] 2007 Mission to the Moon.rbxl",24},
{"[Whimee] 2007 Nevermoors BLight.rbxl",24},
{"[Whimee] 2007 Ninja vs. Samurai.rbxl",24},
{"[Whimee] 2007 Normal Grey City with LASER and old weapons.rbxl",24},
{"[Whimee] 2007 Normal Grey City with LASER.rbxl",24},
{"[Whimee] 2007 Nuke the Whales!.rbxl",24},
{"[Whimee] 2007 OH NOES! The moon is falling! Moon up up and away.rbxl",24},
{"[Whimee] 2007 OH NOES! The moon is falling!.rbxl",24},
{"[Whimee] 2007 PilotLuke_s Cloud City with 2006 tools and new rocket and physics.rbxl",24},
{"[Whimee] 2007 PilotLuke_s Cloud City with 2006 tools.rbxl",24},
{"[Whimee] 2007 PilotLuke_s Cloud City with 2013 tools and new rocket.rbxl",24},
{"[Whimee] 2007 PilotLuke_s Cloud City.rbxl",24},
{"[Whimee] 2007 Pinball Wizards! with more balls.rbxl",24},
{"[Whimee] 2007 Pinball Wizards!.rbxl",24},
{"[Whimee] 2007 Pirate Ship with original weapons.rbxl",24},
{"[Whimee] 2007 Pirate Ship.rbxl",24},
{"[Whimee] 2007 Rail System.rbxl",24},
{"[Whimee] 2007 ROBLOX HQ with Mjolnir.rbxl",24},
{"[Whimee] 2007 ROBLOX HQ with normal weapons.rbxl",24},
{"[Whimee] 2007 ROBLOX HQ with Old Bomb and Old Rocket.rbxl",24},
{"[Whimee] 2007 ROBLOX HQ with Old Bomb.rbxl",24},
{"[Whimee] 2007 ROBLOX HQ.rbxl",24},
{"[Whimee] 2007 Rocket Fight Advanced with baseplate.rbxl",24},
{"[Whimee] 2007 Santas Winter Stronghold.rbxl",24},
{"[Whimee] 2007 Script Builder.rbxl",24},
{"[Whimee] 2007 Starting Brickbattle Map.rbxl",24},
{"[Whimee] 2007 Strange Place.rbxl",24},
{"[Whimee] 2007 Sunset Plain.rbxl",24},
{"[Whimee] 2007 Sword Fight on the Heights I.rbxl",24},
{"[Whimee] 2007 Sword Fight on the Heights II.rbxl",24},
{"[Whimee] 2007 Tabula Rasa.rbxl",24},
{"[Whimee] 2007 The Vanishing Point.rbxl",24},
{"[Whimee] 2007 Trampoline Sword Fight.rbxl",24},
{"[Whimee] 2007 Travellers tale.rbxl",24},
{"[Whimee] 2007 YRP.rbxl",24},
{"[Whimee] 2008 Bread Factory Tycoon.rbxl",24},
{"[Whimee] 2008 Castle Destruction.rbxl",24},
{"[Whimee] 2008 Crossroads with 2008 tools.rbxl",24},
{"[Whimee] 2008 Crossroads without custom skybox.rbxl",24},
{"[Whimee] 2008 Crossroads.rbxl",24},
{"[Whimee] 2008 Dodge the Teapots!.rbxl",24},
{"[Whimee] 2008 Fixed Rube.rbxl",24},
{"[Whimee] 2008 FREE COOL STUFF - DEMOS.rbxl",24},
{"[Whimee] 2008 Fun with Mjoinir.rbxl",24},
{"[Whimee] 2008 Get Crushed by a Speeding Wall!.rbxl",24},
{"[Whimee] 2008 Glass Houses with original weapons.rbxl",24},
{"[Whimee] 2008 Glass Houses.rbxl",24},
{"[Whimee] 2008 Gold Digger.rbxl",24},
{"[Whimee] 2008 Grow a Slime.rbxl",24},
{"[Whimee] 2008 Happy Home.rbxl",24},
{"[Whimee] 2008 Pinball Wizards!.rbxl",24},
{"[Whimee] 2008 ROBLOX HQ from Explore ROBLOX.rbxl",24},
{"[Whimee] 2008 ROBLOX HQ with Mjolnir.rbxl",24},
{"[Whimee] 2008 Rocket  Arena.rbxl",24},
{"[Whimee] 2008 Rocket Mayhem.rbxl",24},
{"[Whimee] 2008 Shirts and Pants breaking place.rbxl",24},
{"[Whimee] 2008 Starting Brickbattle Map.rbxl",24},
{"[Whimee] 2008 Telamon_s Big World with extended path and more cars and regens.rbxl",24},
{"[Whimee] 2008 Telamon_s Big World with extended path and more cars.rbxl",24},
{"[Whimee] 2008 Telamon_s Big World.rbxl",24},
{"[Whimee] 2008 The Barren Ice Sheets of Frostmoor.rbxl",24},
{"[Whimee] 2008 Welcome to ROBLOX.rbxl",24},
{"[Whimee] 2008 Wizard Wars.rbxl",24},
{"[Whimee] 2009 Build your Own Game.rbxl",24},
{"[Whimee] 2009 Fall down the stairs.rbxl",24},
{"[Whimee] 2009 Lol.rbxl",24},
{"[Whimee] 2009 SlingyShoty Valley.rbxl",24},
{"[Whimee] 2009 Tabula Rasa.rbxl",24},
{"[Whimee] 2009-ish Happy Home with even more freebricks.rbxl",24},
{"[Whimee] 2009-ish Happy Home with more freebricks.rbxl",24},
{"[Whimee] 2009-ish Happy Home.rbxl",24},
{"[Whimee] 2010 Crazy Car Wars.rbxl",24},
--{"[Whimee] 2010 Happy Home (USE WITH 2010 ROBLOX STUDIO client) with more hopperbins and more cars.rbxl",24},
--{"[Whimee] 2010 Happy Home (USE WITH 2010 ROBLOX STUDIO client) with more hopperbins.rbxl",24},
{"[Whimee] 2010 Universe.rbxl",24},
{"[Whimee] 2013 CLIMB.rbxl",24},
{"[Whimee] 2013 Get Crushed by a Speeding Wall! Old.rbxl",24},
{"[Whimee] 2013 Hug the Teapots!.rbxl",24},
{"[Whimee] 2013 Lovebots.rbxl",24},
{"[Whimee] 2013 NUKE THE TEAPOTS.rbxl",24},
{"[Whimee] 2013 PilotLuke_s Cloud City.rbxl",24},
{"[Whimee] 2013 Pinball Game 2.rbxl",24},
{"[Whimee] 2013 Pinball Game.rbxl",24},
{"[Whimee] 2013 Recreation of Thrillville.rbxl",24},
{"[Whimee] 2013 ROBLOX HQ.rbxl",24},
{"[Whimee] 2013 Tabula Rasa.rbxl",24},
{"[Whimee] 2013 Telamon_s Village.rbxl",24},
{"[Whimee] 2013 Trampoline Testing 2.rbxl",24},
{"[Whimee] 2013 Winter Rocket  Arena.rbxl",24},
{"[Whimee] 2014 Blown Up Happy Home.rbxl",24},
{"[Whimee] 2014 Boring Happy Home.rbxl",24},
{"[Whimee] 2014 Lol Happy Home.rbxl",24},
{"[Whimee] 2014 Woah Happy Home.rbxl",24},
{"[Whimee] arcade.rbxl",24},
{"[Whimee] Autumn.rbxl",24},
{"[Whimee] Balance.rbxl",24},
{"[Whimee] Be crushed by speeding wall.rbxl",24},
{"[Whimee] billiland reverse time.rbxl",24},
{"[Whimee] Blazing man v3.1.8 (2).rbxl",24},
{"[Whimee] Blockcraft.rbxl",24},
{"[Whimee] Build2SurviveZombies.rbxl",24},
{"[Whimee] building with friends.rbxl",24},
{"[Whimee] c5430b1a15f303fb09a6b94f58012a1a.rbxl",24},
{"[Whimee] Call of ROBLOXia World at War.rbxl",24},
{"[Whimee] cfe8ff399eabac1b264b1d0d5e55c966.rbxl",24},
{"[Whimee] ClientSetsToolbox.rbxl",24},
{"[Whimee] Cobalt Legion Capital City.rbxl",24},
{"[Whimee] Community Construction Site.rbxl",24},
{"[Whimee] Contamination.rbxl",24},
{"[Whimee] Creed.rbxl",24},
{"[Whimee] Crossroads with bricks.rbxl",24},
{"[Whimee] Crossroads with bricks2.rbxl",24},
{"[Whimee] Crossroads with unanchored Trampoline.rbxl",24},
{"[Whimee] Crossroads.rbxl",24},
{"[Whimee] DeadSpace.rbxl",24},
{"[Whimee] desert castle wars default place recreation.rbxl",24},
{"[Whimee] destruction derby.rbxl",24},
{"[Whimee] Dodge the Teapots.rbxl",24},
{"[Whimee] dodgeball - alexnewtron.rbxl",24},
{"[Whimee] Domo Island Tycoon.rbxl",24},
{"[Whimee] Dots by Brandonhare.rbxl",24},
{"[Whimee] Dragon Ball Z Online Adventures.rbxl",24},
{"[Whimee] Eat Or Make The Food For Mc.Donalds Or PizzaHut!.rbxl",24},
{"[Whimee] eee.rbxl",24},
{"[Whimee] Fake Crossroads.rbxl",24},
{"[Whimee] Falling Crossroads2.rbxl",24},
{"[Whimee] fearhq.rbxl",24},
{"[Whimee] Fencing - Stolen.rbxl",24},
{"[Whimee] Fort For Sale 8.rbxl",24},
{"[Whimee] GAME.rbxl",24},
{"[Whimee] GGR-Capital-City-Coruscant.rbxl",24},
{"[Whimee] giant rocket arena.rbxl",24},
{"[Whimee] glass houses.rbxl",24},
{"[Whimee] Gravity chamber.rbxl",24},
{"[Whimee] happy home in robloxia 2009 SNOW.rbxl",24},
{"[Whimee] Haunted Mansion.rbxl",24},
{"[Whimee] Helghast-Legion-Fort-Rebirth.rbxl",24},
{"[Whimee] Hide and seek - Lance7.rbxl",24},
{"[Whimee] Holewall.rbxl",24},
{"[Whimee] hq.rbxl",24},
{"[Whimee] HumanoidHarvester.rbxl",24},
{"[Whimee] Immortals - NEMESlS - Alakazard.rbxl",24},
{"[Whimee] iron cafe.rbxl",24},
{"[Whimee] khanglegos.rbxl",24},
{"[Whimee] Kingofhill.rbxl",24},
{"[Whimee] Laser Tanks 2.0.rbxl",24},
{"[Whimee] Last 1 Alive.rbxl",24},
{"[Whimee] Live in 5 star resort.rbxl",24},
{"[Whimee] Mc Donalds Vs KFC.rbxl",24},
{"[Whimee] mission to the moon.rbxl",24},
{"[Whimee] Natural Disaster Survival.rbxl",24},
{"[Whimee] Natural disasters.rbxl",24},
{"[Whimee] new server physics benchmark.rbxl",24},
{"[Whimee] Oasis - Samacado.rbxl",24},
{"[Whimee] OLD.rbxl",24},
{"[Whimee] oldcastle.rbxl",24},
{"[Whimee] Oysi 3D GUI.rbxl",24},
{"[Whimee] Oysi scrambling.rbxl",24},
{"[Whimee] Oysi93 Gravity Cube.rbxl",24},
{"[Whimee] Parody - GollyGreg.rbxl",24},
{"[Whimee] Perlious Skies.rbxl",24},
{"[Whimee] Person299 minigames.rbxl",24},
{"[Whimee] Pinball Wizards!.rbxl",24},
{"[Whimee] Raise a dancing banana - MARIOSTAR6464.rbxl",24},
{"[Whimee] RFL.rbxl",24},
{"[Whimee] Roblox Building - ROBLOX.rbxl",24},
{"[Whimee] Roblox City.rbxl",24},
{"[Whimee] ROBLOX Derby.rbxl",24},
{"[Whimee] Roblox HQ.rbxl",24},
{"[Whimee] Rocket Arena.rbxl",24},
{"[Whimee] RocketFightAdvanced.rbxl",24},
{"[Whimee] ropictionary - alexnewtron.rbxl",24},
{"[Whimee] Sattalite - clockwork.rbxl",24},
{"[Whimee] Scrambling Eggs.rbxl",24},
{"[Whimee] Script Builder.rbxl",24},
{"[Whimee] Shrine of the Fallen Hero - Minish.rbxl",24},
{"[Whimee] SP - GollyGreg.rbxl",24},
{"[Whimee] Stairway to Heaven.rbxl",24},
{"[Whimee] StamperToolTest_s place.rbxl",24},
{"[Whimee] Starter Place.rbxl",24},
{"[Whimee] survive the disasters.rbxl",24},
{"[Whimee] Survive The DrakkoBloxxers.rbxl",24},
{"[Whimee] SurviveTheDisasters.rbxl",24},
{"[Whimee] Teapots of doom - clockwork.rbxl",24},
{"[Whimee] Techy.rbxl",24},
{"[Whimee] Telamon.rbxl",24},
{"[Whimee] The Legente Airship.rbxl",24},
{"[Whimee] The-Imperium-of-Man-Recruitment-Center.rbxl",24},
{"[Whimee] The-Imperium-of-Man-Training-Academy.rbxl",24},
{"[Whimee] TheGamer101.rbxl",24},
{"[Whimee] TheUndergroundWar.rbxl",24},
{"[Whimee] ThrillVille.rbxl",24},
{"[Whimee] TowerDefence.rbxl",24},
{"[Whimee] Turkey Hunt 2011 - ROBLOX.rbxl",24},
{"[Whimee] Two Player War Tycoon.rbxl",24},
{"[Whimee] UberObby.rbxl",24},
{"[Whimee] Ultimate Paintball Fighting.rbxl",24},
{"[Whimee] Ultimate_Paintball.rbxl",24},
{"[Whimee] Urban Warfare.rbxl",24},
{"[Whimee] Vault.rbxl",24},
{"[Whimee] Virde Cova - Stolen.rbxl",24},
{"[Whimee] web.rbxl",24},
{"[Whimee] Welcome to roblox.rbxl",24},
{"[Whimee] WIJ Training facility skywards.rbxl",24},
{"[Whimee] Winter rocket arena.rbxl",24},
{"[Whimee] WizardWars.rbxl",24},
{"[Whimee] WWA.rbxl",24},
{"[Whimee] Z-E-T-A-Online-RPG.rbxl",24},
{"[Whimee] Zombie Defence III.rbxl",24},
{"[Whimee] 2007 the living dead.rbxl",24},

--[[
{"[P4ris-v3rm] A Dinosaur_s Life _HUNTERS UPDATE!_.rbxl",24},
{"[P4ris-v3rm] Adventure time land of ooo.rbxl",24},
{"[P4ris-v3rm] aeroplane.rbxl",24},
{"[P4ris-v3rm] Airport.rbxl",24},
{"[P4ris-v3rm] Alaska state troopers.rbxl",24},
{"[P4ris-v3rm] Aldacre.rbxl",24},
{"[P4ris-v3rm] Allied airborne boot camp.rbxl",24},
{"[P4ris-v3rm] Apocalypse Rising Reimagined.rbxl",24},
{"[P4ris-v3rm] AR Reimagined.rbxl",24},
{"[P4ris-v3rm] Area 51 Zombie Infection.rbxl",24},
{"[P4ris-v3rm] Arena the swords skyland.rbxl",24},
{"[P4ris-v3rm] Armored Patrol v8.5.rbxl",24},
{"[P4ris-v3rm] Attack of titan.rbxl",24},
{"[P4ris-v3rm] Autumn.rbxl",24},
{"[P4ris-v3rm] Avert the Odds.rbxl",24},
{"[P4ris-v3rm] Battlefield.rbxl",24},
{"[P4ris-v3rm] Bhb recruitment obby initiates.rbxl",24},
{"[P4ris-v3rm] Bird Simulator.rbxl",24},
{"[P4ris-v3rm] Bleach Versus _Pre-Alpha_.rbxl",24},
{"[P4ris-v3rm] Blitz - ww2.rbxl",24},
{"[P4ris-v3rm] Blox city.rbxl",24},
{"[P4ris-v3rm] Bloxtable.fm.rbxl",24},
{"[P4ris-v3rm] Bomb Shelter.rbxl",24},
{"[P4ris-v3rm] Breakout.rbxl",24},
{"[P4ris-v3rm] Breezy_z V1 _OPEN_.rbxl",24},
{"[P4ris-v3rm] Build a Raft and Sail.rbxl",24},
{"[P4ris-v3rm] Build and Race.rbxl",24},
{"[P4ris-v3rm] Burger king homstore.rbxl",24},
{"[P4ris-v3rm] C3C Fire Truck.rbxl",24},
{"[P4ris-v3rm] call of robloxia 2.rbxl",24},
{"[P4ris-v3rm] Cave run 3.rbxl",24},
{"[P4ris-v3rm] City of Dublin_ Ireland REAL.rbxl",24},
{"[P4ris-v3rm] City of Dublin_ Ireland.rbxl",24},
{"[P4ris-v3rm] City.rbxl",24},
{"[P4ris-v3rm] clocktest.rbxl",24},
{"[P4ris-v3rm] Club solaris.rbxl",24},
{"[P4ris-v3rm] Cold Stone Homestore.rbxl",24},
{"[P4ris-v3rm] Completed.rbxl",24},
{"[P4ris-v3rm] Cooperation.rbxl",24},
{"[P4ris-v3rm] Countryside.rbxl",24},
{"[P4ris-v3rm] Creeper survival.rbxl",24},
{"[P4ris-v3rm] Crystal so.rbxl",24},
{"[P4ris-v3rm] Darkness 2.rbxl",24},
{"[P4ris-v3rm] DAYZ by GamingDev.rbxl",24},
{"[P4ris-v3rm] DBZ Zenoverse.rbxl",24},
{"[P4ris-v3rm] Dead Mist (Bit of the map).rbxl",24},
{"[P4ris-v3rm] Dead Winter v2 (2).rbxl",24},
{"[P4ris-v3rm] Dead Winter v2.rbxl",24},
{"[P4ris-v3rm] Dead Winter.rbxl",24},
{"[P4ris-v3rm] DeadZone.rbxl",24},
{"[P4ris-v3rm] Deal or no deal.rbxl",24},
{"[P4ris-v3rm] Deathrun Winter Run.rbxl",24},
{"[P4ris-v3rm] Defaultio Coaster Creator.rbxl",24},
{"[P4ris-v3rm] Dragon Ball Z IW 3.0.rbxl",24},
{"[P4ris-v3rm] Dragon Ball Z Online Adventures.rbxl",24},
{"[P4ris-v3rm] DUCK.rbxl",24},
{"[P4ris-v3rm] EmpireBay.rbxl",24},
{"[P4ris-v3rm] Fairy Tail Revelations c EVENT.rbxl",24},
{"[P4ris-v3rm] Fencing.rbxl",24},
{"[P4ris-v3rm] Finished By DrBigWallet.rbxl",24},
{"[P4ris-v3rm] Firebase Kurt.rbxl",24},
{"[P4ris-v3rm] Forgotten Memories _Showcase_.rbxl",24},
{"[P4ris-v3rm] Forgotten Memories.rbxl",24},
{"[P4ris-v3rm] Fort wolf 2.rbxl",24},
{"[P4ris-v3rm] FPS Patrol.rbxl",24},
{"[P4ris-v3rm] Fragmentation Test.rbxl",24},
{"[P4ris-v3rm] Freddys pizza roleplay.rbxl",24},
{"[P4ris-v3rm] Freezies icecream parlor.rbxl",24},
{"[P4ris-v3rm] GBL ARENA.rbxl",24},
{"[P4ris-v3rm] Goradiel Rpg - 4.rbxl",24},
{"[P4ris-v3rm] Guess what im drawing.rbxl",24},
{"[P4ris-v3rm] Guest Defense.rbxl",24},
{"[P4ris-v3rm] Guest Quest Online.rbxl",24},
{"[P4ris-v3rm] Gun Animations.rbxl",24},
{"[P4ris-v3rm] Halloween nova.rbxl",24},
{"[P4ris-v3rm] HEX - ARENA SHOOTER.rbxl",24},
{"[P4ris-v3rm] Holewall.rbxl",24},
{"[P4ris-v3rm] hq4.rbxl",24},
{"[P4ris-v3rm] HUGE STORE.rbxl",24},
{"[P4ris-v3rm] Ice Cream Parior Tycoon.rbxl",24},
{"[P4ris-v3rm] idk.rbxl",24},
{"[P4ris-v3rm] In the forest.rbxl",24},
{"[P4ris-v3rm] Innovation Labs.rbxl",24},
{"[P4ris-v3rm] Inside out roleplay.rbxl",24},
{"[P4ris-v3rm] Jailbreak ccs remake.rbxl",24},
{"[P4ris-v3rm] JailBreak.rbxl",24},
{"[P4ris-v3rm] Kestrel.rbxl",24},
{"[P4ris-v3rm] Kill the clones.rbxl",24},
{"[P4ris-v3rm] Kingslanding.rbxl",24},
{"[P4ris-v3rm] LaserTag1.rbxl",24},
{"[P4ris-v3rm] Last 1 Alive.rbxl",24},
{"[P4ris-v3rm] lightsaber scripting.rbxl",24},
{"[P4ris-v3rm] Limited Simulator 2.rbxl",24},
{"[P4ris-v3rm] Limited Simulator 3.rbxl",24},
{"[P4ris-v3rm] Limited Simulator.rbxl",24},
{"[P4ris-v3rm] Limited Tycoon 2.rbxl",24},
{"[P4ris-v3rm] Mad Paintball.rbxl",24},
{"[P4ris-v3rm] MadGames (1.3b).rbxl",24},
{"[P4ris-v3rm] Mafia.rbxl",24},
{"[P4ris-v3rm] Mansion Tycoon.rbxl",24},
{"[P4ris-v3rm] Manzitrek-III.rbxl",24},
{"[P4ris-v3rm] Mariokart.rbxl",24},
{"[P4ris-v3rm] McDonalds.rbxl",24},
{"[P4ris-v3rm] Medieval Warfare Reforged.rbxl",24},
{"[P4ris-v3rm] Memories.rbxl",24},
{"[P4ris-v3rm] Middle Ocean.rbxl",24},
{"[P4ris-v3rm] Minigame.rbxl",24},
{"[P4ris-v3rm] Mining game (Not dummiez version).rbxl",24},
{"[P4ris-v3rm] Mood.rbxl",24},
{"[P4ris-v3rm] MPS PITCH.rbxl",24},
{"[P4ris-v3rm] Murder Game.rbxl",24},
{"[P4ris-v3rm] Murder simulator.rbxl",24},
{"[P4ris-v3rm] Naruto Ninja legacy.rbxl",24},
{"[P4ris-v3rm] NHL hangout.rbxl",24},
{"[P4ris-v3rm] Ninja warfare tycoon.rbxl",24},
{"[P4ris-v3rm] Obsessed MLG Murderer!.rbxl",24},
{"[P4ris-v3rm] One Piece Golden Age.rbxl",24},
{"[P4ris-v3rm] One piece thing.rbxl",24},
{"[P4ris-v3rm] One piece.rbxl",24},
{"[P4ris-v3rm] Open tonight.rbxl",24},
{"[P4ris-v3rm] Paint tycoon.rbxl",24},
{"[P4ris-v3rm] Paintball.rbxl",24},
{"[P4ris-v3rm] Perlious Skies.rbxl",24},
{"[P4ris-v3rm] Phantom Forces Beta.rbxl",24},
{"[P4ris-v3rm] Phantom Forces _current version_.rbxl",24},
{"[P4ris-v3rm] pinewood hq.rbxl",24},
{"[P4ris-v3rm] Piri Piri Chicken Co  Restaurant.rbxl",24},
{"[P4ris-v3rm] Plastic men.rbxl",24},
{"[P4ris-v3rm] Pokemon Adventures By IlIll.rbxl",24},
{"[P4ris-v3rm] Pokemon Brick Bronze Demo.rbxl",24},
{"[P4ris-v3rm] Pokemon Brick Bronze V2.rbxl",24},
{"[P4ris-v3rm] Pokemon Brick Bronze V3.rbxl",24},
{"[P4ris-v3rm] Pokemon Brick Bronze.rbxl",24},
{"[P4ris-v3rm] Pokemon Online.rbxl",24},
{"[P4ris-v3rm] Poland wolin island.rbxl",24},
{"[P4ris-v3rm] Prision.rbxl",24},
{"[P4ris-v3rm] Prison Life v0.6.rbxl",24},
{"[P4ris-v3rm] Project Pokemon 10_.rbxl",24},
{"[P4ris-v3rm] Project Pokemon By WishNite.rbxl",24},
{"[P4ris-v3rm] PropHunt.rbxl",24},
{"[P4ris-v3rm] RAT FORT BOREALIS.rbxl",24},
{"[P4ris-v3rm] RDS  Headquarters.rbxl",24},
{"[P4ris-v3rm] realistic basketball.rbxl",24},
{"[P4ris-v3rm] Reason for blood.rbxl",24},
{"[P4ris-v3rm] Republic private airport.rbxl",24},
{"[P4ris-v3rm] Revolver Tournament.rbxl",24},
{"[P4ris-v3rm] RGH hospital.rbxl",24},
{"[P4ris-v3rm] RISKY STRATS.rbxl",24},
{"[P4ris-v3rm] roblox battle.rbxl",24},
{"[P4ris-v3rm] ROBLOX Bowling Alley.rbxl",24},
{"[P4ris-v3rm] ROBLOX High School.rbxl",24},
{"[P4ris-v3rm] Roblox highschool map.rbxl",24},
{"[P4ris-v3rm] RoCitizens.rbxl",24},
{"[P4ris-v3rm] Roman Parthia.rbxl",24},
{"[P4ris-v3rm] Satellite.rbxl",24},
{"[P4ris-v3rm] Saw.rbxl",24},
{"[P4ris-v3rm] senare meeting.rbxl",24},
{"[P4ris-v3rm] Simpson tycoon.rbxl",24},
{"[P4ris-v3rm] Sizzleburger V1.2.rbxl",24},
{"[P4ris-v3rm] Skate down the city.rbxl",24},
{"[P4ris-v3rm] small waterfall.rbxl",24},
{"[P4ris-v3rm] smooth terrain test.rbxl",24},
{"[P4ris-v3rm] Snowglobe.rbxl",24},
{"[P4ris-v3rm] Solar Star Cafe.rbxl",24},
{"[P4ris-v3rm] Some fort.rbxl",24},
{"[P4ris-v3rm] Starbucks cafe.rbxl",24},
{"[P4ris-v3rm] Starbucks.rbxl",24},
{"[P4ris-v3rm] Supreme Fishing Simulator.rbxl",24},
{"[P4ris-v3rm] SWAT Camp.rbxl",24},
{"[P4ris-v3rm] Sword Fighting Tournament.rbxl",24},
{"[P4ris-v3rm] Swordburst Onlin F1.rbxl",24},
{"[P4ris-v3rm] Target v1.0.rbxl",24},
{"[P4ris-v3rm] Techy.rbxl",24},
{"[P4ris-v3rm] Temple run.rbxl",24},
{"[P4ris-v3rm] TGI Port sovereignty.rbxl",24},
{"[P4ris-v3rm] The 4th vector.rbxl",24},
{"[P4ris-v3rm] The coffee house cafe.rbxl",24},
{"[P4ris-v3rm] The complex.rbxl",24},
{"[P4ris-v3rm] The Crust By TheOnlyYaY.rbxl",24},
{"[P4ris-v3rm] The Infection.rbxl",24},
{"[P4ris-v3rm] The late late toy show.rbxl",24},
{"[P4ris-v3rm] The Legente Airship.rbxl",24},
{"[P4ris-v3rm] The Normal Elevator.rbxl",24},
{"[P4ris-v3rm] The pizzeria roleplay.rbxl",24},
{"[P4ris-v3rm] The Plaza Beta 2.15.16.rbxl",24},
{"[P4ris-v3rm] The Plaza Kartz 2.17.2016.rbxl",24},
{"[P4ris-v3rm] The Quarry.rbxl",24},
{"[P4ris-v3rm] The Reverse Bear Trap Experience.rbxl",24},
{"[P4ris-v3rm] The Shed.rbxl",24},
{"[P4ris-v3rm] The Stalker.rbxl",24},
{"[P4ris-v3rm] The sword fighting.rbxl",24},
{"[P4ris-v3rm] The view vista.rbxl",24},
{"[P4ris-v3rm] Tiny Tanks!.rbxl",24},
{"[P4ris-v3rm] Trade hangout.rbxl",24},
{"[P4ris-v3rm] Traning center.rbxl",24},
{"[P4ris-v3rm] Trav_s Lab.rbxl",24},
{"[P4ris-v3rm] Truck tycoon.rbxl",24},
{"[P4ris-v3rm] Tyros mortem hoth.rbxl",24},
{"[P4ris-v3rm] Unfinished building.rbxl",24},
{"[P4ris-v3rm] Vault.rbxl",24},
{"[P4ris-v3rm] Virde Cova.rbxl",24},
{"[P4ris-v3rm] War Games - BETA v1.15.rbxl",24},
{"[P4ris-v3rm] Work at a Pizza Place.rbxl",24},
{"[P4ris-v3rm] World of RoCraft 3 UNIVERSE.rbxl",24},
{"[P4ris-v3rm] Your Age on ROBLOX.rbxl",24},
{"[P4ris-v3rm] Zombie city.rbxl",24},
{"[P4ris-v3rm] Zombie tower.rbxl",24},
{"[P4ris-v3rm] _BETA_ Star Wars OA CATINA HUB.rbxl",24},
{"[P4ris-v3rm] _BETA_ Star Wars OA SELECT SCREEN.rbxl",24},
{"[P4ris-v3rm] _BETA_ Star Wars OA TATOOINE.rbxl",24},
{"[P4ris-v3rm] _GRC_ Athens.rbxl",24},
{"[P4ris-v3rm] _SSJ_ DragonBall .rbxl",24},
{"[P4ris-v3rm] _TAC_ - Bunker Hill NEW.rbxl",24},
{"[P4ris-v3rm] _TAC_ - Harpers Island.rbxl",24},
{"[P4ris-v3rm] _TAC_ - Linebattles.rbxl",24},
{"[P4ris-v3rm] _UPD_ The Mad Murderer 2.16.16.rbxl",24},
{"[P4ris-v3rm] _V-DAY_ Sunset City.rbxl",24},]]


{"[Rika] allhailzamoraks Base 80.rbxl",24},
{"[Rika] Anaminus gravity hammer.rbxl",24},
{"[Rika] ArmoredPatrol.rbxl",24},
{"[Rika] Autumn.rbxl",24},
{"[Rika] Base for sale I.rbxl",24},
{"[Rika] Battle-For-Supremacy-Tycoon-III.rbxl",24},
{"[Rika] billiland reverse time.rbxl",24},
{"[Rika] Blazing man v3.1.8 (2).rbxl",24},
{"[Rika] Blockcraft.rbxl",24},
{"[Rika] Build a Raft and Sail TO YOUR DOOOOOM! .rbxl",24},
{"[Rika] Call of ROBLOXia Black Ops.rbxl",24},
{"[Rika] Choices - GollyGreg.rbxl",24},
{"[Rika] ClientSetsToolbox.rbxl",24},
{"[Rika] CrashCanyon.rbxl",24},
{"[Rika] Creed.rbxl",24},
{"[Rika] Death Patrol.rbxl",24},
{"[Rika] dodgeball - alexnewtron.rbxl",24},
{"[Rika] DodgeBall.rbxl",24},
{"[Rika] Dots by Brandonhare.rbxl",24},
{"[Rika] Dragon Ball Z Online Adventures..rbxl",24},
{"[Rika] Dragon Ball Z Online Adventures.rbxl",24},
{"[Rika] DrawingPlace.rbxl",24},
{"[Rika] DUCK - clockwork.rbxl",24},
{"[Rika] fearhq.rbxl",24},
{"[Rika] Fencing - Stolen.rbxl",24},
{"[Rika] Garnold Survival Apocalypse.rbxl",24},
{"[Rika] GGR-Capital-City-Coruscant.rbxl",24},
{"[Rika] Gravity chamber.rbxl",24},
{"[Rika] Hide and seek - Lance7.rbxl",24},
{"[Rika] Holewall.rbxl",24},
{"[Rika] Immortals - NEMESlS - Alakazard.rbxl",24},
{"[Rika] Jail break - StickMasterLuke.rbxl",24},
{"[Rika] Jeopardy.rbxl",24},
{"[Rika] jepordy - alexnewtron.rbxl",24},
{"[Rika] Laser Tanks 2.0.rbxl",24},
{"[Rika] Last 1 Alive.rbxl",24},
{"[Rika] Last1Alive.rbxl",24},
{"[Rika] Lighting Intervals - Dignity.rbxl",24},
{"[Rika] MarioKarts.rbxl",24},
{"[Rika] Mega Fun _ Easy Obby! _250_.rbxl",24},
{"[Rika] NaturalDisasters3v2.rbxl",24},
{"[Rika] NoobTrapOne.rbxl",24},
{"[Rika] Oasis - Samacado.rbxl",24},
{"[Rika] Oysi camera 1.rbxl",24},
{"[Rika] Oysi camera 2.rbxl",24},
{"[Rika] Oysi scrambling.rbxl",24},
{"[Rika] Oysi93 Gravity Cube.rbxl",24},
{"[Rika] Perilous Skys - crazyman32.rbxl",24},
{"[Rika] Perlious Skies.rbxl",24},
{"[Rika] Place1.rbxl",24},
{"[Rika] Place10.rbxl",24},
{"[Rika] Place13.rbxl",24},
{"[Rika] Place14.rbxl",24},
{"[Rika] Place15.rbxl",24},
{"[Rika] Place18.rbxl",24},
{"[Rika] Place19.rbxl",24},
{"[Rika] Place2.rbxl",24},
{"[Rika] Place212.rbxl",24},
{"[Rika] Place22.rbxl",24},
{"[Rika] Place28.rbxl",24},
{"[Rika] Place3.rbxl",24},
{"[Rika] Place4.rbxl",24},
{"[Rika] Place5.rbxl",24},
{"[Rika] Place6.rbxl",24},
{"[Rika] Place7.rbxl",24},
{"[Rika] Place8.rbxl",24},
{"[Rika] Place9.rbxl",24},
{"[Rika] PoolParty.rbxl",24},
{"[Rika] Rainbow Obby.rbxl",24},
{"[Rika] Roblox Battle.rbxl",24},
{"[Rika] Roblox Building.rbxl",24},
{"[Rika] ROBLOX evil game idk - stolen.rbxl",24},
{"[Rika] ropictionary - alexnewtron.rbxl",24},
{"[Rika] Sandbox BC version.rbxl",24},
{"[Rika] SCR Base.rbxl",24},
{"[Rika] Shrine of the Fallen Hero - Minish.rbxl",24},
{"[Rika] Solar Star Cafe.rbxl",24},
{"[Rika] SP - GollyGreg.rbxl",24},
{"[Rika] Stranded - crazyman32.rbxl",24},
{"[Rika] Survive The 90 Disasters.rbxl",24},
{"[Rika] Survive The DrakkoBloxxers.rbxl",24},
{"[Rika] Sword Fighting Tournament.rbxl",24},
{"[Rika] Teapots of doom - clockwork.rbxl",24},
{"[Rika] The Legente Airship.rbxl",24},
{"[Rika] TheGamer101.rbxl",24},
{"[Rika] TheGamer101s place 10-22-2011.rbxl",24},
{"[Rika] TheLittleMen.rbxl",24},
{"[Rika] TowerDefence.rbxl",24},
{"[Rika] Tropical Obby.rbxl",24},
{"[Rika] Turkey Hunt 2011 - ROBLOX.rbxl",24},
{"[Rika] UnderwaterObby.rbxl",24},
{"[Rika] Urban Warfare.rbxl",24},
{"[Rika] Vhetration Tag.rbxl",24},
{"[Rika] Virde Cova - Stolen.rbxl",24},
{"[Rika] wheel of fortune - alexnewtron.rbxl",24},
{"[Rika] WIJ Training facility skywards.rbxl",24},
{"[Rika] Zombie Defence III.rbxl",24},
{"[Rika] ZombieSurvival Build.rbxl",24},



{"[P4ris-Fav] 2007 Chaos Canyon.rbxl",24},
{"[P4ris-Fav] BEST WORKING 2008 Chaos Canyon.rbxl",24},
{"[P4ris-Fav] Big Slide.rbxl",24},
{"[P4ris-Fav] Cool 2008 Fighting Hangout.rbxl",24},
{"[P4ris-Fav] Planes Trains.rbxl",24},
{"[P4ris-Fav] ROBLOX Bowling.rbxl",24},
{"[P4ris-Fav] SlideDownTheCityInABox.rbxl",24},
{"[P4ris-Fav] Survive the Spheres Whimee.rbxl",24},
{"[P4ris-Fav] Ultimate Build Whimee Grief-proof.rbxl",24},

{"[RUIN] BlockcraftReborn.rbxl",15},
--{"[P4ris] Mega Sex Place by escog V2.rbxl",24,nil,true},
--{"[P4ris] RobloxSexPlaceXML.rbxl",24,nil,true},
{"[Pieperson50] Survive a Tsunami.rbxl",24},
{"[P4ris] Town of ROBLOXia.rbxl",24},
{"[P4ris] Train Two.rbxl",24},
{"[P4ris] Two Player War Tycoon.rbxl",24},
{"[P4ris] Vidre Cova.rbxl",24},
{"[P4ris] Welcome to the City of ROBLOXia - 1dev2.rbxl",24},
{"[P4ris] Super Mario 64 Online.rbxl",24},
{"[P4ris] SuperMario444 GTConstruct Version 2.rbxl",24},
{"[P4ris] Surv 303.rbxl",24},
{"[P4ris] Survival Island.rbxl",24},
{"[P4ris] Sword Fights On The Heights RBLXDEV.rbxl",24},
{"[P4ris] The Underground War.rbxl",24},
{"[P4ris] RetroFloodEscape.rbxl",24},
{"[P4ris] Roblox Church.rbxl",24},
{"[P4ris] ROBLOX Mall - No Tycoon.rbxl",24},
{"[P4ris] ROBLOX Ware.rbxl",24},
{"[P4ris] simpletonnn_s hangout.rbxl",24},
{"[P4ris] Six Flags.rbxl",24},
{"[P4ris] Obby from Robloxian Television.rbxl",24},
{"[P4ris] Old Pinewood Computer Core.rbxl",12},
{"[P4ris] Old Zombie Survival 2013.rbxl",24},
{"[P4ris] Paintball Daxter33.rbxl",24},
{"[P4ris] Person299 Minigames.rbxl",24},
{"[P4ris] Pinball Wizards!.rbxl",24},
{"[P4ris] Raise a Dragon.rbxl",24},
{"[P4ris] Reason 2 Die.rbxl",24},
{"[P4ris] Minigame Mania.rbxl",24},
{"[P4ris] Natural Disaster Survival.rbxl",24},
{"[P4ris] Nintendo Minigames.rbxl",24},
{"[P4ris] Galleons.rbxl",24},
{"[P4ris] Hat Factory Tycoon.rbxl",24},
{"[P4ris] Hide And Seek XL Living Spaces.rbxl",24},
{"[P4ris] Brick Infection.rbxl",24},
{"[P4ris] Build to Survive.rbxl",24},
{"[P4ris] Chaos Canyon Zombie Gun Fight.rbxl",24},
{"[P4ris] Classic 2007.rbxl",24},
{"[P4ris] Classic Dodge The Teapots of Doom.rbxl",24},
{"[P4ris] Destroy the Simpsons.rbxl",24},
{"[P4ris] Disaster Hotel 2011.rbxl",24},
{"[P4ris] Disaster Hotel.rbxl",24},
{"[P4ris] Freeze Tag.rbxl",24},
{"[P4ris] 2006 Community Construction.rbxl",24},
{"[P4ris] 2008 BrickBattle.rbxl",24},
{"[P4ris] 2008 Heli-Wars Desert Attack.rbxl",24},
{"[P4ris] 2008 Ultimate Paintball.rbxl",24},
{"[P4ris] 2009 House.rbxl",24},
{"[P4ris] 2010 Happy Home in Robloxia.rbxl",24},
{"[P4ris] ADIO Skatepark.rbxl",24},
{"[P4ris] Basic Ultimate Build.rbxl",24},
{"[Whimee] Survive the Disasters V7.rbxl",24},
{"Get Beaned By Cloudflare.rbxl",24},
{"Work at a Pizza Place.rbxl",24},
{"(2007) Blastfungus.rbxl",12},
{"(2007) Grand Melee (FINAL ROUND).rbxl",12},
{"(2008) Castle Warfare.rbxl",12},
{"(2008) Elemental Lake.rbxl",12},
{"(2008) Emerald Forest.rbxl",12},
{"(2008) Four Towers Bridge Battle.rbxl",12},
{"(2008) Martain Invasion.rbxl",12},
{"(2008) Ninjas VS Samuri Pagoda Battle.rbxl",12},
{"(2008) Orignal RASA Rocket.rbxl",12},
{"(2008) Roblox HQ 2.0.rbxl",12},
{"(2008) ROBLOX World Headquarters.rbxl",12},
{"(2008) Whising Castle.rbxl",12},
{"(2009) Bouncy Baseplate.rbxl",12},
{"(2009) Builderman Suite.rbxl",12},
{"(2009) Huge Baseplate.rbxl",12},
{"(2009) Minigame Mania.rbxl",12},
{"(2009) The Wild West.rbxl",12},
{"(2010) Grow And Raise EPIK DUCK!.rbxl",12},
{"(2011) The Lazer Tag Arena.rbxl",12},
{"(2011, Slightly Broken) Become a Computer Program.rbxl",12},
{"(2012) Build To Survive Zombies.rbxl",12},
{"(2012) Mine Tycoon.rbxl",12},
{"(2012) Natrual Diaster Survival.rbxl",12},
{"(2012) Ride A Rocket To The Moon SSA Space.rbxl",12},
{"(2012) Survive the Epic Disasters.rbxl",24},
{"(2012)Noob Destruction Facility 3.rbxl",12},
{"(2013) Flood Escape.rbxl",12},
{"(2013) Protect Telemon from zombies.rbxl",12},
{"(2013) Reason to Die.rbxl",12},
{"(2013) Zombies Are Attacking KFC!.rbxl",12},
{"(2014) Avert One.rbxl",12},
{"(2014) EmpireBay.rbxl",12},
{"(2014) Nemisis Quest Alpha.rbxl",12},
{"(2014) The Lazer Tag Arena.rbxl",12},
{"(2015) Destruction Run!.rbxl",12},
{"(2016) Classic Chaos Canyon.rbxl",12},
{"(2016) Classic Happy Home In Robloxia.rbxl",12},
{"(2017) Area 51 Zombie Infection!.rbxl",12},
{"(2017) Bungee Jump, AKA Hanger.rbxl",12},
{"(2017) Survival 404 (Open Source).rbxl",12},
{"FINOBEBuild.rbxl",24},
{"Raise an Epik Duck Remade.rbxl",24}
}

local usergames={} -- blank ;)

local storage=game.Lighting

local phphost="http://www.nickoakzhost.nigga/mngsvr.php?";

function HttpGet(x,y)
	local y=y or false;
	print("--")
	print("x-"..phphost..x.."&tick="..math.floor(tick()).."-x")
	print("--")
	return _G.HttpGet(phphost..x.."&tick="..math.floor(tick()),y)
end 

function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end 

function AttachRefreshModule(x,y,z)
	--x = item selector
	--y = game parent
	--z = script selector (avoid using)
	game.Debris:AddItem(x,100)
	
	--set new comment data
	if y:findFirstChild("comments")==nil then
		local x=Instance.new("StringValue",y)
		x.Name="comments"
	end
	y.comments.Value=GetComments(y.Name)
	
	--set new vote data
	--GetVotes(y.Name)
	if y:findFirstChild("votes")==nil then
		local x=Instance.new("StringValue",y)
		x.Name="votes"
	end
	y.votes.Value=HttpGet("s=getvotes&file="..urlencode(y.Name))
	
	--game running
	--GetVotes(y.Name)
	if y:findFirstChild("Running")==nil then
		local x=Instance.new("BoolValue",y)
		x.Name="Running"
	end 
	y.Running.Value=isFileRunning(y.Name)
	
	--set stable data
	--set new vote data
	--GetVotes(y.Name)
	if y:findFirstChild("stabledata")==nil then
		local x=Instance.new("StringValue",y)
		x.Name="stabledata"
	end
	y.stabledata.Value=HttpGet("s=getgamestable&file="..urlencode(y.Name))
	
	
	wait()
	x.Value=true
end 

--storage.gameAllData:ClearAllChildren()

local zzzzz=Instance.new("Message",workspace)
zzzzz.Text="gameService is processing game entrys"
for i,v in ipairs(games) do
	if storage.gameData:findFirstChild(v[1])==nil then
		local x=Instance.new("NumberValue",storage.gameData)
		x.Name=v[1]
		x.Value=i
	else
		storage.gameData[v[1]]:ClearAllChildren()
	end 
	local x=storage.gameData[v[1]]
	local xe=Instance.new("NumberValue",x)
	xe.Name="MaxPlayers"
	xe.Value=v[2]
	local xe=Instance.new("BoolValue",x)
	xe.Name="NSFW"
	if v[4]~=nil and v[4]==true then
		xe.Value=true
	else
		xe.Value=false
	end 
	local xe=Instance.new("BoolValue",x)
	xe.Name="usergame"
	xe.Value=false
	local xe=Instance.new("BoolValue",x)
	xe.Name="RefreshHandle"
	xe.Value=false
	if x:findFirstChild("votes")==nil then
		local xz=Instance.new("StringValue",x)
		xz.Name="votes"
		xz.Value=HttpGet("s=getvotes&file="..urlencode(x.Name))
		if math.random(1,50)==1 then
			wait()
		end 
	end
	do
		local x=x
		xe.ChildAdded:connect(function(xz)
			AttachRefreshModule(xz,x,v[1])
		end)
	end 
end 
zzzzz:Remove()

function checkSpamPrevention(a,b) --a=last ran tick,b=how long.
	if tick() > a+b then
		return true
	else
		return false
	end 
end 

function wfc(x,c)
	local tix=0
	while wait() and x:findFirstChild(c)==nil and tix<300 do
		tix=tix+1
		if tix>60 and tix<100 then
			print("tix-sH- waiting for "..c.." for a while now..")
			tix=101
		end
	end
end 

function explode(div,str)
  local str=tostring(str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end

--

storage.clientLogs.ChildAdded:connect(function(x)
	--pcall(function()
		print("CL- "..x.Value)
	--end)
	--pcall(function()
		x:Remove()
	--end)
end)

--requestcache method
---game = number in table
---name = name of player
---settings = wip?
----admin, combat, social, max players...

function isFileRunning(a) --is file running
	local x=HttpGet("s=isrunning&file="..urlencode(a))
	if x=="Server isn't running" then
		print("good-file isn't running")
		return false
	else
		print("isFileRunning func> "..x)
		return true
	end 
end
function newWebServer(a,b,c,d,e,f) --get a webserver. 'gamename' 'version' 'maxplayers' 'serverport'
	return HttpGet("s=newfinobeserver&servername="..urlencode(a).."&version="..b.."&maxplayers="..c.."&serverport="..d.."&hidden="..tostring(e).."&desc="..urlencode(f))
end
function newInstance(a,b,c,d,e,f) --start an instance. 'dofile from web', 'filename', 'adminname'
	return HttpGet("s=startinstance&server="..urlencode(a).."&file="..urlencode(b).."&version="..c.."&giveadmin="..urlencode(d).."&gameinstance="..e.."&authorizesave="..tostring(f))
end 
function isRunning() --number of running servers
	return HttpGet("s=running")
end
function isAHKon() --is autohotkey currently busy
	local xz=HttpGet("s=isahkon")
	if xz:sub(1,7)=="AHK off" then
		return false
	else
		print("OM FUCK ME : ```".. xz:sub(1,7) .."```")
		print("isAHKon func> `"..xz.."`")
		return true
	end 
end 

--[[
function refreshUploadedGamesList()
	local datax=HttpGet("s=getusergames",true)
	local xgames={};
	storage.uploadedUserGames:clearAllChildren()
	pcall(function()
		datax=JSON:decode(datax)
		for i,v in ipairs(datax) do
			xgames[v.gamefile]={
				owner=v.owner;
				gamefile=v.gamefile;
				firstadmin=v.firstadmin;
				ingamesave=v.ingamesave;
				admins=v.admins
			}
			local x=Instance.new("StringValue",storage.uploadedUserGames)
			x.Name=v.gamefile
			local xx=Instance.new("BoolValue",x)
			xx.Name="ingamesave"
			xx.Value=v.ingamesave.tonumber()
		end 
	end)
	usergames=xgames;
end 
refreshUploadedGamesList();]]

local detixex=tick()

function InstanceRequest(x)
	if not _G.HttpGet then
		print("Wheres HttpGet?")
	end 
	local isUserGame=false
	if x.Name=="startMyUserServer" then
		isUserGame=true
	end 
	print("Wee?")
	wfc(x,"status")
	wfc(x,"requestversion")
	wfc(x,"creator")
	local creatorname=x.creator.Value.Name
	local gamesel=tonumber(x.Value)
	do
		local duba=0
		while x.Value==0 do
			duba=duba+1
			wait(.1)
			if duba>150 and duba<500 then
				print("SH-value wont change!!!")
				duba=999
			end 
		end 
	end
	
	local gamepath=storage.gameData[gamesel]
	
	local xgameinfoa=gamesel; --game file
	local xgameinfob=gamepath.MaxPlayers.Value; --game max players
	local xgameinfoc="none"; --games[gamesel][3]; --uh ok
	local xgameinfod=false; -- theres no more nsfw   games[gamesel][4];
	local xgameinfoe=false; -- pbs wont be back for now.... games[gamesel][5];
	
	print("Going to start hosting game "..xgameinfoa.."!")
	local status=x.status
	--games[gamesel][1]
	
	local xoos=isFileRunning(xgameinfoa)
	local isahk=isAHKon()
	print("isRunning > ")
	if isFileRunning(xgameinfoa)==true then
		status.Value="failalreadyrunning"
		return nil
	else
		local isahk=isAHKon()
		if isahk==true then
			print("SH reported AHK as ".. tostring(isAHKon()))
			status.Value="failbusy"
			return nil
		else
			local howmanyrunnin=isRunning()
			if tonumber(howmanyrunnin)>12 then --howmanyserverauth--allow how many servers--how many running servers
				status.Value="failmaxservers"
				return nil
			else
				nextport=nextport+1
				if nextport>portrange[2] then
					nextport=portrange[1]
				end 
				status.Value="loggingin"
				--checking site login
				wait(.5)
				--done?
				local gamename=xgameinfoa:sub(1,-6)
				local version=x.requestversion.Value
				local maxplayers=xgameinfob
				local hidden=false
				print("Hidden false?")
				if xgameinfod~=nil and xgameinfod==true then
					hidden=true
					print("NO. BE HIDDEN!")
				end 
				status.Value="siteinstance" --"Requested server starting(Getting new website server)"
				wait(.5)
				
				local isgameapbs=false
				local pbsowner=""
				if xgameinfoe~=nil then
					isgameapbs=true
					pbsowner=xgameinfoe
					creatorname=pbsowner
				end 
				
				local fullname=gamename .. " ("..creatorname..")"
				local finalname=fullname
				if isgameapbs==true then
					fullname=gamename .. " -as-"
					if #gamename + 3 + 4 > 58 then
					  print("need to tighten!")
					  local gamecreatorx=explode("]",gamename)
					  if gamecreatorx[2]~=nil then
						local gamecreator=gamecreatorx[1]:sub(2)
						local gamenames=gamecreatorx[2]
						if gamenames:sub(1,1)==" " then
						  gamenames=gamecreatorx[2]:sub(2)
						end 
						print("Game Creator: "..gamecreator)
						print("Game Name: "..gamenames)
						local gamecreator=gamecreator:sub(1,6)
						finalname="["..gamecreator.."~] "..gamenames.." -as-"
						if #finalname>58 then
						  print("Still too long!!!")
						  finalname="!"..finalname:sub(1,56)
						end 
					  else
						finalname=gamename.." -as-"
						if #finalname>58 then
						  finalname=gamename:sub(1,58-12) .."~ -as-"
						end 
					  end 
					end 
				else 
					if #gamename + 3 + #creatorname > 58 then
					  print("need to tighten!")
					  local gamecreatorx=explode("]",gamename)
					  if gamecreatorx[2]~=nil then
						local gamecreator=gamecreatorx[1]:sub(2)
						local gamenames=gamecreatorx[2]
						if gamenames:sub(1,1)==" " then
						  gamenames=gamecreatorx[2]:sub(2)
						end 
						print("Game Creator: "..gamecreator)
						print("Game Name: "..gamenames)
						local gamecreator=gamecreator:sub(1,6)
						finalname="["..gamecreator.."~] "..gamenames.." (".. creatorname ..")"
						if #finalname>58 then
						  print("Still too long!")
						  local creatorname=creatorname:sub(1,6)
						  finalname="["..gamecreator.."~] "..gamenames.." (".. creatorname .."~)"
						  if #finalname>58 then
							print("Still too long!!")
							local gamenames=gamenames:sub(1,37)
							finalname="["..gamecreator.."~] "..gamenames.."~ (".. creatorname .."~)"
							if #finalname>58 then
							  print("Still too long!!!")
							  finalname="!"..finalname:sub(1,56)
							end 
						  end 
						end 
					  else
						finalname=gamename.." (" .. creatorname:sub(1,6).."~)"
						if #finalname>58 then
						  finalname=gamename:sub(1,58-12) .."~ (" ..creatorname:sub(1,6) .. "~)"
						end 
					  end 
					end 
				end 
				
				print("Requesting for a game with name > "..finalname)
				
				local getnewdofile = newWebServer(finalname,version,maxplayers,nextport,hidden,fullname)
				print("Did a server request?")
				--getnewdofile=string.gsub(getnewdofile, "n", "")
				local xe=explode([[==]],getnewdofile)
				print('-----------')
				print('-----------')
				print('-----------')
				print("Got game id > "..xe[1].." and dofile ")
				print(xe[2])
				print('-----------')
				print('-----------')
				print('-----------')
				local dofilee=xe[2]
				if dofilee==nil then
					status.Value="faildofile"
				else 
					local gameid=xe[1]
					status.Value="dofile"..dofilee:sub(1,12) --"Requested server starting(WebServer-".. dofilee:sub(1,12) .."..)"
					xgameinfoc=string.sub(gameid,2,-2)
					wait(1)
					local runinstance = newInstance(dofilee,xgameinfoa,version,creatorname,xgameinfoc,isgameapbs)
					status.Value="startstudio"
					local ticktock=0
					local started=false
					repeat 
						local x=HttpGet("s=gamestarted&file="..xgameinfoa)
						local x=tonumber(x) or 0
						if not x then
							x=0
						end 
						if x>2 then
							--check tick.
							if (tick()) < (x+30) then
								started=true
							end 
						else
							--keep waiting...
						end 
						local xxex=(tick()+30)-x
						if xxex>1000 then
							xxex=xxex-detixex
						end 
						status.Value="startingtick".. (36-ticktock) .. "[".. tostring((tick()+30)-x)  .."]"
						wait(1.1)
						ticktock=ticktock+1
					until ticktock>36 or started==true
					if started==true then
						wait(.2)
						status.Value="pass"
						DoStableRequest(xgameinfoa,version,1)
						--do a GAME START SHOUT!
						HttpGet("s=gameshout&author=".. urlencode("inF*").."&message="..urlencode("'".. finalname .."' has just started! Say '/follow/' to join!").."&action="..urlencode(string.sub(gameid,2,-2)))
						if isUserGame then
							storage.uploadedUserGames[xgameinfoa].Running.Value=true
						else
							storage.gameAllData[gamesel].Running.Value=true
						end 
					else 
						status.Value="failtoolong"
						DoStableRequest(xgameinfoa,version,0)
					end 
				end 
				return runinstance
			end 
		end 
	end 
end 

--[[storage.serverIPHash.ChildAdded:connect(function(x)
	--local x=HttpGet("s=newfinobeserver&servername="..urlencode(a).."&version="..b.."&maxplayers="..c.."&serverport="..d)
	print("IPHashTest- "..x.Value)
	x:Remove()
end)]]

storage.serverRequestCache.ChildAdded:connect(function(x)
	--x.Value = game selection
	---requesting.Value = player that requested
	---requestversion.Value = server version requested 2007/2012
	---status.Value = status of request
	game.Debris:AddItem(x,300)
	--pcall(function()
		print("FinalStatus>"..tostring(InstanceRequest(x)))
		wait(.1)
		x.serverdone.Value=true
	--end)
end)

--[[
do --vote management
	for i,v in ipairs(storage.gameAllVotes:getChildren()) do
		v:Remove()
	end 
	for i=1,#games do
		local x=HttpGet("s=getvotes&file="..urlencode(games[tonumber(i)][1]))
		local xx=Instance.new("StringValue")
		xx.Value=tostring(x)
		xx.Name=i
		xx.Parent=storage.gameAllVotes
	end 
	refreshUploadedGamesList()
	for i,v in ipairs(usergames) do
		local x=HttpGet("s=getvotes&file="..urlencode(v.gamefile))
		local xx=Instance.new("StringValue")
		xx.Value=tostring(x)
		xx.Name=i
		xx.Parent=storage.gameAllVotes
		if math.random(1,70)==1 then wait() end 
	end 
	local antispam=tick()-400; --require waiting 2 seconds each refresh.   for running server count.
	local antispamz=tick(); --require waiting 2 seconds each refresh.      for relisting votes count. ?this needed?
	local antispamzz=tick()-100; --require waiting 2 seconds each refresh. for refreshing uploaded games list.
	storage.runningServers.ChildAdded:connect(function(x)
		--just a bump from a client to refresh this.
		game.Debris:AddItem(x,15)
		--pcall(function()
			if checkSpamPrevention(antispamzz,80) then
				refreshUploadedGamesList()
			end
			if checkSpamPrevention(antispam,6) then
				antispam=tick()
				storage.runningServers.Value=tonumber(isRunning())
			end
			if checkSpamPrevention(antispamz,3400) then --is this needed anymore?
				antispamz=tick()
				for i,v in ipairs(storage.gameAllVotes:getChildren()) do
					v:Remove()
				end 
				for i=1,#games do
					local x=HttpGet("s=getvotes&file="..urlencode(games[tonumber(i)][1]))
					local xx=Instance.new("StringValue")
					xx.Value=tostring(x)
					xx.Name=i
					xx.Parent=storage.gameAllVotes
					if math.random(1,70)==1 then wait() end 
				end 
				for i,v in ipairs(usergames) do
					local x=HttpGet("s=getvotes&file="..urlencode(v.gamefile))
					local xx=Instance.new("StringValue")
					xx.Value=tostring(x)
					xx.Name=i
					xx.Parent=storage.gameAllVotes
					if math.random(1,70)==1 then wait() end 
				end 
			end
		--end)
		--pcall(function()
			x:Remove()
		--end)
	end)
end ]]

function GetStableRequest(gamesel)
	return HttpGet("s=getgamestable&file="..urlencode(gamesel))
end
function DoStableRequest(gamesel,version,stable)
	return HttpGet("s=dogamestable&file="..urlencode(gamesel).."&version="..urlencode(version).."&stable="..tostring(stable))
end

function DoVote(user,gamesel,vote)
	return HttpGet("s=addvote&file="..urlencode(gamesel).."&userid="..urlencode(user).."&vote="..tostring(vote))
end

function GetVotes(gamesel)
	local x=HttpGet("s=getvotes&file="..urlencode(gamesel))
	local xx=explode([[=]],x)
	wait()
	return {xx[1],xx[2]}
end

function GetComments(gamesel)
	return HttpGet("s=getcomments&file="..urlencode(gamesel))
end

function AddComment(user,gamesel,message)
	return HttpGet("s=addcomment&file="..urlencode(gamesel).."&userid="..urlencode(user).."&message="..urlencode(message))
end

--[[storage.gameCommentsRequest.ChildAdded:connect(function(x)
	--x.Value = game selection
	---name.Value = player that commented, objectValue
	---comment.Value = message
	x.Value=AddComment(x.name.Value.Name,x.Value,x.comment.Value)
end)]]

--[[storage.gameGetComments.ChildAdded:connect(function(x)
	--x.Value = game selection
	---return long string.
	x.Value=GetComments(x.Value)
end)

storage.gameVoteRequest.ChildAdded:connect(function(x)
	--x.Value = game selection
	---name.Value = player that voted, objectValue
	---vote.Value = 0/1 value vote
	wfc(x,"name")
	wfc(x,"vote")
	local holdvalue=DoVote(x.name.Value.Name,x.Value,x.vote.Value)
	storage.gameAllVotes[x.Value].Value=holdvalue
	x.Value=holdvalue
	--update it to the main database for each list.
end)]]

storage.teleportRequest.ChildAdded:connect(function(x)
	--x.Value = game selection
	wfc(x,"plr")
	local xz=game.Lighting.teleportReq:Clone()
	local selec=tonumber(x.Value)
	print("Game selection is ... ".. x.Value)
	print("A teleport request to go to .. " .. games[selec][1].. "!")
	print("Value should be for game .. "..games[selec][3])
	xz.gameid.Value=tonumber(games[selec][3])
	xz.Parent=x.plr.Value.Backpack
	xz.Disabled=false
	x:Destroy()
end)

--[==[storage.gameStableGet.ChildAdded:connect(function(x)
	--x.Value = game selection
	local votes=GetStableRequest(x.Value)
	print("I got for results - "..votes)
	x.Value=votes
end)

storage.gameGetVotes.ChildAdded:connect(function(x)
	--x.Value = game selection
	wfc(x,"votey")
	wfc(x,"votes")
	local vote=GetVotes(x.Value)
	--undo, cuz u fuck up nicko
	--skip the slow process of getting current vote data and instead keep it current live.
	print("I got for votey > "..vote[1].." and for votes > "..vote[2])
	x.votey.Value=vote[1]
	x.votes.Value=vote[2]
	wait()
	x.Value="done"
end)

storage.gameInfoRequest.ChildAdded:connect(function(x)
	--x.Value = game selection
	---requesting.Value = player that requested
	---status.Value = status of request  "false"==waiting "true"==done
	--wfc(x,"requesting")
	wfc(x,"status")
	wfc(x,"serverrunning")
	--wfc(x,"votes")
	--wfc(x,"comments")
	---reply with,
	----serverrunning.Value = string = server running?
	----game desc = string = game desc
	game.Debris:AddItem(x,300)
	--pcall(function()
		print("Getting game value .." .. x.Value)
		local xrunnin=isFileRunning(games[x.Value][1])
		if xrunnin==true then
			x.serverrunning.Value="Server is running"
			if storage.gameAllData[games[x.Value][1]]:findFirstChild("Running")==nil then
				local x=Instance.new("BoolValue",storage.gameAllData[games[x.Value][1]])
				x.Name="Running"
				x.Value=true
			else
				storage.gameAllData[games[x.Value][1]].Running.Value=true
			end 
		else
			x.serverrunning.Value="Server isn't running"
			if storage.gameAllData[games[x.Value][1]]:findFirstChild("Running")==nil then
				local x=Instance.new("BoolValue",storage.gameAllData[games[x.Value][1]])
				x.Value=false
			else
				storage.gameAllData[games[x.Value][1]].Running.Value=false
			end 
		end 
		wait(.1)
		x.status.Value="done"
	--end)
end)]==]





---start chat gui manager


do

pcall(function()
	local x=Instance.new("LocalScript",game:getService("StarterGui"))
	x.Name="chatui"
	x.Source=game:HttpGet('http://www.nickoakzhost.nigga/chatui.lua?v='..math.floor(tick()),true)
end)

function _G.HttpGet(site,x)
	local x=x or true;
	--local a,b=pcall(function()
		return game:HttpGet(site,x)
	--end)
	--[[if a then
		return b
	else
		return "error"
	end ]]
end 

function _G.HttpPost(site) 
	--pcall(function()
		return game:HttpPost(site)
	--end)
end 

function explode(div,str)
  local str=tostring(str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end

print("Wave! Its nicko's server script! v205")


local gameteleportid=12334
do 
	local phphost="http://www.nickoakzhost.nigga/mngsvr.php?";

	local function HttpGet(x)
		print("--")
		print("x-"..phphost..x.."&tick="..math.floor(tick()).."-x")
		print("--")
		return _G.HttpGet(phphost..x.."&tick="..math.floor(tick()),true)
	end 
	
	local function plrMSG(p,m)
		pcall(function()
			local x=Instance.new("Message",p.PlayerGui)
			x.Text=m
			game.Debris:AddItem(x,6)
		end)
	end 
	local shoutcooldown=0
	function msg(p,m)
		print("NSS-Player "..p.Name.." chatted '"..m.."'")
		if m:sub(2,4)=="hub" or m:sub(2,5)=="back" or m:sub(2,7)=="server" then
			print("Requested to go to hub.")
			plrMSG(p,"Already at the hub..")
		elseif m:sub(2,7)=="follow" then
			print("Requested to follow new game.")
			plrMSG(p,"~ follow game request ~")
			pcall(function()
				local xz=game.Lighting.teleportReq:Clone()
				xz.gameid.Value=gameteleportid
				xz.Parent=p.Backpack
				xz.Disabled=false
			end)
		elseif m:sub(1,3)=="dab" then
			print("Did a dab!")
			plrMSG(p,"Can't dab here..")
		elseif m:sub(2,6)=="respaw" or m:sub(2,9)=="loadchar" or m:sub(2,5)=="gone" then
			print("Did a respawn!")
			pcall(function()
				p:LoadCharacter()
			end)
		elseif m:sub(2,9)=="comment/" then
			plrMSG(p,"Can't comment the hub.")
		elseif m:sub(2,6)=="vote/" then
			plrMSG(p,"Can't vote the hub.")
		elseif m:sub(2,7)=="shout/" then
			if shoutcooldown+15>math.floor(tick()) then
				plrMSG(p,"Someone recently shouted, sorry. Try again soon.")
			else
				shoutcooldown=math.floor(tick())
				local msg=m:sub(8,508)
				if m:sub(509)~="" then
					msg=msg.."..."
				end 
				HttpGet("s=gameshout&author="..urlencode("["..p.Name.."] shouted ") .."&message="..urlencode(msg))
				plrMSG(p,"Shouted your message to all games!")
			end 
		end 
	end 
end 

game.Players.ChildAdded:connect(function(x)
	if x.className=="Player" then
		x.Chatted:connect(function(m)
			msg(x,m)
		end)
	end 
end)

for i,x in ipairs(game.Players:getChildren()) do
	if x.className=="Player" then
		x.Chatted:connect(function(m)
			msg(x,m)
		end)
	end 
end 

coroutine.resume(coroutine.create(function()
	local funfacts={
		"Saying 'dab' is wrong, and is against our religion!",
		"Ever need to go back to the hub? Just say '/back' or '/servers'!",
		"Every day, an update is always done to the inF* hub and its games!",
		"RServer used to not 'turn off' even if you turned it off as a game setting!",
		"Don't worry, NSFW games are coming soon to the hub, shh, be quiet!",
		"You may not notice, but we modified the 'Networking' settings for our hub for the best preformance!",
		"I'm sure you noticed by now, that physics are tenfold as better than it was in old roblox.",
		"If you ever have a command suggestion, ask Nickoakz on discord or send him a DM!",
		"Something not right? Hub isn't working? Send Nickoakz a message...",
		"You want your game hosted on our hub? Send your files to Nickoakz on the Finobe Discord over DM!",
		"We take command suggestions, if you have any fun idea for what you want in the future!",
		"Slappy is both 'good' and a 'meat beater' for sure!!",
		"If you even noticed, that you can only run, at most, only 12 servers. The hub is also a 'server'. Will increase never...",
		"See a game exploited? Start and Keep video footage!; our community is that small, that they'll get banned fast!",
		"Even if you're not a game developer or know anything about development, being here to this game and its hub HELPS!",
		"/vote/1 or /vote/good for a good game! bad or 0 for not. /comment/message for comments too!",
		"/shout/INF* IS GREAT! Shout your messages to every game today!",
		"What makes Raymonf eye's burn? Woodman nood's.",
		"What makes Slappy upset? kids",
		"Woodman + Nickoakz = True Satan",
		"Not sure if you remember, but don't 'dab'",
		"Is raymonf a f u r r y? :thinking:???!",
		"Is slappy actually a trans??? :weary::weary:!!!!!!!",
		"Raining more woodman noods",
		"made by the furry, nickoakz.",
		"Never gunna give you up, never gunna let raymonf down ~~.",
		"PSA: Stop 'dab'ing today! It kills!!"
	}

	local phphost="http://www.nickoakzhost.nigga/mngsvr.php?";
	local function HttpGet(x)
		print("--")
		print("x-"..phphost..x.."&tick="..math.floor(tick()).."-x")
		print("--")
		return _G.HttpGet(phphost..x.."&tick="..math.floor(tick()),true)
	end 
	local xe=game:getService("Lighting"):findFirstChild("ChatUI")
	if xe==nil then
		xe=Instance.new("Model",game:getService("Lighting"))
		xe.Archivable=false
		xe.Name="ChatUI"
	end 
	local function SendMessage(n,m)
		local xe=game:getService("Lighting"):findFirstChild("ChatUI")
		if xe==nil then
			xe=Instance.new("Model",game:getService("Lighting"))
			xe.Archivable=false
			xe.Name="ChatUI"
		end 
		
		local ma=Instance.new("StringValue")
		ma.Name=n
		ma.Value=m
		ma.Parent=xe
		game.Debris:AddItem(ma,400)
	end 
	game.Players.ChildAdded:connect(function(x)
		if x.className=="Player" then
			SendMessage("inF*","Player '"..x.Name.."' has joined!")
		end 
	end)
	game.Players.PlayerRemoving:connect(function(x)
		if x.className=="Player" then
			SendMessage("inF*","Player '"..x.Name.."' has left!")
		end 
	end)

	coroutine.resume(coroutine.create(function()
		print("[inF* MESSAGE GUI] running.")
		local funfacx=85
		local function FunFactsss()
			local rando=math.random(1,#funfacts)
			SendMessage("inF*",funfacts[rando])
			delay(funfacx,FunFactsss)
		end
		delay(funfacx,FunFactsss)
	end))
	do
		local donetick={}
		while wait(12) do --globalshout checks
			wait()
			local jsons=HttpGet("s=getgameshouts")
			local tabledata=JSON:decode(jsons)
			for i,v in ipairs(tabledata) do
				if not donetick[v.tick] then
					donetick[v.tick]=true;
					print("Received new message ".. tostring(v.author).." : ".. tostring(v.message))
					SendMessage(v.author,v.message)
					if v.action then
						gameteleportid=v.action
						print("Got a new game teleport action!")
					end 
				end 
			end 
			wait()
		end 
	end 
end))









end 

--------loadstring(game:HttpGet("http://www.nickoakzhost.nigga/serverscripthub.lua?tick="..math.floor(tick()),true))() 

