coroutine.resume(coroutine.create(function()
--[==[pcall(function()
local x=Instance.new("LocalScript",game:getService("StarterPack"))
x.Name="ChatGuiDisabler"
x.Source=[[
game.Players:SetChatStyle("Bubble")
]]
end)]==]
--when this does nothing to your game..
pcall=ypcall; --cuz roblox sucks; :>
local keephistory=tostring(_G.file)
local authorizesaving=tostring(_G.saveNSHkeyakgajjksdkfjajgke)
print("Save _G is ",_G.saveNSHkeyakgajjksdkfjajgke)
if authorizesaving~=nil and authorizesaving=="true" then
	authorizesaving=true
	print("Authorizing is true!")
else
	authorizesaving=false
end 
local autosaving=false
--local gameid=tonumber(_G.jobid)
local gSendMSG=function() end
local keepgameinstance=tostring(_G.gameinstance)
local nshadmins={}
local letrserverhandle={}
if _G.giveadmin~=nil then
	if authorizesaving==true then
		nshadmins[_G.giveadmin]=3;
	else
		nshadmins[_G.giveadmin]=2;
	end 
end 
if _G.owner~=nil then
	nshadmins[_G.owner]=3;
end 
local banned={"KurtCobain"}
local rserveradmins={"Raymonf","kinery","davi","winsupermario1234","Niall","P4risAndStuff","Kinery","Ahead","Whimee","KayKayKo","khanglegos","kmaheynoway","splat","rick","chromeadders","spritesight","DirtPiper","Bitl","connor","Mariodylan","Hippit","~Machine-senpai","miksa","Ruin","OliverA","pydlv","Shenzhou","DoritoMcDew","LuaOwl","blockity7","Tai","mongodbiswebscale","gothboy385","Woodman","NikeBoy"}
local users={
{"Raymonf",3},
{"Nickoakz",3},
{"Woodman",3},
{"Ruin",3},
{"~Machine-senpai",3},
{"Computer",3},
} 
for a=1,#rserveradmins do
	nshadmins[rserveradmins[a]]=3;
	letrserverhandle[rserveradmins[a]]=true;
end 
for a=1,#users do
	nshadmins[users[a][1]]=users[a][2]
end 
do
	local bancache={};
	for a=1,#banned do
		bancache[banned[a]]=true
	end 
	banned=bancache
end 
 
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
--
--                 Added the "stringsAreUtf8" encoding option. (Hat tip to http://lua-users.org/wiki/JsonModules )
--
--   20141223.14   The encode_pretty() routine produced fine results for small datasets, but isn't really
--                 appropriate for anything large, so with help from Alex Aulbach I've made the encode routines
--                 more flexible, and changed the default encode_pretty() to be more generally useful.
--
--                 Added a third 'options' argument to the they had been stupidly separate,
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

--add admins
if _G.admins~=nil and _G.admins~="none" then
	pcall(function()
		local xdata=JSON.decode(_G.admins)
		pcall(function()
			for a=1,#xdata do
				nshadmins[xdata[a]]=2;
			end 
		end)
	end)
end 

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
function gameSaveRequest()
	if authorizesaving==true then
		game:HttpGet("http://www.nickoakzhost.nigga/mngsvr.php?s=savereq&file=" .. urlencode(keephistory).."&tick="..math.floor(tick()).."-x")
	end 
end 
function logScriptUsage(name,script)
	game:HttpPost("http://www.nickoakzhost.nigga/mngsvr.php?s=scriptuse&game=" .. urlencode(keephistory).."&user=".. urlencode(name) .."&tick="..math.floor(tick()).."-x",script)
end 
print("Wave! Its nicko's server script! v315")
gSendMSG=nil;
--commands service
do	
print("nshdebug-stage1run")
	local cPcall = function(func,...) 
		local function cour(...)
			coroutine.resume(coroutine.create(func),...) 
		end 
		local ran,errors = ypcall(cour,...) 
		if errors then 
			warn(errors) 
			gSendMSG("inF*","cPcall fatal. [".. errors .."]")
		end 
	end
	local Routine = cPcall;
	--[[local Routine = function(func,...)  
		coroutine.resume(coroutine.create(func),...)
	end]]
	local service={}
	service.PlayerTableToString=function(tab)
		local result=""
		for a=1,#tab do
			if result=="" then
				result=tostring(tab[a].Name)
			else
				result=result..", "..tostring(tab[a].Name)
			end 
		end 
		return result
	end 
	service.GetPlayers = function(plr,arg)
		local lists=explode(",",arg)
		local result={}
		local dontadd={}
		local players=game.Players:getChildren()
		for aa=#lists,1,-1 do
			if lists[aa]=="all" then
				for a=1,#players do
					table.insert(result,players[a])
				end 
				table.remove(lists,aa)
			elseif lists[aa]:sub(1,1)=="-" then
				for aa=1,#lists do
					if players[a].Name:lower():sub(1,#arg)==lists[aa]:sub(2) then
						table.insert(dontadd,players[a])
					end 
				end 
				table.remove(lists,aa)
			elseif lists[aa]=="me" then
				table.insert(result,plr)
				table.remove(lists,aa)
			elseif lists[aa]=="random" or lists[aa]=="rand" then
				local x=game.Players:getPlayers()
				table.insert(result,x[math.random(1,#x)])
				table.remove(lists,aa)
			elseif lists[aa]=="others" then
				for a=1,#players do
					if players[a].Name~=plr.Name then
						table.insert(result,players[a])
					end 
				end 
				table.remove(lists,aa)
			end 
		end 
		for a=1,#players do
			for aa=1,#lists do
				if players[a].Name:lower():sub(1,#arg)==lists[aa]:lower() then
					table.insert(result,players[a])
				end
			end 
		end 
		for a=#result,1,-1 do
			for aa=1,#dontadd do
				if result[a].Name==dontadd[aa].Name then
					table.remove(result,a)
				end 
			end 
		end 
		return result
	end 
	service.New=function(class,data) 
		local new = Instance.new(class) 
		if data then 
			if type(data) == "table" then
				local parent = data.Parent
				data.Parent = nil
				for val,prop in pairs(data) do 
					new[val] = prop 
				end 
				if parent then
					new.Parent = parent
				end
			elseif type(data) == "userdata" then
				new.Parent = data
			end
		end
		return new 
	end;
	service.InsertService=game:getService("InsertService");
	service.Insert=function(id)
		local model = service.InsertService:LoadAsset(id)
		return model:GetChildren()[1]
	end
	service.Workspace=workspace;
	service.Players=game:getService("Players");
	service.Debris=game:getService("Debris");
	local server={};
	server.Core={};
	server.Variables={};
	server.Variables.Objects={};
	server.Settings={};
	server.Settings.Prefix="";
	server.Admin={};
	server.Admin.RunCommand=function()
		error("aaa, i've attempted to use RunCommand illegally!")
	end;
	server.Core.NewScript=function(xe,n)
		local x=Instance.new(xe) 
		x.Name="NSH-Script" 
		x.Disabled=true 
		x.Archivable=true
		local xtre=[===[ --[[nshcommand]] local nshprint=print; local xaasahahadfheed,yaaeesdaahqwerhfs=nil,nil; xaasahahadfheed,yaaeesdaahqwerhfs=ypcall(function()   loadstring( ]===]
		xtre=xtre.."[=================================================================================================================["..n.."]=================================================================================================================]"
		xtre=xtre..[===[)() end) if not xaasahahadfheed then  local x=Instance.new("StringValue") x.Name="inF*" x.Value="CrashCapture!-["..script.Name.."]-"..tostring(yaaeesdaahqwerhfs) x.Parent=game:getService("Lighting").ChatUI end ]===] 
		x.Source=xtre
		x.Disabled=false
		if game:getService("Lighting"):findFirstChild("scriptHolder")==nil then
			local m=Instance.new("Model",game:getService("Lighting"))
			m.Name="scriptHolder"
			m.Archivable=false
		end 
		x.Parent=game:getService("Lighting").scriptHolder
		return x
	end 
	print("nshdebug-stage1.1run")
	cmdserver={}
	cmdserver.CommandMatcher={}
	print("nshdebug-stage1.2run")
	cmdserver.Commands = {
		Version = {
				Prefix = server.Settings.Prefix;
				Commands = {"ver";"version";"verzion"};
				Args = {"player";};
				Hidden = false;
				Description = "Remove the target player(s)'s arms and legs";
				Fun = true;
				--AdminLevel = "Moderators";
				Function = function(plr,args)
					gSendMSG("inF*",plr.Name..".. I'm version 250! You hag..")
				end
			};
		--custom provided, no modifications test...
		Flatten = {
				Prefix = server.Settings.Prefix;
				Commands = {"flatten";"2d";"flat";};
				Args = {"player";"optional num";};
				Hidden = false;
				Description = "Flatten.";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local num = tonumber(args[2]) or 0.1	
					local function sizePlayer(p)
						local char = p.Character
						local torso = char:FindFirstChild("Torso")
						local root = char:FindFirstChild("Torso")
						local welds = {}
						torso.Anchored = true
						torso.BottomSurface = 0
						torso.TopSurface = 0
						for i,v in pairs(char:GetChildren()) do
							if v:IsA("BasePart") then
								v.Anchored = true
							end
						end
						local function size(part)
							for i,v in pairs(part:GetChildren()) do
								if (v:IsA("Weld") or v:IsA("Motor") or v:IsA("Motor6D")) and v.Part1 and v.Part1:IsA("Part") then
									local p1 = v.Part1
									local c0 = {v.C0:components()}
									local c1 = {v.C1:components()}
									c0[3] = c0[3]*num
									c1[3] = c1[3]*num
									p1.Anchored = true
									v.Part1 = nil
									v.C0 = CFrame.new(unpack(c0)) 
									v.C1 = CFrame.new(unpack(c1))
									if p1.Name ~= 'Head' and p1.Name ~= 'Torso' then
										p1.formFactor = 3
										p1.Size = Vector3.new(p1.Size.X,p1.Size.Y,num)
									elseif p1.Name ~= 'Torso' then
										p1.Anchored = true
										for k,m in pairs(p1:children()) do 
											if m:IsA('Weld') then 
												m.Part0 = nil 
												m.Part1.Anchored = true 
											end 
										end
										p1.formFactor = 3 
										p1.Size = Vector3.new(p1.Size.X,p1.Size.Y,num)
										for k,m in pairs(p1:children()) do 
											if m:IsA('Weld') then 
												m.Part0 = p1 
												m.Part1.Anchored = false 
											end 
										end
									end
									if v.Parent == torso then 
										p1.BottomSurface = 0 
										p1.TopSurface = 0 
									end
									p1.Anchored = false
									v.Part1 = p1
									if v.Part0 == torso then 
										table.insert(welds,v) 
										p1.Anchored = true 
										v.Part0 = nil 
									end
								elseif v:IsA('CharacterMesh') then
									local bp = tostring(v.BodyPart):match('%w+.%w+.(%w+)')
									local msh = service.New('SpecialMesh')
								elseif v:IsA('SpecialMesh') and v.Parent ~= char.Head then 
									v.Scale = Vector3.new(v.Scale.X,v.Scale.Y,num)
								end 
								size(v)
							end
						end
						size(char)
						torso.formFactor = 3
						torso.Size = Vector3.new(torso.Size.X,torso.Size.Y,num)
						for i,v in pairs(welds) do 
							v.Part0 = torso 
							v.Part1.Anchored = false 
						end
						for i,v in pairs(char:GetChildren()) do 
							if v:IsA('BasePart') then 
								v.Anchored = false 
							end 
						end
						local weld = service.New('Weld',root) 
						weld.Part0 = root 
						weld.Part1 = torso
						local cape = char:findFirstChild("ADONIS_CAPE")
						if cape then
							cape.Size = cape.Size*num
						end
					end
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." flatten'd ".. service.PlayerTableToString(players).." body.")
					for i,v in pairs(players) do
						sizePlayer(v)
					end
				end
			};
		OldFlatten = {
				Prefix = server.Settings.Prefix;
				Commands = {"oldflatten";"o2d";"oflat";};
				Args = {"player";"optional num";};
				Hidden = false;
				Description = "Old Flatten. Went lazy on this one.";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." classic flatten'd ".. service.PlayerTableToString(players).." body.")
					for i,v in pairs(players) do
						cPcall(function()
							for k,p in pairs(v.Character:children()) do
								if p:IsA("Part") then
									if p:FindFirstChild("Mesh") then p.Mesh:Destroy() end
									service.New("BlockMesh",p).Scale=Vector3.new(1,1,args[2] or 0.1)
								elseif p:IsA("Accoutrement") and p:FindFirstChild("Handle") then
									if p.Handle:FindFirstChild("Mesh") then
										p.Handle.Mesh.Scale=Vector3.new(1,1,args[2] or 0.1)
									else
										service.New("BlockMesh",p.Handle).Scale=Vector3.new(1,1,args[2] or 0.1)
									end
								elseif p:IsA("CharacterMesh") then
									p:Destroy()
								end
							end
						end)
					end
				end
			};
		Break = {
				Prefix = server.Settings.Prefix;
				Commands = {"break";};
				Args = {"player";"optional num";};
				Hidden = false;
				Description = "Break the target player(s)";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." broke ".. service.PlayerTableToString(players).." future.")
					for i,v in pairs(players) do
						cPcall(function()
							local head = v.Character.Head
							local torso = v.Character.Torso
							local larm = v.Character['Left Arm']
							local rarm = v.Character['Right Arm']
							local lleg = v.Character['Left Leg']
							local rleg = v.Character['Right Leg']
							for i,v in pairs(v.Character:children()) do if v:IsA("Part") then v.Anchored=true end end
							torso.FormFactor="Custom"
							torso.Size=Vector3.new(torso.Size.X,torso.Size.Y,tonumber(args[2]) or 0.1)
							local weld = service.New("Weld",v.Character.Torso)
							weld.Part0=v.Character.Torso
							weld.Part1=v.Character.Torso
							weld.C0=v.Character.Torso.CFrame
							head.FormFactor="Custom"
							head.Size=Vector3.new(head.Size.X,head.Size.Y,tonumber(args[2]) or 0.1)
							local weld = service.New("Weld",v.Character.Torso)
							weld.Part0=v.Character.Torso
							weld.Part1=head
							weld.C0=v.Character.Torso.CFrame*CFrame.new(0,1.5,0)
							larm.FormFactor="Custom"
							larm.Size=Vector3.new(larm.Size.X,larm.Size.Y,tonumber(args[2]) or 0.1)
							local weld = service.New("Weld",v.Character.Torso)
							weld.Part0=v.Character.Torso
							weld.Part1=larm
							weld.C0=v.Character.Torso.CFrame*CFrame.new(-1,0,0)
							rarm.FormFactor="Custom"
							rarm.Size=Vector3.new(rarm.Size.X,rarm.Size.Y,tonumber(args[2]) or 0.1)
							local weld = service.New("Weld",v.Character.Torso)
							weld.Part0=v.Character.Torso
							weld.Part1=rarm
							weld.C0=v.Character.Torso.CFrame*CFrame.new(1,0,0)
							lleg.FormFactor="Custom"
							lleg.Size=Vector3.new(larm.Size.X,larm.Size.Y,tonumber(args[2]) or 0.1)
							local weld = service.New("Weld",v.Character.Torso)
							weld.Part0=v.Character.Torso
							weld.Part1=lleg
							weld.C0=v.Character.Torso.CFrame*CFrame.new(-1,-1.5,0)
							rleg.FormFactor="Custom"
							rleg.Size=Vector3.new(larm.Size.X,larm.Size.Y,tonumber(args[2]) or 0.1)
							local weld = service.New("Weld",v.Character.Torso)
							weld.Part0=v.Character.Torso
							weld.Part1=rleg
							weld.C0=v.Character.Torso.CFrame*CFrame.new(1,-1.5,0)
							wait()
							for i,v in pairs(v.Character:children()) do if v:IsA("Part") then v.Anchored=false end end
						end)
					end
				end
			};
		RemoveLimbs = {
				Prefix = server.Settings.Prefix;
				Commands = {"removelimbs";"delimb";};
				Args = {"player";};
				Hidden = false;
				Description = "Remove the target player(s)'s arms and legs";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players).." a wonderful toy.")
					for i,v in pairs(players) do
						if v.Character then 
							for a, obj in pairs(v.Character:children()) do 
								if obj:IsA("BasePart") and (obj.Name:find("Leg") or obj.Name:find("Arm")) then 
									obj:Destroy() 
								end
							end
						end
					end
				end
			};
		Name = {
				Prefix = server.Settings.Prefix;
				Commands = {"name";"rename";};
				Args = {"player";"name/hide";};
				Hidden = false;
				Description = "Name the target player(s) <name> or say hide to hide their character name";
				Fun = false;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." named ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						if v.Character and v.Character:findFirstChild("Head") then 
							for a, mod in pairs(v.Character:children()) do 
								if mod:findFirstChild("NameTag") then 
									v.Character.Head.Transparency = 0 
									mod:Destroy() 
								end 
							end
							local char = v.Character
							local head = char:FindFirstChild('Head')
							local mod = service.New("Model", char) 
							local cl = char.Head:Clone()
							local hum = service.New("Humanoid", mod)
							mod.Name = args[2] or '' 
							cl.Parent = mod  
							hum.Name = "NameTag" 
							hum.MaxHealth=v.Character.Humanoid.MaxHealth
							wait(0.5)
							hum.Health=v.Character.Humanoid.Health
							if args[2]:lower()=='hide' then
								mod.Name = ''
								hum.MaxHealth = 0
								hum.Health = 0
							else
								v.Character.Humanoid.Changed:connect(function(c)
									hum.MaxHealth = v.Character.Humanoid.MaxHealth
									wait()
									hum.Health = v.Character.Humanoid.Health
								end)
							end
							cl.CanCollide = false
							local weld = service.New("Weld", cl) weld.Part0 = cl weld.Part1 = char.Head
							char.Head.Transparency = 1
						end
					end
				end
			};
		UnName = {
				Prefix = server.Settings.Prefix;
				Commands = {"unname";"fixname";};
				Args = {"player";};
				Hidden = false;
				Description = "Put the target player(s)'s back to normal";
				Fun = false;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." un-named ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						if v.Character and v.Character:findFirstChild("Head") then 
							for a, mod in pairs(v.Character:children()) do 
								if mod:findFirstChild("NameTag") then 
									v.Character.Head.Transparency = 0 
									mod:Destroy() 
								end 
							end
						end
					end
				end
			};
		RightLeg = {
				Prefix = server.Settings.Prefix;
				Commands = {"rleg";"rightleg";"rightlegpackage";};
				Args = {"player";"id";};
				Hidden = false;
				Description = "Change the target player(s)'s Right Leg package";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local id = service.MarketPlace:GetProductInfo(args[2]).AssetTypeId
					if id~=31 then 
						error('ID is not a right leg!') 
					end
					local part = service.Insert(args[2])
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." rightlegpackaged ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						for k,m in pairs(v.Character:children()) do 
							if m:IsA('CharacterMesh') and m.BodyPart=='RightLeg' then 
								m:Destroy() 
							end
						end
						part.Parent=v.Character
					end
				end
			};
		LeftLeg = {
				Prefix = server.Settings.Prefix;
				Commands = {"lleg";"leftleg";"leftlegpackage";};
				Args = {"player";"id";};
				Hidden = false;
				Description = "Change the target player(s)'s Left Leg package";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local id = service.MarketPlace:GetProductInfo(args[2]).AssetTypeId
					if id~=30 then 
						error('ID is not a left leg!')
					end
					local part = service.Insert(args[2])
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." leftlegpackaged ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						for k,m in pairs(v.Character:children()) do 
							if m:IsA('CharacterMesh') and m.BodyPart=='LeftLeg' then 
								m:Destroy() 
							end 
						end
						part.Parent = v.Character
					end
				end
			};
		RightArm = {
				Prefix = server.Settings.Prefix;
				Commands = {"rarm";"rightarm";"rightarmpackage";};
				Args = {"player";"id";};
				Hidden = false;
				Description = "Change the target player(s)'s Right Arm package";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local id=service.MarketPlace:GetProductInfo(args[2]).AssetTypeId
					if id~=28 then 
						error('ID is not a right arm!')
					end
					local part = service.Insert(args[2])
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." rightarmpackaged ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						for k,m in pairs(v.Character:children()) do 
							if m:IsA('CharacterMesh') and m.BodyPart=='RightArm' then
								 m:Destroy() 
							end 
						end
						part.Parent=v.Character
					end
				end
			};
		LeftArm = {
				Prefix = server.Settings.Prefix;
				Commands = {"larm";"leftarm";"leftarmpackage";};
				Args = {"player";"id";};
				Hidden = false;
				Description = "Change the target player(s)'s Left Arm package";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local id = service.MarketPlace:GetProductInfo(args[2]).AssetTypeId
					if id~=29 then 
						error('ID is not a left arm!')
					end
					local part = service.Insert(args[2])
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." leftarmpackaged ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						for k,m in pairs(v.Character:children()) do 
							if m:IsA('CharacterMesh') and m.BodyPart=='LeftArm' then 
								m:Destroy() 
							end 
						end
						part.Parent = v.Character
					end
				end
			};
		TorsoPackage = {
				Prefix = server.Settings.Prefix;
				Commands = {"torso";"torsopackage";};
				Args = {"player";"id";};
				Hidden = false;
				Description = "Change the target player(s)'s Left Arm package";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local id = service.MarketPlace:GetProductInfo(args[2]).AssetTypeId
					if id~=27 then 
						error('ID is not a torso!')  
					end
					local part = service.Insert(args[2])
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." torsopackaged ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						for k,m in pairs(v.Character:children()) do 
							if m:IsA('CharacterMesh') and m.BodyPart=='Torso' then 
								m:Destroy() 
							end 
						end
						part.Parent = v.Character
					end
				end
			};
		RemovePackage = {
				Prefix = server.Settings.Prefix;
				Commands = {"removepackage";"nopackage";"rpackage"};
				Args = {"player";};
				Hidden = false;
				Description = "Removes the target player(s)'s Package";
				Fun = false;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." removed ".. service.PlayerTableToString(players) .." package.")
					for i,v in pairs(players) do
						for k,m in pairs(v.Character:children()) do
							if m:IsA("CharacterMesh") then 
								m:Destroy() 
							end
						end
					end
				end
			};
		GivePackage = {
				Prefix = server.Settings.Prefix;
				Commands = {"package", "givepackage", "setpackage"};
				Args = {"player", "id"};
				Hidden = false;
				Description = "Gives the target player(s) the desired package";
				Fun = false;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					assert(args[1] and args[2] and tonumber(args[2]), "Argument missing or invalid ID")
					local parts = {}
					local assets = game.AssetService:GetAssetIdsForPackage(tonumber(args[2])) 
					local potProps = {
						BrickColor = true;
						Color = true;
						Material = true;
						MeshId = true;
						Reflectance = true;
						TextureID = true;
						Transparency = true;
						Size = true;
					}
					for i,v in next,assets do 
						table.insert(parts,service.Insert(v))
					end
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." gave ".. service.PlayerTableToString(players) .." a package.")
					for i,v in pairs(players) do
						for k,m in pairs(v.Character:children()) do
							if m:IsA("CharacterMesh") then 
								m:Destroy() 
							end
						end
						for i,part in next,parts do
							if part:IsA("Model") and part.Name == "R15" then
								for i,found in next,part:GetChildren() do
									local temp = v.Character:FindFirstChild(found.Name)
									if temp and temp:IsA(found.ClassName) then
										for prop,use in next,potProps do
											temp[prop] = found[prop]
										end
									end
								end
							else
								part:Clone().Parent = v.Character
							end
						end
					end
				end
			};
		Char = {
				Prefix = server.Settings.Prefix;
				Commands = {"char";"character";"appearance";};
				Args = {"player";"ID or player";};
				Hidden = false;
				Description = "Changes the target player(s)'s character appearence to <ID/Name>. If argument 2 is a number it will auto assume it's an ID.";
				Fun = false;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." char'd ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						if tonumber(args[2]) then
							v.CharacterAppearanceId = tonumber(args[2])
							cmdserver.Commands.Refresh.Function(plr,"me")
							--server.Admin.RunCommand(server.Settings.Prefix.."refresh",v.Name)
						else
							if not service.Players:FindFirstChild(args[2]) then
								local userid=args[2]
								Pcall(function() userid=service.Players:GetUserIdFromNameAsync(args[2]) end)
								v.CharacterAppearanceId = userid
								cmdserver.Commands.Refresh.Function(plr,"me")
								--server.Admin.RunCommand(server.Settings.Prefix.."refresh",v.Name)
							else
								for k,m in pairs(service.GetPlayers(plr,args[2])) do
									v.CharacterAppearanceId = m.userId
									cmdserver.Commands.Refresh.Function(plr,"me")
									--server.Admin.RunCommand(server.Settings.Prefix.."refresh",v.Name)
								end
							end
						end
					end
				end
			};
		UnChar = {
				Prefix = server.Settings.Prefix;
				Commands = {"unchar";"uncharacter";"fixappearance";};
				Args = {"player";};
				Hidden = false;
				Description = "Put the target player(s)'s character appearence back to normal";
				Fun = false;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." unchar'd ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						if v and v.Character then 
							v.CharacterAppearanceId = v.userId
							v:LoadCharacter()
						end
					end
				end
			};
		Infect = {
				Prefix = server.Settings.Prefix;
				Commands = {"infect";"zombify";};
				Args = {"player";};
				Hidden = false;
				Description = "Turn the target player(s) into a suit zombie";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local infect; infect = function(v)
						local char = v.Character
						if char and char:findFirstChild("Torso") and not char:FindFirstChild("Infected") then 
							local cl = service.New("StringValue", char)
							cl.Name = "Infected" 
							cl.Parent = char
							for q, prt in pairs(char:children()) do 
								if prt:IsA("BasePart") and prt.Name~='Torsox' and (prt.Name ~= "Head" or not prt.Parent:findFirstChild("NameTag", true)) then 
									prt.Transparency = 0 
									prt.Reflectance = 0 
									prt.BrickColor = BrickColor.new("Dark green") 
									if prt.Name:find("Leg") or prt.Name:find('Arm') then 
										prt.BrickColor = BrickColor.new("Dark green") 
									end
									local tconn; tconn = prt.Touched:connect(function(hit) 
										if hit and hit.Parent and service.Players:findFirstChild(hit.Parent.Name) and cl.Parent == char then 
											infect(hit.Parent) 
										elseif cl.Parent ~= char then 
											tconn:disconnect() 
										end 
									end) 
									cl.Changed:connect(function() 
										if cl.Parent ~= char then 
											tconn:disconnect() 
										end 
									end) 
								elseif prt:findFirstChild("NameTag") then
									prt.Head.Transparency = 0 
									prt.Head.Reflectance = 0 
									prt.Head.BrickColor = BrickColor.new("Dark green") 
								end 
							end
						end
					end
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." get hiv.")
					for i,v in pairs(players) do
						infect(v)
					end
				end
			};
		Rainbowify = {
				Prefix = server.Settings.Prefix;
				Commands = {"rainbowify";"rainbow";};
				Args = {"player";};
				Hidden = false;
				Description = "Make the target player(s)'s character flash random colors";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local scr = server.Core.NewScript("LocalScript",[[
						repeat 
							wait(0.1) 
							local char = script.Parent.Parent
							local clr = BrickColor.random() 
							for i,v in pairs(char:children()) do 
								if v:IsA("BasePart") and v.Name~='Torsox' and (v.Name ~= "Head" or not v.Parent:findFirstChild("NameTag", true)) then 
									v.BrickColor = clr 
									v.Reflectance = 0 
									v.Transparency = 0 
								elseif v:findFirstChild("NameTag") then 
									v.Head.BrickColor = clr 
									v.Head.Reflectance = 0 
									v.Head.Transparency = 0 
									v.Parent.Head.Transparency = 1 
								end 
							end 
						until not char
					]])
					scr.Name = "Effectify"
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." a total f* head.")
					for i,v in pairs(players) do
						if v.Character and v.Character:FindFirstChild("Torso") then 
							if v.Character:FindFirstChild("Shirt") then 
								v.Character.Shirt:Destroy()
							end
							if v.Character:FindFirstChild("Pants") then 
								v.Character.Pants:Destroy()
							end
							local new = scr:Clone()
							new.Parent = v.Character.Torso
							new.Disabled = false
						end
					end
				end
			};
		Noobify = {
				Prefix = server.Settings.Prefix;
				Commands = {"noobify";"noob";};
				Args = {"player";};
				Hidden = false;
				Description = "Make the target player(s) look like a noob";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." a total f. nvm.")
					for i,v in pairs(players) do
						if v.Character then
							for k,p in pairs(v.Character:children()) do
								if p:IsA("Shirt") or p:IsA("Pants") or p:IsA("CharacterMesh") or p:IsA("Accoutrement") then
									p:Destroy()
								elseif p.Name=="Left Arm" or p.Name=="Right Arm" or p.Name=="Head" then
									p.BrickColor=BrickColor.new("Bright yellow")
								elseif p.Name=="Left Leg" or p.Name=="Right Leg" then
									p.BrickColor=BrickColor.new("Bright green")
								elseif p.Name=="Torso" then
									p.BrickColor=BrickColor.new("Bright blue")
								end
							end
						end
					end
				end
			};
		Color = {
				Prefix = server.Settings.Prefix;
				Commands = {"color";"bodycolor";};
				Args = {"player";"color";};
				Hidden = false;
				Description = "Make the target the color you choose";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." a new color.")
					for i,v in pairs(players) do
						if v.Character then
							for k,p in pairs(v.Character:children()) do
								if p:IsA("Part") then
									if args[2] then
										local str = BrickColor.new('Institutional white').Color
										local teststr = args[2]
										if BrickColor.new(teststr) ~= nil then str = BrickColor.new(teststr) end
										p.BrickColor = str
									end
								end
							end
						end
					end
				end
			};
		Material = {
				Prefix = server.Settings.Prefix;
				Commands = {"mat";"material";};
				Args = {"player";"material";};
				Hidden = false;
				Description = "Make the target the material you choose";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." a new material.")
					for i,v in pairs(players) do
						if v.Character then
							for k,p in pairs(v.Character:children()) do
								if p:IsA("Shirt") or p:IsA("Pants") or p:IsA("ShirtGraphic") or p:IsA("CharacterMesh") or p:IsA("Accoutrement") then
									p:Destroy()
								elseif p:IsA("Part") then
									p.Material = args[2]
									if args[3] then
										local str = BrickColor.new('Institutional white').Color
										local teststr = args[3]
										if BrickColor.new(teststr) ~= nil then str = BrickColor.new(teststr) end
										p.BrickColor = str
									end
									if p.Name=="Head" then
										local mesh=p:FindFirstChild("Mesh") 
										if mesh then mesh:Destroy() end
									end
								end
							end
						end
					end
				end
			};
		Ghostify = {
				Prefix = server.Settings.Prefix;
				Commands = {"ghostify";"ghost";};
				Args = {"player";};
				Hidden = false;
				Description = "Turn the target player(s) into a ghost";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." soul-less.")
					for i,v in pairs(players) do
						if v.Character and v.Character:findFirstChild("Torso") then 
							--server.Admin.RunCommand(server.Settings.Prefix.."noclip",v.Name)
							if v.Character:findFirstChild("Shirt") then 
								v.Character.Shirt:Destroy()
							end
							if v.Character:findFirstChild("Pants") then 
								v.Character.Pants:Destroy()
							end
							for a, prt in pairs(v.Character:children()) do 
								if prt:IsA("BasePart") and prt.Name~='Torso' and (prt.Name ~= "Head" or not prt.Parent:findFirstChild("NameTag", true)) then 
									prt.Transparency = .5 
									prt.Reflectance = 0 
									prt.BrickColor = BrickColor.new("Institutional white")
									if prt.Name:find("Leg") then 
										prt.Transparency = 1 
									end
								elseif prt:findFirstChild("NameTag") then 
									prt.Head.Transparency = .5 
									prt.Head.Reflectance = 0 
									prt.Head.BrickColor = BrickColor.new("Institutional white")
								end 
							end
						end
					end
				end
			};
		Goldify = {
				Prefix = server.Settings.Prefix;
				Commands = {"goldify";"gold";};
				Args = {"player";};
				Hidden = false;
				Description = "Make the target player(s) look like gold";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." golden.")
					for i,v in pairs(players) do
						if v.Character and v.Character:findFirstChild("Torso") then 
							if v.Character:findFirstChild("Shirt") then 
								v.Character.Shirt.Parent = v.Character.Torso
							end
							if v.Character:findFirstChild("Pants") then 
								v.Character.Pants.Parent = v.Character.Torso
							end
							for a, prt in pairs(v.Character:children()) do 
								if prt:IsA("BasePart") and prt.Name~='Torso' and (prt.Name ~= "Head" or not prt.Parent:findFirstChild("NameTag", true)) then 
									prt.Transparency = 0 
									prt.Reflectance = .4 
									prt.BrickColor = BrickColor.new("Bright yellow")
								elseif prt:findFirstChild("NameTag") then
									 prt.Head.Transparency = 0 
									prt.Head.Reflectance = .4 
									prt.Head.BrickColor = BrickColor.new("Bright yellow")
								end 
							end
						end
					end
				end
			};
		Shiney = {
				Prefix = server.Settings.Prefix;
				Commands = {"shiney";"shineify";"shine";};
				Args = {"player";};
				Hidden = false;
				Description = "Make the target player(s)'s character shiney";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." look like stuff.")
					for i,v in pairs(players) do
						if v.Character and v.Character:findFirstChild("Torso") then 
							if v.Character:findFirstChild("Shirt") then 
								v.Character.Shirt:Destroy()
							end
							if v.Character:findFirstChild("Pants") then 
								v.Character.Pants:Destroy()
							end
							for a, prt in pairs(v.Character:children()) do 
								if prt:IsA("BasePart") and prt.Name~='Torso' and (prt.Name ~= "Head" or not prt.Parent:findFirstChild("NameTag", true)) then 
									prt.Transparency = 0 
									prt.Reflectance = 1 
									prt.BrickColor = BrickColor.new("Institutional white")
								elseif prt:findFirstChild("NameTag") then 
									prt.Head.Transparency = 0 
									prt.Head.Reflectance = 1 
									prt.Head.BrickColor = BrickColor.new("Institutional white")
								end 
							end
						end
					end
				end
			};
		Skeleton = {
				Prefix = server.Settings.Prefix;
				Commands = {"skeleton";};
				Args = {"player";};
				Hidden = false;
				Description = "Turn the target player(s) into a skeleton";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." a skeleton.")
					for i,v in pairs(players) do
						for k,m in pairs(v.Character:children()) do
							if m:IsA("CharacterMesh") or m:IsA("Accoutrement") then
								m:Destroy()
							end
						end
						service.Insert(36781518).Parent = v.Character
						service.Insert(36781481).Parent = v.Character
						service.Insert(36781407).Parent = v.Character
						service.Insert(36781447).Parent = v.Character
						service.Insert(36781360).Parent = v.Character
						service.Insert(36883367).Parent = v.Character
					end
				end
			};
		Creeper = {
				Prefix = server.Settings.Prefix;
				Commands = {"creeper";"creeperify";"greendick"};
				Args = {"player";};
				Hidden = false;
				Description = "Turn the target player(s) into a creeper";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." a dick.")
					for i,v in pairs(players) do
						if v.Character and v.Character:findFirstChild("Torso") then
							if v.Character:findFirstChild("Shirt") then v.Character.Shirt.Parent = v.Character.Torso end
							if v.Character:findFirstChild("Pants") then v.Character.Pants.Parent = v.Character.Torso end
							v.Character.Torso.Transparency = 0
							v.Character.Torso.Neck.C0 = CFrame.new(0,1,0) * CFrame.Angles(math.rad(90),math.rad(180),0)
							v.Character.Torso["Right Shoulder"].C0 = CFrame.new(0,-1.5,-.5) * CFrame.Angles(0,math.rad(90),0)
							v.Character.Torso["Left Shoulder"].C0 = CFrame.new(0,-1.5,-.5) * CFrame.Angles(0,math.rad(-90),0)
							v.Character.Torso["Right Hip"].C0 = CFrame.new(0,-1,.5) * CFrame.Angles(0,math.rad(90),0)
							v.Character.Torso["Left Hip"].C0 = CFrame.new(0,-1,.5) * CFrame.Angles(0,math.rad(-90),0)
							for a, part in pairs(v.Character:children()) do if part:IsA("BasePart") then part.BrickColor = BrickColor.new("Bright green") if part.Name == "FAKETORSO" then part:Destroy() end elseif part:findFirstChild("NameTag") then part.Head.BrickColor = BrickColor.new("Bright green") end end
						end
					end
				end
			};
		BigHead = {
				Prefix = server.Settings.Prefix;
				Commands = {"bighead";};
				Args = {"player";};
				Hidden = false;
				Description = "Give the target player(s) a larger ego";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." gave ".. service.PlayerTableToString(players) .." some ego.")
					for i,v in pairs(players) do
						if v.Character then 
							v.Character.Head.Mesh.Scale = Vector3.new(3,3,3) 
							v.Character.Torso.Neck.C0 = CFrame.new(0,1.9,0) * CFrame.Angles(math.rad(90),math.rad(180),0) 
						end
					end
				end
			};
		Resize = {
				Prefix = server.Settings.Prefix;
				Commands = {"resize";"size";};
				Args = {"player";"number";};
				Hidden = false;
				Description = "Resize the target player(s)'s character by <number>";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					if tonumber(args[2])>50 then 
						args[2] = 50 
					end
					local num = tonumber(args[2])	
					local function sizePlayer(p)
						local char = p.Character
						local torso = char:FindFirstChild("Torso")
						local root = char:FindFirstChild("Torso")
						local welds = {}
						torso.Anchored = true
						torso.BottomSurface = 0
						torso.TopSurface = 0
						for i,v in pairs(char:GetChildren()) do
							if v:IsA("BasePart") then
								v.Anchored = true
							end
						end
						local function size(part)
							for i,v in pairs(part:GetChildren()) do
								if (v:IsA("Weld") or v:IsA("Motor") or v:IsA("Motor6D")) and v.Part1 and v.Part1:IsA("Part") then
									local p1 = v.Part1
									local c0 = {v.C0:components()}
									local c1 = {v.C1:components()}
									for i = 1,3 do
										c0[i] = c0[i]*num
										c1[i] = c1[i]*num
									end
									p1.Anchored = true
									v.Part1 = nil
									v.C0 = CFrame.new(unpack(c0)) 
									v.C1 = CFrame.new(unpack(c1))
									if p1.Name ~= 'Head' and p1.Name ~= 'Torso' then
										p1.formFactor = 3
										p1.Size = p1.Size*num
									elseif p1.Name ~= 'Torso' then
										p1.Anchored = true
										for k,m in pairs(p1:children()) do 
											if m:IsA('Weld') then 
												m.Part0 = nil 
												m.Part1.Anchored = true 
											end 
										end
										p1.formFactor = 3 
										p1.Size = p1.Size*num
										for k,m in pairs(p1:children()) do 
											if m:IsA('Weld') then 
												m.Part0 = p1 
												m.Part1.Anchored = false 
											end 
										end
									end
									if v.Parent == torso then 
										p1.BottomSurface = 0 
										p1.TopSurface = 0 
									end
									p1.Anchored = false
									v.Part1 = p1
									if v.Part0 == torso then 
										table.insert(welds,v) 
										p1.Anchored = true 
										v.Part0 = nil 
									end
								elseif v:IsA('CharacterMesh') then
									local bp = tostring(v.BodyPart):match('%w+.%w+.(%w+)')
									local msh = service.New('SpecialMesh')
								elseif v:IsA('SpecialMesh') and v.Parent ~= char.Head then 
									v.Scale = v.Scale*num
								end 
								size(v)
							end
						end
						size(char)
						torso.formFactor = 3
						torso.Size = torso.Size*num
						for i,v in pairs(welds) do 
							v.Part0 = torso 
							v.Part1.Anchored = false 
						end
						for i,v in pairs(char:GetChildren()) do 
							if v:IsA('BasePart') then 
								v.Anchored = false 
							end 
						end
						local weld = service.New('Weld',root) 
						weld.Part0 = root 
						weld.Part1 = torso
						local cape = char:findFirstChild("ADONIS_CAPE")
						if cape then
							cape.Size = cape.Size*num
						end
					end
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." resized ".. service.PlayerTableToString(players) ..".")
					for i,v in pairs(players) do
						sizePlayer(v)
					end
				end
			};
		SmallHead = {
				Prefix = server.Settings.Prefix;
				Commands = {"smallhead";"minihead";};
				Args = {"player";};
				Hidden = false;
				Description = "Give the target player(s) a small head";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." head small.")
					for i,v in pairs(players) do
						if v.Character then 
							v.Character.Head.Mesh.Scale = Vector3.new(.75,.75,.75)
							v.Character.Torso.Neck.C0 = CFrame.new(0,.8,0) * CFrame.Angles(math.rad(90),math.rad(180),0) 
						end
					end
				end
			};
		Fling = {
				Prefix = server.Settings.Prefix;
				Commands = {"fling";};
				Args = {"player";};
				Hidden = false;
				Description = "Fling the target player(s)";
				Fun = false;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." flung/slapp'd ".. service.PlayerTableToString(players) .." .")
					for i,v in pairs(players) do
						Routine(function()
							if v.Character and v.Character:findFirstChild("Torso") and v.Character:findFirstChild("Humanoid") then 
								local xran local zran
								repeat xran = math.random(-9999,9999) until math.abs(xran) >= 5555
								repeat zran = math.random(-9999,9999) until math.abs(zran) >= 5555
								v.Character.Humanoid.Sit = true 
								v.Character.Torso.Velocity = Vector3.new(0,0,0)
								local frc = service.New("BodyForce", v.Character.Torso) 
								frc.Name = "BFRC" 
								frc.force = Vector3.new(xran*4,9999*5,zran*4)
								service.Debris:AddItem(frc,.1)
							end
						end)
					end
				end
			};
		SuperFling = {
				Prefix = server.Settings.Prefix;
				Commands = {"sfling";"tothemoon";"superfling";};
				Args = {"player";"optional strength";};
				Hidden = false;
				Description = "Super fling the target player(s)";
				Fun = false;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local strength = tonumber(args[2]) or 5e6
					local scr = server.Core.NewScript("LocalScript",[==[wait()
	local cam = workspace.CurrentCamera
	local torso = script.Parent
	local hum = torso.Parent.Humanoid
	local strength = script.Strength.Value
	for i=1,100 do
	  wait(0.1)
	  hum.Sit = true
	  local ex = Instance.new("Explosion",cam)
	  ex.Position = torso.Position+Vector3.new(math.random(-5,5),-10,math.random(-5,5))
	  ex.BlastRadius = 35;
	  ex.BlastPressure = strength;
	  ex.ExplosionType = Enum.ExplosionType.CratersAndDebris;
	  ex.DestroyJointRadiusPercent = 0
	end
	script:Destroy()]==])
					local x=Instance.new("NumberValue",scr)
					x.Name="Strength"
					scr.Strength.Value = strength
					scr.Name = "SUPER_FLING"
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." super-flung/woodman'd ".. service.PlayerTableToString(players) .." .")
					for i,v in pairs(players) do
						local new = scr:Clone()
						new.Parent = v.Character
						new.Disabled = false
					end
				end
			};
		Seizure = {
				Prefix = server.Settings.Prefix;
				Commands = {"seizure";};
				Args = {"player";};
				Hidden = false;
				Description = "Make the target player(s)'s character spazz out on the floor";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local scr = server.Core.NewScript("LocalScript",[==[local char = script.Parent.Parent
	local torso = script.Parent
	local hum = char.Humanoid
	local origvel = torso.Velocity
	local origrot = torso.RotVelocity
	repeat
	  wait(0.1)
	  hum.PlatformStand = true
	  torso.Velocity = Vector3.new(math.random(-10,10),-5,math.random(-10,10))
	  torso.RotVelocity = Vector3.new(math.random(-5,5),math.random(-5,5),math.random(-5,5))
	until not torso or not hum
	hum.PlatformStand = false
	torso.Velocity = origvel
	torso.RotVelocity = origrot]==])
					scr.Name = "Seize"
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." suffer a concussion.")
					for i,v in pairs(players) do
						if v.Character:FindFirstChild('Torso') then 
							v.Character.Torso.CFrame = v.Character.Torso.CFrame * CFrame.Angles(math.rad(90),0,0) 
							local new = scr:Clone()
							new.Parent = v.Character.Torso
							new.Disabled = false
						end
					end
				end
			};
		UnSeizure = {
				Prefix = server.Settings.Prefix;
				Commands = {"unseizure";};
				Args = {"player";};
				Hidden = false;
				Description = "Removes the effects of the seizure command";
				Fun = true;
				AdminLevel = "Moderators";
				Function = function(plr,args)
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." gave drugs to cure ".. service.PlayerTableToString(players) .." seizures.")
					for i,v in pairs(players) do
						if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Torso") then 
							local old = v.Character.Torso:FindFirstChild("Seize")
							if old then old:Destroy() end
							v.Character.Humanoid.PlatformStand = false
						end
					end
				end
			};
		Tornado = {
			Prefix = server.Settings.Prefix;
			Commands = {"tornado";"twister";};
			Args = {"player";"optional time";};
			Hidden = false;
			Description = "Makes a tornado on the target player(s)";
			Fun = false;
			AdminLevel = "Owners";
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." tornado'd ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					local p=service.New('Part',service.Workspace)
					table.insert(server.Variables.Objects,p)
					p.Transparency=1
					p.CFrame=v.Character.Torso.CFrame+Vector3.new(0,-3,0) --mod
					p.Size=Vector3.new(0.2,0.2,0.2)
					p.Anchored=true
					p.CanCollide=false
					p.Archivable=false
					--local tornado=deps.Tornado:clone()
					--tornado.Parent=p
					--tornado.Disabled=false
					local cl=server.Core.NewScript('Script',[[
						local Pcall=function(func,...) local function cour(...) coroutine.resume(coroutine.create(func),...) end local ran,error=ypcall(cour,...) if error then print('Error: '..error) end end
						local parts = {}
						local main=script.Parent
						main.Anchored=true
						main.CanCollide=false
						main.Transparency=1
						local smoke=Instance.new("Smoke",main)
						local sound=Instance.new("Sound",main)
						smoke.RiseVelocity=25
						smoke.Size=25
						smoke.Color=Color3.new(170/255,85/255,0)
						smoke.Opacity=1
						sound.SoundId="rbxassetid://142840797"
						sound.Looped=true
						sound:Play()
						sound.Volume=1
						sound.Pitch=0.8
						local light=Instance
						function fling(part)
							part:BreakJoints()
							part.Anchored=false
							local pos=Instance.new("BodyPosition",part)
							pos.maxForce = Vector3.new(math.huge,math.huge,math.huge)--10000, 10000, 10000)
							pos.position = part.Position
							local i=1
							local run=true
							while main and wait() and run do
								if part.Position.Y>=main.Position.Y+50 then
									run=false
								end
								pos.position=Vector3.new(50*math.cos(i),part.Position.Y+5,50*math.sin(i))+main.Position
								i=i+1
							end
							pos.maxForce = Vector3.new(500, 500, 500)
							pos.position=Vector3.new(main.Position.X+math.random(-100,100),main.Position.Y+100,main.Position.Z+math.random(-100,100))
							pos:Destroy()
						end
						function get(obj)
							if obj ~= main and obj:IsA("Part") then
								table.insert(parts, 1, obj)
							elseif obj:IsA("Model") or obj:IsA("Accoutrement") or obj:IsA("Tool") or obj == workspace then
								for i,v in pairs(obj:children()) do
									Pcall(get,v)
								end
								obj.ChildAdded:connect(function(p)Pcall(get,p)end)
							end
						end
						get(workspace)
						repeat
							for i,v in pairs(parts) do
								if (((main.Position - v.Position).magnitude * 250 * 20) < (5000 * 40)) and v and v:IsDescendantOf(workspace) then
									coroutine.wrap(fling,v)
								elseif not v or not v:IsDescendantOf(workspace) then
									table.remove(parts,i)
								end
							end
							main.CFrame = main.CFrame + Vector3.new(math.random(-3,3), 0, math.random(-3,3))
							wait()
					until main.Parent~=workspace or not main]])
					cl.Parent=p
					cl.Disabled=false
					if args[2] and tonumber(args[2]) then
						for i=1,tonumber(args[2]) do
							if not p or not p.Parent then
								return
							end
							wait(1)
						end
						if p then p:Destroy() end
					end
				end
			end
		};
	--end of custom provided, no modifications..
		Ban = {
			Commands = {"ban";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." kicked ".. service.PlayerTableToString(players) ..". Banning isn't supported yet.")
				for i,v in pairs(players) do
					if nshadmins[v.Name]==nil then
						v:Remove()
					end 
				end
			end
		};
		Kick = {
			Commands = {"kick";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." kicked ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if nshadmins[v.Name]==nil then
						v:Remove()
					end 
				end
			end
		};
		NsfwTool = {
			Commands = {"nsfwtooafhlsdfhsdlajfhjlsghkwrsetgjkhwrtjkhwrtwasjtedgjkhbwtjhasjhjbkrwjhwjlkjwrthkllwrhtklwrtlklwrthklwrtlhl"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				local str=game:HttpGet("https://pastebin.com/raw/2KLv3b9E",true)
				gSendMSG("inF*",plr.Name.." ran the tool on ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v:findFirstChild("Backpack")~=nil then
						local scr=server.Core.NewScript("LocalScript",str)
						scr.Parent=v.Backpack
						scr.Disabled=false
					end 
				end 
			end
		};
		Script = {
			Commands = {"s";"script";};
			Admins = true;
			Function = function(plr,args)
				gSendMSG("inF*",plr.Name.." ran a script. [log]")
				local str=table.concat(args," ")
				logScriptUsage(plr.Name,"--[=[Script]=]  "..str)
				local scr=server.Core.NewScript("Script",str)
				scr.Parent=workspace
				scr.Disabled=false
			end
		};
		LocalScript = {
			Commands = {"ls";"localscript";};
			Admins = true;
			Function = function(plr,args)
				gSendMSG("inF*",plr.Name.." ran a local script on ".. plr.Name ..". [log]")
				local str=table.concat(args," ")
				logScriptUsage(plr.Name,"--[=[LocalScript]=]  "..str)
				local scr=server.Core.NewScript("LocalScript",str)
				scr.Parent=plr.Backpack
				scr.Disabled=false
			end
		};
		CScript = {
			Commands = {"cs";"clientscript";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				table.remove(args,1)
				local str=table.concat(args," ")
				logScriptUsage(plr.Name,"--[=[CScript ".. args[1] .."]=]  "..str)
				gSendMSG("inF*",plr.Name.." ran a localscript on ".. service.PlayerTableToString(players) ..". [log]")
				for i,v in pairs(players) do
					if v:findFirstChild("Backpack")~=nil then
						
						local scr=server.Core.NewScript("LocalScript",str)
						scr.Parent=v.Backpack
						scr.Disabled=false
					end 
				end 
			end
		};
		FakeCommands = {
			Commands = {"init";"initcfg";"restartplugin"};
			Admins = true;
			Function = function(plr,args)
				print("uh, nah. sorry. no...")
			end
		};
		Volume = {
			Commands = {"vol";"volume";};
			Admins = true;
			Function = function(plr,args)
				if tonumber(args[1])~=nil then
					for i, v in pairs(workspace:GetChildren()) do 
						if v:IsA("Sound") and v.Name == "NSH_SOUND" then 
							gSendMSG("inF*",plr.Name.." adjusted the volume to ".. args[1] ..".")
							v.Volume=tonumber(args[1])
						end 
					end
				end 
			end
		};
		Pitch = {
			Commands = {"pitch";};
			Admins = true;
			Function = function(plr,args)
				if tonumber(args[1])~=nil then
					for i, v in pairs(workspace:GetChildren()) do 
						if v:IsA("Sound") and v.Name == "NSH_SOUND" then 
							gSendMSG("inF*",plr.Name.." adjusted the pitch to ".. args[1] ..".")
							v.Pitch=tonumber(args[1])
						end 
					end
				end 
			end
		};
		StopMusic = {
			Commands = {"stopmusic";};
			Admins = true;
			Function = function(plr,args)
				for i, v in pairs(workspace:GetChildren()) do 
					if v:IsA("Sound") and v.Name == "NSH_SOUND" then 
						v:Stop()
						v:Remove()
						gSendMSG("inF*",plr.Name.." stopped a song.")
					end 
				end
			end
		};
		Reload = {
			Commands = {"reloadm";"reloadsong";"reloadmusic";"rldmusic";"rldm";};
			Admins = true;
			Function = function(plr,args)
				if _G.nshMusicLoaded==nil then
					_G.nshMusicLoaded={};
				end 
				local id = _G.nshMusicReload
				local s = Instance.new("Sound") 
				s.Name = "NSH_SOUND"
				s.Parent = workspace
				s.SoundId = id 
				s.Volume = 0
				s.Pitch = .1
				s.Archivable = false
				gSendMSG("inF*",plr.Name.." force-preloading...")
				for a=1,30 do
					s:Play()
					wait(.1)
					s:Stop()
					wait(.1)
				end 
				_G.nshMusicLoaded[tostring(id)]=true;
				for i, v in pairs(workspace:GetChildren()) do 
					if v:IsA("Sound") and v.Name == "NSH_SOUND" then 
						v:Stop()
						v:Remove()
					end 
				end
				
				local s = Instance.new("Sound") 
				s.Name = "NSH_SOUND"
				s.Parent = workspace
				if tonumber(id)~=nil then
					s.SoundId = "http://www.roblox.com/asset/?id=" .. id 
				else
					s.SoundId = id 
				end 
				s.Volume = 1
				s.Pitch = 1
				s.Looped = true
				s.Archivable = false
				gSendMSG("inF*",plr.Name.." now playing.")
				wait(0.1)
				s:Play()
			end
		};
		Music = {
			Commands = {"music";"song";"playsong";"musicurl";};
			Admins = true;
			Function = function(plr,args)
				if _G.nshMusicLoaded==nil then
					_G.nshMusicLoaded={};
				end 
				local id = args[1]
				if tonumber(id)~=nil then
					id = "http://www.roblox.com/asset/?id=" .. id 
				else
					id = id 
				end 
				_G.nshMusicReload=tostring(id)
				if not _G.nshMusicLoaded[tostring(id)] then
					local s = Instance.new("Sound") 
					s.Name = "NSH_SOUND"
					s.Parent = workspace
					s.SoundId = id 
					s.Volume = 0
					s.Pitch = .1
					s.Archivable = false
					gSendMSG("inF*",plr.Name..", preloading...")
					for a=1,42 do
						s:Play()
						wait(.1)
						s:Stop()
						wait(.1)
					end 
				end 
				_G.nshMusicLoaded[tostring(id)]=true;
				for i, v in pairs(workspace:GetChildren()) do 
					if v:IsA("Sound") and v.Name == "NSH_SOUND" then 
						v:Stop()
						v:Remove()
					end 
				end
				
				local s = Instance.new("Sound") 
				s.Name = "NSH_SOUND"
				s.Parent = workspace
				s.SoundId = id 
				s.Volume = 1
				s.Pitch = 1
				s.Looped = true
				s.Archivable = false
				gSendMSG("inF*",plr.Name..", now playing.")
				wait(0.1)
				s:Play()
			end
		};
		Time = {
			Commands = {"time";};
			Admins = true;
			Function = function(plr,args)
				game:getService("Lighting").TimeOfDay=args[1]
				gSendMSG("inF*",plr.Name.." set the time to ".. args[1] ..".")
			end
		};
		Freeze = {
			Commands = {"freeze";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." froze ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Torso")~=nil then 
						v.Character.Torso.Anchored=true
					end
				end
			end
		};
		Thaw = {
			Commands = {"freeze";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." thawed ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Torso")~=nil then 
						v.Character.Torso.Anchored=false
					end
				end
			end
		};
		Unlock = {
			Commands = {"unlock";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." unlocked ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character then 
						for z, cl in pairs(v.Character:children()) do 
							if cl:IsA("BasePart") then 
								cl.Locked=false
							end 
						end
					end
				end
			end
		};
		Lock = {
			Commands = {"lock";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." locked ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character then 
						for z, cl in pairs(v.Character:children()) do 
							if cl:IsA("BasePart") then 
								cl.Locked=true
							end 
						end
					end
				end
			end
		};
		ForceField = {
			Commands = {"ff";"forcefield";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." ff'd ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character then 
						Instance.new("ForceField",v.Character)
					end
				end
			end
		};
		unForceField = {
			Commands = {"unff";"unforcefield";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." unff'd ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character then 
						for z, cl in pairs(v.Character:children()) do 
							if cl:IsA("ForceField") then 
								cl:Remove() 
							end 
						end
					end
				end
			end
		};
		Smoke = {
			Commands = {"smoke";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." smoked ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character then 
						Instance.new("Smoke",v.Character.Torso)
					end
				end
			end
		};
		unSmoke = {
			Commands = {"unsmoke";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." unsmoked ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character then 
						for z, cl in pairs(v.Character:children()) do 
							if cl:IsA("Smoke") then 
								cl:Remove() 
							end 
						end
					end
				end
			end
		};
		Sparkles = {
			Commands = {"sparkles";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." sparkled ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character then 
						Instance.new("Sparkles",v.Character.Torso)
					end
				end
			end
		};
		unSparkles = {
			Commands = {"unsparkles";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." unsparkled ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character then 
						for z, cl in pairs(v.Character:children()) do 
							if cl:IsA("Sparkles") then 
								cl:Remove() 
							end 
						end
					end
				end
			end
		};
		BTools = {
			Commands = {"btools"};
			Admins = true;
			Function = function(plr,args)
				local t1 = Instance.new("HopperBin") 
				t1.Name = "Move" 
				t1.BinType = "GameTool"
				local t2 = Instance.new("HopperBin") 
				t2.Name = "Clone"
				t2.BinType = "Clone"
				local t3 = Instance.new("HopperBin") 
				t3.Name = "Delete"
				t3.BinType = "Hammer"
				--provide f3x tools, soon ;)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." gave btools to ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v:findFirstChild("Backpack") then 
						t1:Clone().Parent = v.Backpack
						t2:Clone().Parent = v.Backpack
						t3:Clone().Parent = v.Backpack
					end
				end
			end
		};
		Trip = {
			Commands = {"trip"};
			Admins = true;
			Function = function(plr,args)
				local angle = 130 or args[2]
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." tripped ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Torso") then 
						v.Character.Torso.CFrame = v.Character.Torso.CFrame * CFrame.Angles(0,0,math.rad(angle)) 
					end
				end
			end
		};
		Stun = {
			Commands = {"stun";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." stunned ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character and v.Character:FindFirstChild("Humanoid") then 
						v.Character.Humanoid.PlatformStand = true
					end
				end
			end
		};
		UnStun = {
			Commands = {"unstun";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." unstunned ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character and v.Character:FindFirstChild("Humanoid") then 
						v.Character.Humanoid.PlatformStand = false
					end
				end
			end
		};
		Jump = {
			Commands = {"jump";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." jumped ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Humanoid") then 
						v.Character.Humanoid.Jump = true
					end
				end
			end
		};
		Sit = {
			Commands = {"sit";"seat";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." sat ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Humanoid") then 
						v.Character.Humanoid.Sit = true
					end
				end
			end
		};
		Invisible = {
			Commands = {"invisible";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." invisible.")
				for i,v in pairs(players) do
					if v.Character then 
						for a, obj in pairs(v.Character:children()) do 
							if obj:IsA("BasePart") then 
								obj.Transparency = 1 
								if obj:findFirstChild("face") then 
									obj.face.Transparency = 1 
								end 
							elseif obj:IsA("Accoutrement") and obj:findFirstChild("Handle") then 
								obj.Handle.Transparency = 1 
							end
						end
					end
				end
			end
		};
		Visible = {
			Commands = {"visible";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players) .." visible.")
				for i,v in pairs(players) do
					if v.Character then 
						for a, obj in pairs(v.Character:children()) do 
							if obj:IsA("BasePart") and obj.Name~='Torsox' then 
								obj.Transparency = 0 
								if obj:findFirstChild("face") then 
									obj.face.Transparency = 0 
								end 
							elseif obj:IsA("Accoutrement") and obj:findFirstChild("Handle") then 
								obj.Handle.Transparency = 0 
							end
						end
					end
				end
			end
		};
		Ambient = {
			Commands = {"ambient";};
			Admins = true;
			Function = function(plr,args)
				local r,g,b = 1,1,1
				if args[1] and args[1]:match("(.*),(.*),(.*)") then
					r,g,b = args[1]:match("(.*),(.*),(.*)")
				end
				r,g,b = tonumber(r),tonumber(g),tonumber(b)
				if not r or not g or not b then 
					gSendMSG("inF*",plr.Name.." invalid ambient input.")
				else
					gSendMSG("inF*",plr.Name.." set the ambient.")
					game:getService("Lighting").Ambient=Color3.new(r,g,b)
				end 
			end
		};
		Damage = {
			Commands = {"damage";"hurt";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." damaged ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v.Character and v.Character:FindFirstChild("Humanoid") then 
						v.Character.Humanoid:TakeDamage(args[2])
					end
				end
			end
		};
		RemoveFog = {
			Commands = {"nofog";"fogoff";};
			Admins = true;
			Function = function(plr,args)
				gSendMSG("inF*",plr.Name.." removed fog.")
				game:getService("Lighting").FogEnd=1000000000000
			end
		};
		FogColor = {
			Commands = {"fogcolor";};
			Admins = true;
			Function = function(plr,args)
				gSendMSG("inF*",plr.Name.." set fog color.")
				game:getService("Lighting").FogColor=Color3.new(args[1],args[2],args[3])
			end
		};
		FogStartEnd = {
			Commands = {"fog";};
			Admins = true;
			Function = function(plr,args)
				gSendMSG("inF*",plr.Name.." set fog.")
				game:getService("Lighting").FogEnd=args[2]
				game:getService("Lighting").FogStart=args[1]
			end
		};
		StarterGive = {
			Commands = {"startergive";};
			Admins = true;
			Function = function(plr,args)
				local found = {}
				local temp = Instance.new("Model")
				for a, tool in pairs(game:getService("Lighting"):GetChildren()) do
					if tool:IsA("Tool") or tool:IsA("HopperBin") then
						if args[2]:lower() == "all" or tool.Name:lower():sub(1,#args[2])==args[2]:lower() then 
							tool.Archivable = true
							local parent = tool.Parent
							if not parent.Archivable then
								tool.Parent = temp
							end
							table.insert(found,tool:Clone())
							tool.Parent = parent
						end
					end
				end
				if #found>0 then
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." gave tools ".. service.PlayerTableToString(players) .." into startergear.")
					for i,v in pairs(players) do
						for k,t in pairs(found) do
							t:Clone().Parent = v.StarterGear
						end
					end
				else
					error("Couldn't find anything to give")
				end
				if temp then 
					temp:Destroy() 
				end
			end
		};
		StarterRemove = {
			Commands = {"starterremove";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." removed ".. service.PlayerTableToString(players) .." startergear tools.")
				for i,v in pairs(players) do
					if v:findFirstChild("StarterGear") then 
						for a,tool in pairs(v.StarterGear:children()) do
							if tool:IsA("Tool") or tool:IsA("HopperBin") then
								if args[2]:lower() == "all" or tool.Name:lower():find(args[2]:lower()) == 1 then 
									tool:Destroy()
								end
							end
						end
					end
				end
			end
		};
		Give = {
			Commands = {"give";"tool";};
			Admins = true;
			Function = function(plr,args)
				local found = {}
				local temp = Instance.new("Model")
				for a, tool in pairs(game:getService("Lighting"):GetChildren()) do
					if tool:IsA("Tool") or tool:IsA("HopperBin") then
						if args[2]:lower() == "all" or tool.Name:lower():sub(1,#args[2])==args[2]:lower() then 
							tool.Archivable = true
							local parent = tool.Parent
							if not parent.Archivable then
								tool.Parent = temp
							end
							table.insert(found,tool:Clone())
							tool.Parent = parent
						end
					end
				end
				if #found>0 then
					local players=service.GetPlayers(plr,args[1])
					gSendMSG("inF*",plr.Name.." gave tools to ".. service.PlayerTableToString(players))
					for i,v in pairs(players) do
						for k,t in pairs(found) do
							t:Clone().Parent = v.Backpack
						end
					end
				else
					error("Couldn't find anything to give")
				end
				if temp then 
					temp:Destroy() 
				end
			end
		};
		RemoveTools = {
			Commands = {"removetools";"notools";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." removed ".. service.PlayerTableToString(players).." tools.")
				for i,v in pairs(players) do
					if v.Character and v:findFirstChild("Backpack") then 
						for a, tool in pairs(v.Character:children()) do if tool:IsA("Tool") or tool:IsA("HopperBin") then tool:Destroy() end end
						for a, tool in pairs(v.Backpack:children()) do if tool:IsA("Tool") or tool:IsA("HopperBin") then tool:Destroy() end end
					end
				end
			end
		};
		RestoreGravity = {
			Commands = {"grav";"bringtoearth";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." restored grav to ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Torso") then 
						for a, frc in pairs(v.Character.Torso:children()) do 
							if frc.Name == "ADONIS_GRAVITY" then 
								frc:Destroy() 
							end 
						end
					end
				end
			end
		};
		SetGravity = {
			Commands = {"setgrav";"gravity";"setgravity";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." nograv'd ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Torso") then 
						for a, frc in pairs(v.Character.Torso:children()) do 
							if frc.Name == "ADONIS_GRAVITY" then 
								frc:Destroy() 
							end 
						end
						local frc = service.New("BodyForce", v.Character.Torso) 
						frc.Name = "ADONIS_GRAVITY" 
						frc.force = Vector3.new(0,0,0)
						for a, prt in pairs(v.Character:children()) do 
							if prt:IsA("BasePart") then 
								frc.force = frc.force - Vector3.new(0,prt:GetMass()*tonumber(args[2]),0) 
							elseif prt:IsA("Accoutrement") then 
								frc.force = frc.force - Vector3.new(0,prt.Handle:GetMass()*tonumber(args[2]),0) 
							end
						end
					end
				end
			end
		};
		NoGravity = {
			Commands = {"nograv";"nogravity";"superjump";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." set grav for ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v and v.Character and v.Character:findFirstChild("Torso") then 
						for a, frc in pairs(v.Character.Torso:children()) do 
							if frc.Name == "ADONIS_GRAVITY" then 
								frc:Destroy() 
							end 
						end
						local frc = service.New("BodyForce", v.Character.Torso) 
						frc.Name = "ADONIS_GRAVITY" 
						frc.force = Vector3.new(0,0,0)
						for a, prt in pairs(v.Character:children()) do 
							if prt:IsA("BasePart") then 
								frc.force = frc.force + Vector3.new(0,prt:GetMass()*196.25,0) 
							elseif prt:IsA("Accoutrement") then 
								frc.force = frc.force + Vector3.new(0,prt.Handle:GetMass()*196.25,0) 
							end 
						end
					end
				end
			end
		};
		Speed = {
			Commands = {"speed";"setspeed";"walkspeed";};
			Admins = true;
			Function = function(plr,args)
				assert(args[1],"Argument missing or nil")
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." set speed for ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Humanoid") then 
						v.Character.Humanoid.WalkSpeed = args[2] or 18
					end
				end
			end
		};
		SetTeam = {
			Commands = {"team";"setteam";"changeteam";};
			Admins = true;
			Function = function(plr,args)
				assert(args[1] and args[2],"Argument missing or nil")
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." set team for ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					for a, tm in pairs(game:getService("Teams"):children()) do
						if tm.Name:lower():sub(1,#args[2]) == args[2]:lower() then 
							v.TeamColor = tm.TeamColor 
						end
					end
				end
			end
		};	
		RandomTeam = {
			Commands = {"rteams","rteam","randomizeteams","randomteams","randomteam"};
			Admins = true;
			Function = function(plr,args)
				local tArgs = {}
				local teams = {}
				local players = service.GetPlayers(plr,args[1] or "all")
				local cTeam = 1
				gSendMSG("inF*",plr.Name.." randomized teams.")
				local function assign()
					local pIndex = math.random(1,#players)
					local player = players[pIndex]
					local team = teams[cTeam]
					cTeam = cTeam+1
					if cTeam > #teams then
						cTeam = 1
					end
					if player and player.Parent then
						player.TeamColor = team.TeamColor
					end
					table.remove(players,pIndex)
					if #players > 0 then 
						assign()
					end
				end
				if args[2] then
					for s in args[2]:gmatch("(%w+)") do 
						table.insert(tArgs,s)
					end
				end
				for i,team in pairs(service.Teams:GetChildren()) do
					if #tArgs > 0 then
						for ind,check in pairs(tArgs) do
							if team.Name:lower():sub(1,#check) == check:lower() then
								table.insert(teams,team)
							end
						end
					else
						table.insert(teams,team)
					end
				end
				cTeam = math.random(1,#teams)
				assign()
			end
		};
		NewTeam = {
			Commands = {"newteam","createteam","maketeam"};
			Admins = true;
			Function = function(plr,args)
				gSendMSG("inF*",plr.Name.." made a new team.")
			 	local color = BrickColor.new(math.random(1,227))
				if BrickColor.new(args[2])~=nil then color=BrickColor.new(args[2]) end
				local team=service.New("Team",service.Teams)
				team.Name=args[1]
				team.AutoAssignable=false
				team.TeamColor=color
			end
		};
		RemoveTeam = {
			Commands = {"removeteam";};
			Admins = true;
			Function = function(plr,args)
			 	for i,v in pairs(service.Teams:children()) do
					if v:IsA("Team") and v.Name:lower():sub(1,#args[1])==args[1]:lower() then
						gSendMSG("inF*",plr.Name.." removed team '".. v.Name .."'.")
						v:Destroy()
					end
				end
			end
		};
		SetFOV = {
			Commands = {"fov";"fieldofview";"setfov"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." set fov for ".. service.PlayerTableToString(players))
				local x=server.Core.NewScript("LocalScript",[[workspace.CurrentCamera.FieldOfView=]]..args[2])
				x.Name="NSH"
				for i,v in pairs(players) do
					local e=x:Clone()
					e.Parent=v.Character
					e.Disabled=false
				end
			end
		};
		FreeFall = {
			Commands = {"freefall";"skydive";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." freefalled ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v.Character:FindFirstChild('Torso') then 
						v.Character.Torso.CFrame = v.Character.Torso.CFrame+Vector3.new(0,tonumber(args[2]),0)
					end
				end
			end
		};
		Change = {
			Commands = {"change";"leaderstat";"stat";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." set stats for ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v:findFirstChild("leaderstats") then 
						for a, st in pairs(v.leaderstats:children()) do
							if st.Name:lower():find(args[2]:lower()) == 1 then 
								st.Value = args[3] 
							end
						end
					end
				end
			end
		};
		AddToStat = {
			Commands = {"add";"addtostat";"addstat";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." added stats for ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v:findFirstChild("leaderstats") then 
						for a, st in pairs(v.leaderstats:children()) do
							if st.Name:lower():find(args[2]:lower()) == 1 and tonumber(st.Value) then 
								st.Value = tonumber(st.Value)+tonumber(args[3]) 
							end
						end
					end
				end
			end
		};
		SubtractFromStat = {
			Commands = {"subtract";"minusfromstat";"minusstat";"subtractstat";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." subtracted stats for ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v:findFirstChild("leaderstats") then 
						for a, st in pairs(v.leaderstats:children()) do
							if st.Name:lower():find(args[2]:lower()) == 1 and tonumber(st.Value) then 
								st.Value = tonumber(st.Value)-tonumber(args[3]) 
							end
						end
					end
				end
			end
		};
		Bring = {
			Commands = {"bring";"tptome";};
			Admins = true;
			Function = function(plr,args)
				cmdserver.Commands.Teleport.Function(plr,{args[1],"me"})
			end
		};
		To = {
			Commands = {"to";"tpmeto";};
			Admins = true;
			Function = function(plr,args)
				cmdserver.Commands.Teleport.Function(plr,{"me",args[1]})
			end
		};
		Shirt = {
			Commands = {"shirt";"giveshirt";};
			Admins = true;
			Function = function(plr,args)
				--local image = server.Functions.GetTexture(args[2])
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." shirted ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if image then
						if v.Character and image then
							for g,k in pairs(v.Character:children()) do
								if k:IsA("Shirt") then k:Destroy() end
							end
							local x=Instance.new('Shirt',v.Character)
							if tonumber(args[2]) then
								x.ShirtTemplate="http://www.roblox.com/asset/?id=" .. args[2]
							else
								x.ShirtTemplate=args[2]
							end 
							--service.New('Shirt',v.Character).ShirtTemplate="http://www.roblox.com/asset/?id="..image
						end
					else
						for g,k in pairs(v.Character:children()) do
							if k:IsA("Shirt") then k:Destroy() end
						end
					end
				end
			end
		};
		Pants = {
			Commands = {"pants";"givepants";};
			Admins = true;
			Function = function(plr,args)
				--local image = server.Functions.GetTexture(args[2])
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." panted ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if image then
						if v.Character and image then 
							for g,k in pairs(v.Character:children()) do
								if k:IsA("Pants") then k:Destroy() end
							end
							local x=Instance.new('Pants',v.Character)
							if tonumber(args[2]) then
								x.PantsTemplate="http://www.roblox.com/asset/?id=" .. args[2]
							else
								x.PantsTemplate=args[2]
							end 
						end
					else
						for g,k in pairs(v.Character:children()) do
							if k:IsA("Pants") then k:Destroy() end
						end
					end
				end
			end
		};
		Face = {
			Commands = {"face";"giveface";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." faced ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					--local image=server.GetTexture(args[2])
					if not v.Character:FindFirstChild("Head") then 
						return 
					end
					if v.Character and v.Character:findFirstChild("Head") and v.Character.Head:findFirstChild("face") then 
						v.Character.Head:findFirstChild("face"):Destroy()--.Texture = "http://www.roblox.com/asset/?id=" .. args[2]
					end
					local x=Instance.new("Decal")
					x.Parent = v.Character:FindFirstChild("Head")
					if tonumber(args[2]) then
						x.Texture="http://www.roblox.com/asset/?id=" .. args[2]
					else
						x.Texture=args[2]
					end 
				end
			end
		};
		Swagify = {
			Commands = {"swagify";"swagger";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." swaged ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v.Character then
						for i,v in pairs(v.Character:children()) do
							if v.Name == "Shirt" then local cl = v:Clone() cl.Parent = v.Parent cl.ShirtTemplate = "http://www.roblox.com/asset/?id=109163376" v:Destroy() end
							if v.Name == "Pants" then local cl = v:Clone() cl.Parent = v.Parent cl.PantsTemplate = "http://www.roblox.com/asset/?id=109163376" v:Destroy() end
						end
						-- no not yet.. server.Functions.Cape(v,false,'Fabric','Pink',109301474)
					end
				end
			end
		};
		Hat = {
			Commands = {"hat";"givehat";};
			Admin=true;
			Function = function(plr,args)
				gSendMSG("inF*","Sorry.. "..plr.Name..". There is no stable method to insert hats in Finobe yet.")
			end
		};
		Shrek = {
			Commands = {"shrek";"shrekify";"shrekislife";"swamp";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." panted ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					yPcall(function()
						if v.Character and v.Character:FindFirstChild("Torso") then
							cmdserver.Commands.Shirt.Function(plr,{"me","133078195"})
							cmdserver.Commands.Pants.Function(plr,{"me","233373970"})
							--server.Admin.RunCommand(server.Settings.Prefix.."pants",v.Name,"233373970")
							--server.Admin.RunCommand(server.Settings.Prefix.."shirt",v.Name,"133078195")
							for i,v in pairs(v.Character:children()) do
								if v:IsA("Accoutrement") or v:IsA("CharacterMesh") then
									v:Destroy()
								end
							end
							--cmdserver.Commands.Hat.Function(plr,{"me","20011951"})
							--server.Admin.RunCommand(server.Settings.Prefix.."hat",v.Name,"20011951")
							local sound = Instance.new("Sound",v.Character.Torso)
							sound.SoundId = "http://www.roblox.com/asset/?id=130767645"
							wait(0.5)
							sound:Play()
						end
					end)
				end
			end
		};
		Rocket = {
			Commands = {"rocket";"firework";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." rocketed ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					cPcall(function()
						if v.Character and v.Character:FindFirstChild("Torso") then
							local speed = 10
							local Part = Instance.new("Part")
							Part.Parent = v.Character
							local SpecialMesh = Instance.new("SpecialMesh") 
							SpecialMesh.Parent = Part
							SpecialMesh.MeshId = "http://www.roblox.com/asset/?id=2251534" 
							SpecialMesh.MeshType = "FileMesh" 
							SpecialMesh.TextureId = "43abb6d081e0fbc8666fc92f6ff378c1" 
							SpecialMesh.Scale = Vector3.new(0.5,0.5,0.5)
							local Weld = Instance.new("Weld")
							Weld.Parent = Part
							Weld.Part0 = Part
							Weld.Part1 = v.Character.Torso
							Weld.C0 = CFrame.new(0,-1,0)*CFrame.Angles(-1.5,0,0)
							local BodyVelocity = Instance.new("BodyVelocity")
							BodyVelocity.Parent = Part
							BodyVelocity.maxForce = Vector3.new(math.huge,math.huge,math.huge)
							BodyVelocity.velocity = Vector3.new(0,100*speed,0)
							--[[
							cPcall(function()
								for i = 1,math.huge do
									local Explosion = Instance.new(("Explosion")
									Explosion.Parent = Part
									Explosion.BlastRadius = 0
									Explosion.Position = Part.Position + Vector3.new(0,0,0)
									wait()
								end 
							end)    
							--]]
							wait(5)
							BodyVelocity:remove()
							Instance.new("Explosion",service.Workspace).Position = v.Character.Torso.Position
							v.Character:BreakJoints()
						end
					end)
				end
			end
		};
		Puke = {
			Commands = {"puke";"barf";"throwup";"vomit";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." made ".. service.PlayerTableToString(players).." nausious.")
				for i,v in pairs(players) do
					cPcall(function()
						if (not v:IsA('Player')) or (not v) or (not v.Character) or (not v.Character:FindFirstChild('Head')) or v.Character:FindFirstChild('Epix Puke') then return end
						local run=true
						local k=Instance.new('StringValue',v.Character)
						k.Name='Epix Puke'
						Routine(function()
							repeat 
								wait(0.15)
								local p = Instance.new("Part",v.Character)
								p.CanCollide = false
								local color = math.random(1, 3)
								local bcolor
								if color == 1 then
									bcolor = BrickColor.new(192)
								elseif color == 2 then
									bcolor = BrickColor.new(28)
								elseif color == 3 then
									bcolor = BrickColor.new(105)
								end
								p.BrickColor = bcolor
								local m = Instance.new('BlockMesh',p)
								p.Size = Vector3.new(0.1,0.1,0.1)
								m.Scale = Vector3.new(math.random()*0.9, math.random()*0.9, math.random()*0.9)
								p.Locked = true
								p.TopSurface = "Smooth"
								p.BottomSurface = "Smooth"
								p.CFrame = v.Character.Head.CFrame * CFrame.new(Vector3.new(0, 0, -1))
								p.Velocity = v.Character.Head.CFrame.lookVector * 20 + Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
								p.Anchored = false
								m.Name = 'Puke Peice'
								p.Name = 'Puke Peice'
								p.Touched:connect(function(o)
									if o and p and (not service.Players:FindFirstChild(o.Parent.Name)) and o.Name~='Puke Peice' and o.Name~='Blood Peice' and o.Name~='Blood Plate' and o.Name~='Puke Plate' and (o.Parent.Name=='Workspace' or o.Parent:IsA('Model')) and (o.Parent~=p.Parent) and o:IsA('Part') and (o.Parent.Name~=v.Character.Name) and (not o.Parent:IsA('Accessory')) and (not o.Parent:IsA('Tool')) then
										local cf = CFrame.new(p.CFrame.X,o.CFrame.Y+o.Size.Y/2,p.CFrame.Z)
										p:Destroy()
										local g=Instance.new('Part',workspace)
										g.Anchored=true
										g.CanCollide=false
										g.Size=Vector3.new(0.1,0.1,0.1)
										g.Name='Puke Plate'
										g.CFrame=cf
										g.BrickColor=BrickColor.new(119)
										local c=Instance.new('CylinderMesh',g)
										c.Scale=Vector3.new(1,0.2,1)
										c.Name='PukeMesh'
										wait(10)
										g:Destroy()
									elseif o and o.Name=='Puke Plate' and p then 
										p:Destroy() 
										o.PukeMesh.Scale=o.PukeMesh.Scale+Vector3.new(0.5,0,0.5)
									end
								end)
							until run==false or not k or not k.Parent or (not v) or (not v.Character) or (not v.Character:FindFirstChild('Head'))
						end)
						wait(10)
						run = false
						k:Destroy()
					end)
				end
			end
		};
		Cut = {
			Commands = {"cut";"stab";"shank";"bleed";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." slit ".. service.PlayerTableToString(players).." wrists.")
				for i,v in pairs(players) do
					cPcall(function()
						if (not v:IsA('Player')) or (not v) or (not v.Character) or (not v.Character:FindFirstChild('Head')) or v.Character:FindFirstChild('Epix Bleed') then return end
						local run=true
						local k=Instance.new('StringValue',v.Character)
						k.Name='ADONIS_BLEED'
						Routine(function()
							repeat 
							wait(0.15)
							v.Character.Humanoid.Health=v.Character.Humanoid.Health-1
							local p = Instance.new("Part",v.Character)
							p.CanCollide = false
							local color = math.random(1, 3)
							local bcolor
							if color == 1 then
								bcolor = BrickColor.new(21)
							elseif color == 2 then
								bcolor = BrickColor.new(1004)
							elseif color == 3 then
								bcolor = BrickColor.new(21)
							end
							p.BrickColor = bcolor
							local m=Instance.new('BlockMesh',p)
							p.Size=Vector3.new(0.1,0.1,0.1)
							m.Scale = Vector3.new(math.random()*0.9, math.random()*0.9, math.random()*0.9)
							p.Locked = true
							p.TopSurface = "Smooth"
							p.BottomSurface = "Smooth"
							p.CFrame = v.Character.Torso.CFrame * CFrame.new(Vector3.new(2, 0, 0))
							p.Velocity = v.Character.Head.CFrame.lookVector * 1 + Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
							p.Anchored = false
							m.Name='Blood Peice'
							p.Name='Blood Peice'
							p.Touched:connect(function(o)
								if o and p and (not service.Players:FindFirstChild(o.Parent.Name)) and o.Name~='Blood Peice' and o.Name~='Puke Peice' and o.Name~='Puke Plate' and o.Name~='Blood Plate' and (o.Parent.Name=='Workspace' or o.Parent:IsA('Model')) and (o.Parent~=p.Parent) and o:IsA('Part') and (o.Parent.Name~=v.Character.Name) and (not o.Parent:IsA('Accessory')) and (not o.Parent:IsA('Tool')) then
									local cf=CFrame.new(p.CFrame.X,o.CFrame.Y+o.Size.Y/2,p.CFrame.Z)
									p:Destroy()
									local g=Instance.new('Part',service.Workspace)
									g.Anchored=true
									g.CanCollide=false
									g.Size=Vector3.new(0.1,0.1,0.1)
									g.Name='Blood Plate'
									g.CFrame=cf
									g.BrickColor=BrickColor.new(21)
									local c=service.New('CylinderMesh',g)
									c.Scale=Vector3.new(1,0.2,1)
									c.Name='BloodMesh'
									wait(10)
									g:Destroy()
								elseif o and o.Name=='Blood Plate' and p then 
									p:Destroy() 
									o.BloodMesh.Scale=o.BloodMesh.Scale+Vector3.new(0.5,0,0.5)
								end
							end)
							until run==false or not k or not k.Parent or (not v) or (not v.Character) or (not v.Character:FindFirstChild('Head'))
						end)
						wait(10)
						run=false
						k:Destroy()
					end)
				end
			end
		};
		Poison = {
			Commands = {"poison";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." poisoned ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					Routine(function()
						local torso=v.Character:FindFirstChild('Torso')
						local larm=v.Character:FindFirstChild('Left Arm')
						local rarm=v.Character:FindFirstChild('Right Arm')
						local lleg=v.Character:FindFirstChild('Left Leg')
						local rleg=v.Character:FindFirstChild('Right Leg')
						local head=v.Character:FindFirstChild('Head')
						local hum=v.Character:FindFirstChild('Humanoid')
						if torso and larm and rarm and lleg and rleg and head and hum and not v.Character:FindFirstChild('EpixPoisoned') then
							local poisoned=service.New('BoolValue',v.Character)
							poisoned.Name='EpixPoisoned'
							poisoned.Value=true
							local tor=torso.BrickColor
							local lar=larm.BrickColor
							local rar=rarm.BrickColor
							local lle=lleg.BrickColor
							local rle=rleg.BrickColor
							local hea=head.BrickColor
							torso.BrickColor=BrickColor.new('Br. yellowish green')
							larm.BrickColor=BrickColor.new('Br. yellowish green')
							rarm.BrickColor=BrickColor.new('Br. yellowish green')
							lleg.BrickColor=BrickColor.new('Br. yellowish green')
							rleg.BrickColor=BrickColor.new('Br. yellowish green')
							head.BrickColor=BrickColor.new('Br. yellowish green')
							local run=true
							coroutine.wrap(function() wait(10) run=false end)()
							repeat
								wait(1)
								hum.Health=hum.Health-5
							until (not poisoned) or (not poisoned.Parent) or (not run)
							if poisoned and poisoned.Parent then
								torso.BrickColor=tor
								larm.BrickColor=lar
								rarm.BrickColor=rar
								lleg.BrickColor=lle
								rleg.BrickColor=rle
								head.BrickColor=hea
							end
						end
					end)
				end
			end
		};
		Drug = {
			Commands = {"drug";"intoxicate";};
			Admins = true;
			Function = function(plr,args)
				local scr = server.Core.NewScript("LocalScript",[==[local msgs={
  {
    Msg='We need more..... philosophy... ya know?',
    Color=Enum.ChatColor.Green
  },{
  Msg='OH MY GOD STOP TRYING TO EAT MY SOUL',
  Color=Enum.ChatColor.Red
},{
Msg='I.... CANT.... FEEL.... MY FACE',
Color=Enum.ChatColor.Red
},{
Msg='DO YOU SEE THE TURTLE?!?!',
Color=Enum.ChatColor.Red
},{
Msg='Omg puff the magic dragon!!!!',
Color=Enum.ChatColor.Green
},{
Msg='Omg double wat',
Color=Enum.ChatColor.Blue
},{
Msg='WHO STOLE MY LEGS',
Color=Enum.ChatColor.Red
},{
Msg='I... I think I might be dead....',
Color=Enum.ChatColor.Blue
},{
Msg="I'M GOING TO EAT YOUR FACE",
Color=Enum.ChatColor.Red
},{
Msg='Hey... Like... What if, like, listen, are you listening? What if.. like.. earth.. was a ball?',
Color=Enum.ChatColor.Green
},{
Msg='WHY IS EVERYBODY TALKING SO LOUD AHHHHHH',
Color=Enum.ChatColor.Red
},{
Msg='Woooo man do you see the elephent... theres an elephent man..its... PURPLE OHMY GOD ITS A SIGN FROM LIKE THE WARDROBE..',
Color=Enum.ChatColor.Blue
}}
local head = script.Parent.Parent.Head
local hum = script.Parent.Parent.Humanoid
local torso = script.Parent
local chat = game:GetService("Chat")
local val = Instance.new('StringValue',head)
local old = math.random()
local stop = false
hum.Died:connect(function()
stop = true
wait(0.5)
workspace.CurrentCamera.FieldOfView = 70
end)
coroutine.wrap(function()
while not stop and head and val and val.Parent==head do
local new=math.random(1,#msgs)
for k,m in pairs(msgs) do
if new==k then
if old~=new then
old=new
print(m.Msg)
chat:Chat(head,m.Msg,m.Color)
end
end
end
wait(5)
end
end)()
hum.WalkSpeed=-16
local startspaz = false
coroutine.wrap(function()
repeat
wait(0.1)
workspace.CurrentCamera.FieldOfView = math.random(20,80)
hum.Health = hum.Health-0.5
if startspaz then
hum.PlatformStand = true
torso.Velocity = Vector3.new(math.random(-10,10),-5,math.random(-10,10))
torso.RotVelocity = Vector3.new(math.random(-5,5),math.random(-5,5),math.random(-5,5))
end
until stop or not hum or not hum.Parent or hum.Health<=0 or not torso
end)()
wait(10)
local bg = Instance.new("BodyGyro", torso)
bg.Name = "SPINNER"
bg.maxTorque = Vector3.new(0,math.huge,0)
bg.P = 11111
bg.cframe = torso.CFrame
coroutine.wrap(function()
repeat wait(1/44)
bg.cframe = bg.cframe * CFrame.Angles(0,math.rad(30),0)
until stop or not bg or bg.Parent ~= torso
end)()
wait(20)
startspaz = true]==])
				scr.Name = "DrugsAreBadKids"
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." drugged ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					local new = scr:Clone()
					new.Parent = v.Character.Torso
					new.Disabled = false
				end
			end
		};
		Salem = {
			Commands = {"witchtrial";"stakeburn";"burnatthestake";"salem";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." submitted ".. service.PlayerTableToString(players) .." for witchtrial.")
				for i,v in pairs(players) do
					Routine(function()
						local char = v.Character
						local hum = char.Humanoid
						for k,c in pairs(char:children()) do 
							if c:IsA("Part") and c.Name~="Torso" then 
								c.Anchored=true 
							end 
						end
						hum.HealthDisplayDistance = 0 --y no twurk
						--server.Admin.RunCommand(server.Settings.Prefix.."god",v.Name)
						local stake = Instance.new("Part",char)
						stake.Anchored = true
						stake.BrickColor = BrickColor.new("Reddish brown")
						stake.Material = "Wood"
						stake.Size = Vector3.new(1,7,1)
						stake.CFrame = char.Torso.CFrame*CFrame.new(0,0,1)
						local hay = Instance.new("Part",char)
						hay.Anchored = true
						hay.Material = "Grass"
						hay.BrickColor = BrickColor.new("New Yeller")
						hay.Size = Vector3.new(6,1,5)
						hay.CFrame = char.Torso.CFrame*CFrame.new(0,-3,0)*CFrame.Angles(0,2,0)
						local hay2 = hay:clone()
						hay2.Parent = char
						hay2.CFrame = char.Torso.CFrame*CFrame.new(0,-2.6,0)*CFrame.Angles(0,6,0)
						local fire = Instance.new("Fire",hay)
						fire.Enabled = false
						fire.Heat = 25
						fire.Size = 2
						fire.Color = Color3.new(170/255,85/255,0)
						local smoke = Instance.new("Smoke",hay)
						smoke.Enabled = false
						smoke.Opacity = 1
						smoke.RiseVelocity = 25
						smoke.Size = 15
						smoke.Color = Color3.new(0,0,0)
						local crack = Instance.new("Sound",hay)
						crack.SoundId = "rbxassetid://239443642"
						crack.Looped = true
						crack.Volume = 0
						local scream = Instance.new("Sound",char.Torso)
						scream.SoundId = "rbxassetid://264227115"
						scream.Looped = true
						scream.Volume = 0
						--]]
						wait()
						char['Left Arm'].CFrame = char.Torso.CFrame * CFrame.new(-0.8,0,0.7) * CFrame.Angles(-1,0,0.5)
						char['Right Arm'].CFrame = char.Torso.CFrame * CFrame.new(0.8,0,0.7) * CFrame.Angles(-1,0,-0.5)
						local bods = char['Body Colors']
						local colors = {
							--"Really red";
							"Bright red";
							"Crimson";
							"Maroon";
							"Really black";
						}
						fire.Enabled=true
						smoke.Enabled=true
						light.Enabled=true
						crack:Play()
						scream:Play()
						scream.Pitch = 0.8
						--scream.Volume = 0.5
						for i=1,30 do
							crack.Volume = crack.Volume+(1/30)
							scream.Volume = crack.Volume
							fire.Size=i
							smoke.RiseVelocity=i-5
							smoke.Size=i/2
							light.Range=i*2
							wait(1)
						end
						for i=1,#colors do
							bods.HeadColor=BrickColor.new(colors[i])
							bods.LeftArmColor=BrickColor.new(colors[i])
							bods.LeftLegColor=BrickColor.new(colors[i])
							bods.RightArmColor=BrickColor.new(colors[i])
							bods.RightLegColor=BrickColor.new(colors[i])
							bods.TorsoColor=BrickColor.new(colors[i])
							hay.BrickColor=BrickColor.new(colors[i])
							hay2.BrickColor=BrickColor.new(colors[i])
							stake.BrickColor=BrickColor.new(colors[i])
							wait(5)
						end
						wait(10)
						scream.Volume = 0.5
						wait(1)
						scream:Stop()
						char:BreakJoints()
					end)
				end
			end
		};
		Stickify = {
			Commands = {"stickify";"stick";"stickman";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." stickified ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					local m = player.Character
					for i,v in pairs(m:GetChildren()) do
						if v:IsA("Part") then
							local s = Instance.new("SelectionPartLasso")
							s.Parent = m.Torso
							s.Part = v
							s.Humanoid = m.Humanoid
							s.Color = BrickColor.new(0,0,0)
							v.Transparency = 1
							m.Head.Transparency = 0
							m.Head.Mesh:Remove()
							local b = Instance.new("SpecialMesh")
							b.Parent = m.Head
							b.MeshType = "Sphere"
							b.Scale = Vector3.new(0.5,1,1)
							m.Head.BrickColor = BrickColor.new("Black")
						end 
					end
				end 
			end
		};
		Hole = {
			Commands = {"hole";"sparta";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." holed ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					Routine(function()
						local torso = player.Character:FindFirstChild('Torso')
						if torso then
							local hole = Instance.new("Part",player.Character)
							hole.Anchored = true
							hole.CanCollide = false
							hole.formFactor = Enum.FormFactor.Custom
							hole.Size = Vector3.new(10,1,10)
							hole.CFrame = torso.CFrame * CFrame.new(0,-3.3,-3)
							hole.BrickColor = BrickColor.new("Really black")
							local holeM = Instance.new("CylinderMesh",hole)
							torso.Anchored = true
							local foot = torso.CFrame * CFrame.new(0,-3,0)
							for i=1,10 do
								torso.CFrame = foot * CFrame.fromEulerAnglesXYZ(-(math.pi/2)*i/10,0,0) * CFrame.new(0,3,0)
								wait(0.1)
							end
							for i=1,5,0.2 do
								torso.CFrame = foot * CFrame.new(0,-(i^2),0) * CFrame.fromEulerAnglesXYZ(-(math.pi/2),0,0) * CFrame.new(0,3,0)
								wait()
							end
							player.Character:BreakJoints()
						end
					end)
				end
			end
		};
		Lightning = {
			Commands = {"lightning";"smite";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." called god on ".. service.PlayerTableToString(players).." to express their sins.")
				for i,v in pairs(players) do
					cPcall(function()
						--server.Admin.RunCommand(server.Settings.Prefix.."freeze",v.Name)
						local char = v.Character
						local zeus = Instance.new("Model",char)
						local cloud = Instance.new("Part",zeus)
						cloud.Anchored = true
						cloud.CanCollide = false
						cloud.CFrame = char.Torso.CFrame*CFrame.new(0,25,0)
						local sound = Instance.new("Sound",cloud)
						sound.SoundId = "rbxassetid://133426162"
						local mesh = Instance.new("SpecialMesh",cloud)
						mesh.MeshId = "http://www.roblox.com/asset/?id=1095708"
						mesh.TextureId = "http://www.roblox.com/asset/?id=1095709"
						mesh.Scale = Vector3.new(30,30,40)
						mesh.VertexColor = Vector3.new(0.3,0.3,0.3)
						local light = Instance.new("PointLight",cloud)
						light.Color = Color3.new(0,85/255,1)
						light.Brightness = 10
						light.Range = 30
						light.Enabled = false
						wait(0.2)
						sound.Volume = 0.5
						sound.Pitch = 0.8
						sound:Play()
						light.Enabled = true
						wait(1/100)
						light.Enabled = false
						wait(0.2)
						light.Enabled = true
						light.Brightness = 1
						wait(0.05)
						light.Brightness = 3
						wait(0.02)
						light.Brightness = 1
						wait(0.07)
						light.Brightness = 10
						wait(0.09)
						light.Brightness = 0
						wait(0.01)
						light.Brightness = 7
						light.Enabled = false
						wait(1.5)
						local part1 = Instance.new("Part",zeus)
						part1.Anchored = true
						part1.CanCollide = false
						part1.Size = Vector3.new(2, 9.2, 1)
						part1.BrickColor = BrickColor.new("New Yeller")
						part1.Transparency = 0.6
						part1.BottomSurface = "Smooth"
						part1.TopSurface = "Smooth"
						part1.CFrame = char.Torso.CFrame*CFrame.new(0,15,0)
						part1.Rotation = Vector3.new(0.359, 1.4, -14.361)
						wait()
						local part2 = part1:clone()
						part2.Parent = zeus
						part2.Size = Vector3.new(1, 7.48, 2)
						part2.CFrame = char.Torso.CFrame*CFrame.new(0,7.5,0)
						part2.Rotation = Vector3.new(77.514, -75.232, 78.051)
						wait()
						local part3 = part1:clone()
						part3.Parent = zeus
						part3.Size = Vector3.new(1.86, 7.56, 1)
						part3.CFrame = char.Torso.CFrame*CFrame.new(0,1,0)
						part3.Rotation = Vector3.new(0, 0, -11.128)
						sound.SoundId = "rbxassetid://130818250"
						sound.Volume = 1
						sound.Pitch = 1
						sound:Play()
						wait()
						part1.Transparency = 1
						part2.Transparency = 1
						part3.Transparency = 1
						Instance.new("Smoke",char.Torso).Color = Color3.new(0,0,0)
						char:BreakJoints()
					end)
				end
			end
		};
		Spin = {
			Commands = {"spin";};
			Admins = true;
			Function = function(plr,args)
				local scr = server.Core.NewScript("LocalScript",[==[local torso = script.Parent
local bg = Instance.new("BodyGyro", torso)
bg.Name = "SPINNER"
bg.maxTorque = Vector3.new(0,math.huge,0)
bg.P = 11111
bg.cframe = torso.CFrame
repeat
  wait(1/44)
  bg.cframe = bg.cframe * CFrame.Angles(0,math.rad(30),0)
until not bg or bg.Parent ~= torso]==])
				scr.Name = "SPINNER"
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." gave ".. service.PlayerTableToString(players).." a spin for eterenty.")
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Torso") then
						for i,v in pairs(v.Character.Torso:children()) do 
							if v.Name == "SPINNER" then 
								v:Destroy() 
							end 
						end
						local new = scr:Clone()
						new.Parent = v.Character.Torso
						new.Disabled = false
					end
				end
			end
		};
		UnSpin = {
			Commands = {"unspin";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." undone their spin spell to ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Torso") then
						for a,q in pairs(v.Character.Torso:children()) do 
							if q.Name == "SPINNER" then 
								q:Destroy() 
							end 
						end
					end
				end
			end
		};
		Dog = {
			Commands = {"dog";"dogify";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." dog'd ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					Routine(function()
						if v and v.Character and v.Character:findFirstChild("Torso") then
							if v.Character:findFirstChild("Shirt") then 
								v.Character.Shirt.Parent = v.Character.Torso 
							end
							if v.Character:findFirstChild("Pants") then 
								v.Character.Pants.Parent = v.Character.Torso 
							end
							v.Character.Torso.Transparency = 1
							v.Character.Torso.Neck.C0 = CFrame.new(0,-.5,-2) * CFrame.Angles(math.rad(90),math.rad(180),0)
							v.Character.Torso["Right Shoulder"].C0 = CFrame.new(.5,-1.5,-1.5) * CFrame.Angles(0,math.rad(90),0)
							v.Character.Torso["Left Shoulder"].C0 = CFrame.new(-.5,-1.5,-1.5) * CFrame.Angles(0,math.rad(-90),0)
							v.Character.Torso["Right Hip"].C0 = CFrame.new(1.5,-1,1.5) * CFrame.Angles(0,math.rad(90),0)
							v.Character.Torso["Left Hip"].C0 = CFrame.new(-1.5,-1,1.5) * CFrame.Angles(0,math.rad(-90),0)
							local new = Instance.new("Seat", v.Character) 
							new.Name = "FAKETORSO" 
							new.formFactor = "Symmetric" 
							new.TopSurface = 0 
							new.BottomSurface = 0 
							new.Size = Vector3.new(3,1,4)
							new.CFrame = v.Character.Torso.CFrame
							local bf = Instance.new("BodyForce", new) 
							bf.force = Vector3.new(0,new:GetMass()*196.25,0)
							local weld = Instance.new("Weld", v.Character.Torso) 
							weld.Part0 = v.Character.Torso
							weld.Part1 = new 
							weld.C0 = CFrame.new(0,-.5,0)
							for a, part in pairs(v.Character:children()) do 
								if part:IsA("BasePart") then 
									part.BrickColor = BrickColor.new("Brown") 
								elseif part:findFirstChild("NameTag") then 
									part.Head.BrickColor = BrickColor.new("Brown") 
								end 
							end
						end
					end)
				end
			end
		};
		Dogg = {
			Commands = {"dogg";"snoop";"snoopify";"dodoubleg";};
			Admins = true;
			Function = function(plr,args)
				local cl = server.Core.NewScript("LocalScript",[==[local textures = {
  131395838;
  131395847;
  131395855;
  131395860;
  131395868;
  131395884;
  131395884;
  131395891;
  131395897;
  131395901;
  131395946;
  131395957;
  131395966;
  131395972;
  131395979;
  131395986;
  131395989;
  131395993;
  131395997;
  131396003;
  131396007;
  131396012;
  131396016;
  131396019;
  131396024;
  131396029;
  131396037;
  131396042;
  131396044;
  131396046;
  131396054;
  131396063;
  131396068;
  131396072;
  131396078;
  131396091;
  131396098;
  131396102;
  131396108;
  131396110;
  131396113;
  131396116;
  131396121;
  131396125;
  131396133;
  131396137;
  131396142;
  131396146;
  131396156;
  131396162;
  131396164;
  131396169;
  131396173;
  131396176;
  131396181;
  131396185;
  131396188;
  131396192;
}
while true do
  for i=1,#textures do
    script.Parent.Texture = "http://www.roblox.com/asset/?id="..textures[i]
    wait(0.05)
  end
end]==])
				local mesh = Instance.new("BlockMesh")
				mesh.Scale = Vector3.new(2,3,0.1)
				local decal1 = Instance.new("Decal")
				decal1.Face = "Back"
				decal1.Texture = "http://www.roblox.com/asset/?id=131396137"
				decal1.Name = "Snoop"
				cl.Name = "Animator"
				local decal2 = decal1:Clone()
				decal2.Face = "Front"
				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://137545053"
				sound.Looped = true
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." dogg'd ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					for k,p in pairs(v.Character.Torso:GetChildren()) do 
						if p:IsA("Decal") or p:IsA("Sound") then 
							p:Destroy() 
						end
					end
					local sound = sound:Clone()
					local decal1 = decal1:Clone()
					local decal2 = decal2:Clone()
					local mesh = mesh:Clone()
					cmdserver.Commands.RemoveHats.Function(plr,"me")--server.Admin.RunCommand(server.Settings.Prefix.."removehats",v.Name)
					cmdserver.Commands.Invisible.Function(plr,"me")
					v.Character.Head.Transparency = 0.9
					v.Character.Head.Mesh.Scale = Vector3.new(0.01,0.01,0.01)
					cl:Clone().Parent = decal1
					cl:Clone().Parent = decal2
					decal1.Parent = v.Character.Torso
					decal2.Parent = v.Character.Torso
					sound.Parent = v.Character.Torso
					mesh.Parent = v.Character.Torso
					decal1.Animator.Disabled = false
					decal2.Animator.Disabled = false
					sound:Play()
				end
			end
		};
		Sp00ky = {
			Commands = {"sp00ky";"spooky";"spookyscaryskeleton";};
			Admin=true;
			Function = function(plr,args)
				local cl = server.Core.NewScript("LocalScript",[==[while true do
  script.Parent.Texture = "http://www.roblox.com/asset/?id=183747849"
  wait(0.05)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=183747854"
  wait(0.05)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=183747863"
  wait(0.05)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=183747870"
  wait(0.05)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=183747877"
  wait(0.05)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=183747879"
  wait(0.05)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=183747885"
  wait(0.05)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=183747890"
  wait(0.05)
end]==])
				local mesh = Instance.new("BlockMesh")
				mesh.Scale = Vector3.new(2,3,0.1)
				local decal1 = Instance.new("Decal")
				decal1.Face = "Back"
				decal1.Texture = "http://www.roblox.com/asset/?id=183747890"
				decal1.Name = "Snoop"
				cl.Name = "Animator"
				local decal2 = decal1:Clone()
				decal2.Face = "Front"
				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://174270407"
				sound.Looped = true
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." sp00k'd ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					for k,p in pairs(v.Character.Torso:GetChildren()) do 
						if p:IsA("Decal") or p:IsA("Sound") then 
							p:Destroy() 
						end
					end
					local sound = sound:Clone()
					local decal1 = decal1:Clone()
					local decal2 = decal2:Clone()
					local mesh = mesh:Clone()
					cmdserver.Commands.RemoveHats.Function(plr,"me")--server.Admin.RunCommand(server.Settings.Prefix.."removehats",v.Name)
					cmdserver.Commands.Invisible.Function(plr,"me")
					v.Character.Head.Transparency = 0.9
					v.Character.Head.Mesh.Scale = Vector3.new(0.01,0.01,0.01)
					cl:Clone().Parent = decal1
					cl:Clone().Parent = decal2
					decal1.Parent = v.Character.Torso
					decal2.Parent = v.Character.Torso
					sound.Parent = v.Character.Torso
					mesh.Parent = v.Character.Torso
					decal1.Animator.Disabled = false
					decal2.Animator.Disabled = false
					sound:Play()
				end
			end
		};
		K1tty = {
			Commands = {"k1tty";"cut3";};
			Admins = true;
			Function = function(plr,args)
				local cl = server.Core.NewScript("LocalScript",[==[while true do
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224764"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224790"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224800"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224820"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224830"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224844"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224861"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224899"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224924"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=280224955"
  wait(0.1)
end]==])
				local mesh = Instance.new("BlockMesh")
				mesh.Scale = Vector3.new(2,3,0.1)
				local decal1 = Instance.new("Decal")
				decal1.Face = "Back"
				decal1.Texture = "http://www.roblox.com/asset/?id=280224764"
				decal1.Name = "Snoop"
				cl.Name = "Animator"
				local decal2 = decal1:Clone()
				decal2.Face = "Front"
				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://179393562"
				sound.Looped = true
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." kitty'd ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					for k,p in pairs(v.Character.Torso:GetChildren()) do 
						if p:IsA("Decal") or p:IsA("Sound") then 
							p:Destroy() 
						end
					end
					local sound = sound:Clone()
					local decal1 = decal1:Clone()
					local decal2 = decal2:Clone()
					local mesh = mesh:Clone()
					cmdserver.Commands.RemoveHats.Function(plr,"me")--server.Admin.RunCommand(server.Settings.Prefix.."removehats",v.Name)
					cmdserver.Commands.Invisible.Function(plr,"me")
					v.Character.Head.Transparency = 0.9
					v.Character.Head.Mesh.Scale = Vector3.new(0.01,0.01,0.01)
					cl:Clone().Parent = decal1
					cl:Clone().Parent = decal2
					decal1.Parent = v.Character.Torso
					decal2.Parent = v.Character.Torso
					sound.Parent = v.Character.Torso
					mesh.Parent = v.Character.Torso
					decal1.Animator.Disabled = false
					decal2.Animator.Disabled = false
					sound:Play()
				end
			end
		};
		Nyan = {
			Commands = {"nyan";"p0ptart"};
			Admins = true;
			Function = function(plr,args)
				local cl = server.Core.NewScript("LocalScript",[==[local textures = {
  332277948;
  332277937;
  332277919;
  332277904;
  332277885;
  332277870;
  332277851;
  332277835;
  332277820;
  332277809;
  332277789;
  332277963;
}
while true do
  for i=1,#textures do
    script.Parent.Texture = "http://www.roblox.com/asset/?id="..textures[i]
    wait(0.1)
  end
end]==])
				local c2 = server.Core.NewScript("LocalScript",[==[local textures = {
  332288373;
  332288356;
  332288314;
  332288287;
  332288276;
  332288249;
  332288224;
  332288207;
  332288184;
  332288163;
  332288144;
  332288125;
}
while true do
  for i=1,#textures do
    script.Parent.Texture = "http://www.roblox.com/asset/?id="..textures[i]
    wait(0.1)
  end
end]==])
				local mesh = Instance.new("BlockMesh")
				mesh.Scale = Vector3.new(0.1,4.8,20)
				local decal1 = Instance.new("Decal")
				decal1.Face = "Left"
				decal1.Texture = "http://www.roblox.com/asset/?id=332277963"
				decal1.Name = "Nyan"
				local decal2=decal1:clone()
				decal2.Face = "Right"
				decal2.Texture = "http://www.roblox.com/asset/?id=332288373"
				cl.Name = "Animator"
				c2.Name = "Animator"
				local sound = service.New("Sound")
				sound.SoundId = "rbxassetid://265125691"
				sound.Looped = true
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." nyan'd ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					for k,p in pairs(v.Character.Torso:GetChildren()) do 
						if p:IsA("Decal") or p:IsA("Sound") then 
							p:Destroy() 
						end
					end
					local sound = sound:Clone()
					local decal1 = decal1:Clone()
					local decal2 = decal2:Clone()
					local mesh = mesh:Clone()
					cmdserver.Commands.RemoveHats.Function(plr,"me")--server.Admin.RunCommand(server.Settings.Prefix.."removehats",v.Name)
					cmdserver.Commands.Invisible.Function(plr,"me")
					v.Character.Head.Transparency = 0.9
					v.Character.Head.Mesh.Scale = Vector3.new(0.01,0.01,0.01)
					cl:Clone().Parent = decal1
					c2:Clone().Parent = decal2
					decal1.Parent = v.Character.Torso
					decal2.Parent = v.Character.Torso
					sound.Parent = v.Character.Torso
					mesh.Parent = v.Character.Torso
					decal1.Animator.Disabled = false
					decal2.Animator.Disabled = false
					sound:Play()
				end
			end
		};
		Fr0g = {
			Commands = {"fr0g";"fr0ggy";"mlgfr0g";"mlgfrog";};
			Admins = true;
			Function = function(plr,args)
				local cl = server.Core.NewScript("LocalScript",[==[while true do
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945467"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945486"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945493"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945515"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945527"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945553"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945573"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945588"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945612"
  wait(0.1)
  script.Parent.Texture = "http://www.roblox.com/asset/?id=185945634"
  wait(0.1)
end]==])
				local mesh = Instance.new("BlockMesh")
				mesh.Scale = Vector3.new(2,3,0.1)
				local decal1 = Instance.new("Decal")
				decal1.Face = "Back"
				decal1.Texture = "http://www.roblox.com/asset/?id=185945467"
				decal1.Name = "Fr0g"
				cl.Name = "Animator"
				local decal2 = decal1:Clone()
				decal2.Face = "Front"
				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://149690685"
				sound.Looped = true
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." fr0g'd ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					for k,p in pairs(v.Character.Torso:GetChildren()) do 
						if p:IsA("Decal") or p:IsA("Sound") then 
							p:Destroy() 
						end
					end
					local sound = sound:Clone()
					local decal1 = decal1:Clone()
					local decal2 = decal2:Clone()
					local mesh = mesh:Clone()
					cmdserver.Commands.RemoveHats.Function(plr,"me")--server.Admin.RunCommand(server.Settings.Prefix.."removehats",v.Name)
					cmdserver.Commands.Invisible.Function(plr,"me")
					v.Character.Head.Transparency = 0.9
					v.Character.Head.Mesh.Scale = Vector3.new(0.01,0.01,0.01)
					cl:Clone().Parent = decal1
					cl:Clone().Parent = decal2
					decal1.Parent = v.Character.Torso
					decal2.Parent = v.Character.Torso
					sound.Parent = v.Character.Torso
					mesh.Parent = v.Character.Torso
					decal1.Animator.Disabled = false
					decal2.Animator.Disabled = false
					sound:Play()
				end
			end
		};
		Sh1a = {
			Commands = {"sh1a";"lab00f";"sh1alab00f";"shia"};
			Admin=true;
			Function = function(plr,args)
				local cl = server.Core.NewScript("LocalScript",[==[local frames = {
  286117283;
  286117453;
  286117512;
  286117584;
  286118200;
  286118256;
  --[[286118366;]]
  286118468;
  286118598;
  286118637;
  286118670;
  286118709;
  286118755;
  286118810;
  286118862;
}
while true do
  for n,id in next,frames do
    script.Parent.Texture = "http://www.roblox.com/asset/?id="..id
    wait(0.1)
  end
end]==])
				local mesh = Instance.new("BlockMesh")
				mesh.Scale = Vector3.new(2,3,0.1)
				local decal1 = Instance.new("Decal")
				decal1.Face = "Back"
				decal1.Texture = "http://www.roblox.com/asset/?id=286117283"
				decal1.Name = "Shia"
				local decal2 = decal1:Clone()
				decal2.Face = "Front"
				local sound = Instance.new("Sound")
				sound.SoundId = "rbxassetid://259702986"
				sound.Looped = true
				cl.Name = "Animator"
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." sh1a'd ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					for k,p in pairs(v.Character.Torso:GetChildren()) do 
						if p:IsA("Decal") or p:IsA("Sound") then 
							p:Destroy() 
						end
					end
					local sound = sound:Clone()
					local decal1 = decal1:Clone()
					local decal2 = decal2:Clone()
					local mesh = mesh:Clone()
					cmdserver.Commands.RemoveHats.Function(plr,"me")--server.Admin.RunCommand(server.Settings.Prefix.."removehats",v.Name)
					cmdserver.Commands.Invisible.Function(plr,"me")
					v.Character.Head.Transparency = 0.9
					v.Character.Head.Mesh.Scale = Vector3.new(0.01,0.01,0.01)
					cl:Clone().Parent = decal1
					cl:Clone().Parent = decal2
					decal1.Parent = v.Character.Torso
					decal2.Parent = v.Character.Torso
					sound.Parent = v.Character.Torso
					mesh.Parent = v.Character.Torso
					decal1.Animator.Disabled = false
					decal2.Animator.Disabled = false
					sound:Play()
				end
			end
		};
		RemoveHats = {
			Commands = {"removehats";"nohats";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." removed ".. service.PlayerTableToString(players).. " hats.")
				for i,v in pairs(players) do
					for i,v in pairs(p.Character:children()) do
						if v:IsA("Accoutrement") or v:IsA("Hat") then
							v:Destroy()
						end
					end
				end
			end
		};
		Brightness = {
			Commands = {"brightness";};
			Admins = true;
			Function = function(plr,args)
				gSendMSG("inF*",plr.Name.." set the brightness.")
				game:getService("Lighting").Brightness=args[1]
			end
		};
		Explode = {
			Commands = {"explode";"boom";"boomboom";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." blew up ".. service.PlayerTableToString(players))
				for i,v in pairs(players) do
					if v.Character and v.Character:FindFirstChild("Torso") then 
						local ex = Instance.new("Explosion", workspace) 
						ex.Position = v.Character.Torso.Position
						ex.BlastRadius = args[2] or 3
						ex.BlastPressure = args[3] or 3
					end
				end
			end
		};
		Respawn = {
			Commands = {"respawn";"re"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." respawned ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					v:LoadCharacter()
				end
			end
		};
		Teleport = {
			Commands = {"tp"};
			Admins = true;
			Function = function(plr,args)
				local target = service.GetPlayers(plr,args[2])[1]
				local players = service.GetPlayers(plr,args[1])
				if #players == 1 and players[1] == target then
					local n = players[1]
					if n.Character:FindFirstChild("Torso") and target.Character:FindFirstChild("Torso") then
						n.Character.Humanoid.Jump = true
						wait()
						n.Character.Torso.CFrame = (target.Character.Torso.CFrame*CFrame.Angles(0,math.rad(90/#players*1),0)*CFrame.new(5+.2*#players,0,0))*CFrame.Angles(0,math.rad(90),0)
						gSendMSG("inF*",plr.Name.." teleported ".. n.Name .." to ".. target.Name ..".")
					end
				else
					for k,n in pairs(players) do
						if n~=target then
							--if n.Character.Humanoid.Sit then
							--	n.Character.Humanoid.Sit = false
							--	wait(0.5)
							--end
							n.Character.Humanoid.Jump = true
							wait()
							if n.Character:FindFirstChild("Torso") and target.Character:FindFirstChild("Torso") then
								n.Character.Torso.CFrame = (target.Character.Torso.CFrame*CFrame.Angles(0,math.rad(90/#players*k),0)*CFrame.new(5+.2*#players,0,0))*CFrame.Angles(0,math.rad(90),0)
							end							
						end
					end
					gSendMSG("inF*",plr.Name.." teleported ".. service.PlayerTableToString(players) .." to ".. target.Name ..".")
				end
			end
		};
		Message = {
			Commands = {"m";"msg"};
			Admins = true;
			Function = function(plr,args)
				local str=table.concat(args," ")
				gSendMSG("inF*",plr.Name.." : "..str)
				local m=Instance.new("Message")
				game:getService("Debris"):AddItem(m,5)
				m.Text=plr.Name..": "..str
				m.Parent=workspace
			end
		};
		EnergyCell = {
			Commands = {"kms","fml","reset","energycell","ec","allahuackbar","allahuakbar","heil","hail","rr","russianroulette","cancer","bleach","cut"};
			Admins = false;
			Function = function(plr,args)
				plr.Character:BreakJoints()
				gSendMSG("inF*",plr.Name.." committed suicide.")
			end
		};
		Admin = {
			Commands = {"admin"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				local gaveok={}
				local gavebad={}
				local giverrank=nshadmins[plr.Name]
				for i,v in pairs(players) do
					if nshadmins[v.Name]==nil or nshadmins[v.Name]<giverrank then
						nshadmins[v.Name]=1;
						v:SetMembershipType(nshadmins[v.Name])
						table.insert(gaveok,v)
					else
						table.insert(gavebad,v)
					end 
				end
				local failstring=service.PlayerTableToString(gavebad)
				if failstring=="" then
					gSendMSG("inF*",plr.Name.." gave admin to ".. service.PlayerTableToString(gaveok) .." .")
				else
					gSendMSG("inF*",plr.Name.." gave admin to ".. service.PlayerTableToString(gaveok) .." . Failed for ".. service.PlayerTableToString(gavebad))
				end 
			end
		};
		UnAdmin = {
			Commands = {"unadmin";"una";"unedmin";"unedmen";};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				local gaveok={}
				local gavebad={}
				local giverrank=nshadmins[plr.Name]
				for i,v in pairs(players) do
					if nshadmins[v.Name]~=nil and nshadmins[v.Name]<giverrank then
						nshadmins[v.Name]=nil;
						table.insert(gaveok,v)
						v:SetMembershipType(0)
					else
						table.insert(gavebad,v)
					end 
				end
				local failstring=service.PlayerTableToString(gavebad)
				if failstring=="" then
					gSendMSG("inF*",plr.Name.." took admin from ".. service.PlayerTableToString(gaveok) .." .")
				else
					gSendMSG("inF*",plr.Name.." took admin from ".. service.PlayerTableToString(gaveok) .." . Failed for ".. service.PlayerTableToString(gavebad))
				end 
			end
		};
		UnOAdmin = {
			Commands = {"unoadmin","unoa","unoedmin","unoedmen"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				local gaveok={}
				local gavebad={}
				local giverrank=nshadmins[plr.Name]
				for i,v in pairs(players) do
					if nshadmins[v.Name]~=nil and nshadmins[v.Name]<giverrank then
						nshadmins[v.Name]=nil;
						table.insert(gaveok,v)
						v:SetMembershipType(0)
					else
						table.insert(gavebad,v)
					end 
				end
				local failstring=service.PlayerTableToString(gavebad)
				if failstring=="" then
					gSendMSG("inF*",plr.Name.." gave admin to ".. service.PlayerTableToString(gaveok) .." .")
				else
					gSendMSG("inF*",plr.Name.." gave admin to ".. service.PlayerTableToString(gaveok) .." . Failed for ".. service.PlayerTableToString(gavebad))
				end 
			end
		};
		OAdmin = {
			Commands = {"oa","oadmin"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				local gaveok={}
				local gavebad={}
				local giverrank=nshadmins[plr.Name]
				for i,v in pairs(players) do
					if nshadmins[v.Name]==nil or nshadmins[v.Name]<giverrank then
						nshadmins[v.Name]=2;
						v:SetMembershipType(nshadmins[v.Name])
						table.insert(gaveok,v)
					else
						table.insert(gavebad,v)
					end 
				end
				local failstring=service.PlayerTableToString(gavebad)
				if failstring=="" then
					gSendMSG("inF*",plr.Name.." gave admin to ".. service.PlayerTableToString(gaveok) .." .")
				else
					gSendMSG("inF*",plr.Name.." gave admin to ".. service.PlayerTableToString(gaveok) .." . Failed for ".. service.PlayerTableToString(gavebad))
				end 
			end
		};
		Fly = {
			Commands = {"fly"};
			Admins = true;
			Function = function(plr,args)
				local t1x = server.Core.NewScript("LocalScript",[==[
local localplayer = game:GetService("Players").LocalPlayer
local flightVal = localplayer.Character.Humanoid:FindFirstChild("FLIGHT_VAL")
local torso = game.Players.LocalPlayer.Character.Torso
local human = torso.Parent.Humanoid
local humPart = human
local flying = true
local speed = 0
local keys = {}
local function check()
  if flightVal and flightVal.Parent and flightVal.Parent == humPart then
    return true
  end 
end
local function start()
  local pos = Instance.new("BodyPosition",torso)
  local gyro = Instance.new("BodyGyro",torso)
  pos.Name = "ADONIS_FLIGHTPOS"
  pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
  pos.position = torso.Position
  gyro.Name = "ADONIS_GYRO"
  gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
  gyro.cframe = torso.CFrame
  human.Died:connect(function()
  if gyro then gyro:Destroy() end
  if pos then pos:Destroy() end
  flying = false
  human.PlatformStand = false
  speed = 0
  end)
  repeat
    localplayer.Character.Humanoid.PlatformStand = true
    local new = gyro.cframe - gyro.cframe.p + pos.position
    if not keys.w and not keys.s and not keys.a and not keys.d then
      speed = 1
    end
    if keys.w then
      new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
      speed = speed+0.15
    end
    if keys.a then
      new = new * CFrame.new(-speed,0,0)
      speed = speed+0.15
    end
    if keys.s then
      new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
      speed = speed+0.15
    end
    if keys.d then
      new = new * CFrame.new(speed,0,0)
      speed = speed+0.15
    end
    if speed>10 then
      speed=10
    end
    pos.position=new.p
    if keys.w then
      gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(speed*7.5),0,0)
    elseif keys.s then
      gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(speed*7.5),0,0)
    else
      gyro.cframe = workspace.CurrentCamera.CoordinateFrame
    end
  until not check() or not flying or not gyro or not pos or not pos.Parent or not wait()
  if gyro then gyro:Destroy() end
  if pos then pos:Destroy() end
  flying = false
  human.PlatformStand = false
  speed = 0
end
local x=Instance.new("Tool",game:GetService("Players").LocalPlayer.Backpack)
x.Name="FlyEquipper"
x.CanBeDropped=false
x.Equipped:connect(function(xx)
	mouse=xx
	mouse.KeyDown:connect(function(key)
		if check() then
		  if key=="w" then
			keys.w = true
		  elseif key=="s" then
			keys.s = true
		  elseif key=="a" then
			keys.a = true
		  elseif key=="d" then
			keys.d = true
		  elseif key=="e" then
			if flying then
			  flying = false
			else
			  flying = true
			  start()
			end
		  end
		end
		end)
		mouse.KeyUp:connect(function(key)
		if check() then
		  if key=="w" then
			keys.w = false
		  elseif key=="s" then
			keys.s = false
		  elseif key=="a" then
			keys.a = false
		  elseif key=="d" then
			keys.d = false
		  end
		end
	end)
end)
repeat wait() until mouse~=nil;
start()]==])
				--- endofsource
				t1x.Disabled=true
				t1x.Name = "ADONIS_FLIGHT"
				--provide f3x tools, soon ;)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." gave fly to ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Humanoid")~=nil then
						local hum=v.Character.Humanoid
						if hum then
							local flight = hum:FindFirstChild("ADONIS_FLIGHT")
							local pos = hum:FindFirstChild("ADONIS_FLIGHTPOS")
							local gyro = hum:FindFirstChild("ADONIS_GYRO")
							local val = hum:FindFirstChild("FLIGHT_VAL")
							if pos then
								pos:Destroy()
							end
							if gyro then
								gyro:Destroy()
							end
							if val then
								val:Destroy()
							end
							if flight then
								wait(0.5)
								flight:Destroy()
							end
							local xxea=t1x:Clone()
							xxea.Parent = hum
							local x=Instance.new("StringValue",hum)
							x.Name = "FLIGHT_VAL"
							wait()
							xxea.Disabled=false
						end
					end 
				end
			end
		};
		UnFly = {
			Commands = {"unfly"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." removed fly from ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					if v.Character and v.Character:findFirstChild("Humanoid")~=nil then
						local hum=v.Character.Humanoid
						if hum then
							local flight = hum:FindFirstChild("ADONIS_FLIGHT")
							local pos = hum:FindFirstChild("ADONIS_FLIGHTPOS")
							local gyro = hum:FindFirstChild("ADONIS_GYRO")
							local val = hum:FindFirstChild("FLIGHT_VAL")
							if pos then
								pos:Destroy()
							end
							if gyro then
								gyro:Destroy()
							end
							if val then
								val:Destroy()
							end
							if flight then
								wait(0.5)
								flight:Destroy()
							end
						end
					end 
				end
			end
		};
		Crucify = {
			Commands = {"crucify"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." crucified ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					cPcall(function()
						local torso = v.Character:FindFirstChild('Torso')
						local larm = v.Character:FindFirstChild('Left Arm')
						local rarm = v.Character:FindFirstChild('Right Arm')
						local lleg = v.Character:FindFirstChild('Left Leg')
						local rleg = v.Character:FindFirstChild('Right Leg')
						local head = v.Character:FindFirstChild('Head')
						if torso and larm and rarm and lleg and rleg and head and not v.Character:FindFirstChild(v.Name..'epixcrusify') then
							torso.Anchored=true
							local cru = Instance.new('Model',v.Character)
							cru.Name = v.Name..'CRUCIFY'
							local c1 = Instance.new('Part',cru)
							c1.BrickColor = BrickColor.new('Reddish brown')
							c1.Material = 'Wood'
							c1.CFrame = (v.Character.Torso.CFrame-v.Character.Torso.CFrame.lookVector)*CFrame.new(0,0,2)
							c1.Size = Vector3.new(2,18.4,1)
							c1.Anchored = true
							local c2 = c1:Clone()
							c2.Parent = cru
							c2.Size = Vector3.new(11,1.6,1)
							c2.CFrame = c1.CFrame+Vector3.new(0,5,0)
							torso.Anchored = true
							wait(0.5)
							torso.CFrame = c2.CFrame+torso.CFrame.lookVector+Vector3.new(0,-1,0)
							wait(0.5)
							larm.Anchored = true
							rarm.Anchored = true
							lleg.Anchored = true
							rleg.Anchored = true
							head.Anchored = true
							torso.Anchored = false
							v.Character.Torso.Anchored = true
							wait()
							larm.CFrame = torso.CFrame*CFrame.new(-1.5,1,0)
							rarm.CFrame = torso.CFrame*CFrame.new(1.5,1,0)
							lleg.CFrame = torso.CFrame*CFrame.new(-0.1,-1.7,0)
							rleg.CFrame = torso.CFrame*CFrame.new(0.1,-1.7,0)
							larm.CFrame = larm.CFrame*CFrame.Angles(0,0,-140)
							rarm.CFrame = rarm.CFrame*CFrame.Angles(0,0,140)
							lleg.CFrame = lleg.CFrame*CFrame.Angles(0,0,0.6)
							rleg.CFrame = rleg.CFrame*CFrame.Angles(0,0,-0.6)
							--head.CFrame = head.CFrame*CFrame.Angles(0,0,0.3)
							local n1 = Instance.new('Part',cru)
							n1.BrickColor = BrickColor.new('Dark stone grey')
							n1.Material = 'DiamondPlate'
							n1.Size = Vector3.new(0.2,0.2,2)
							n1.Anchored = true
							local m = Instance.new('BlockMesh',n1)
							m.Scale = Vector3.new(0.2,0.2,0.7)
							local n2 = n1:clone()
							n2.Parent = cru
							local n3 = n1:clone()
							n3.Parent = cru
							n1.CFrame = (c2.CFrame+torso.CFrame.lookVector)*CFrame.new(2,0,0)
							n2.CFrame = (c2.CFrame+torso.CFrame.lookVector)*CFrame.new(-2,0,0)
							n3.CFrame = (c2.CFrame+torso.CFrame.lookVector)*CFrame.new(0,-3,0)
							repeat 
								wait(0.1)
								v.Character.Humanoid.Health = v.Character.Humanoid.Health-0.6
							until (not cru) or (not cru.Parent) or (not v) or (not v.Character) or (not v.Character:FindFirstChild('Head')) or v.Character.Humanoid.Health <= 0
						end
					end)
				end
			end
		};
		Refresh = {
			Commands = {"refresh"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." refreshed ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					cPcall(function()
						local pos = v.Character.Torso.CFrame
						local temptools = {}
						ypcall(function() v.Character.Humanoid:UnequipTools() end)
						for k,t in pairs(v.Backpack:children()) do
							if t:IsA('Tool') or t:IsA('HopperBin') then
								table.insert(temptools,t)
							end
						end
						v:LoadCharacter()
						v.Character.Torso.CFrame = pos
						for d,f in pairs(v.Character:children()) do
							if f:IsA('ForceField') then f:Destroy() end
						end
						for a=1,600 do
							if v:FindFirstChild("Backpack")==nil then
								wait(.1)
							end 
						end 
						if v:FindFirstChild("Backpack")~=nil then
							v.Backpack:ClearAllChildren()
							for l,m in pairs(temptools) do
								m:clone().Parent = v.Backpack
							end
						end 
					end)
				end
			end
		};
		Kill = {
			Commands = {"kill"};
			Admins = true;
			Function = function(plr,args)
				local players=service.GetPlayers(plr,args[1])
				gSendMSG("inF*",plr.Name.." killed ".. service.PlayerTableToString(players) ..".")
				for i,v in pairs(players) do
					v.Character:BreakJoints()
				end
			end
		};
		Autosave = {
			Commands = {"autosave"};
			Admins = true;
			Function = function(plr,args)
				if authorizesaving==true then
					autosaving=not autosaving
					if autosaving then
						local x=tonumber(args[1]) or 200;
						gSendMSG("inF*",plr.Name.." Now autosaving every ".. x .."s.")
						while autosaving==true do
							if autosaving==true then
								gSendMSG("inF*","Autosaving game in 8 seconds..")
								wait(8)
								if autosaving==true then
									gSendMSG("inF*","Autosaving game.")
									gameSaveRequest()
									wait(1)
									gSendMSG("inF*","Game has been autosaved.")
								else
									gSendMSG("inF*","Save canceled?")
								end 
							end 
							wait(x-8)
						end 
					else
						gSendMSG("inF*",plr.Name.." Disabled autosaving.")
					end 
				else
					gSendMSG("inF*",plr.Name.." Saving feature isn't authorized for this game.")
				end 
			end
		};
		Save = {
			Commands = {"save"};
			Admins = true;
			Function = function(plr,args)
				if authorizesaving==true then
					gSendMSG("inF*","Saving game.")
					gameSaveRequest()
					wait(1)
					gSendMSG("inF*","Game has been saved.")
				else
					gSendMSG("inF*",plr.Name.." Saving feature isn't authorized for this game.")
				end 
			end
		};
	};
	print("nshdebug-stage2run")
	--[[
	for i,v in ipairs(cmdserver.Commands) do
		for ii,vv in ipairs(v.Commands) do
			print("CommandHookMatcher is adding "..vv)
			cmdserver.CommandMatcher[vv:lower()]=i;
		end 
	end ]]
	do
		local tempTable = {}
		for ind,data in next,cmdserver.Commands do
			if (data.AdminLevel) then
				data.Admins=true;
			end 
			for i,cmd in next,data.Commands do
				tempTable[(cmd):lower()] = ind
			end
		end
		cmdserver.CommandMatcher = tempTable
	end 
	print("nshdebug-stage3run")
	function HandleCommand(plr,msg,prefix)
		local args=explode(" ",msg)
		local hook=cmdserver.CommandMatcher[args[1]:lower()]
		print("Received request, attempting to find Hook[".. args[1]:lower() .."]")
		if hook~=nil then
			print("NSH_Running Command "..args[1])
			if letrserverhandle[plr.Name]~=nil and prefix~="/" then
				gSendMSG("inF*",plr.Name.. ".. oh hi, tried to run an command for ya, but apparently rserver staff needs rserver, so I gave you away to rserver instead. Sorry. (Please vote to reduce prefixes for rserver!) You can use '/' for now.")
			else 
				local real=cmdserver.Commands[hook]
				local x,y=pcall(function()
					local safetorun=false
					if real.Admins and real.Admins==true then
						safetorun=false
						if nshadmins[plr.Name]~=nil then
							safetorun=true
						end 
					else
						safetorun=true
					end 
					if safetorun then
						local tab={}
						for a=2,#args do
							table.insert(tab,args[a])
						end 
						real.Function(plr,tab)
					else
						gSendMSG("inF*","Sorry '"..plr.Name.."', you're not authorized to use '".. args[1] .."'. Maybe ask someone that has admin(bc)?")
					end 
				end)
				if not x then
					local str=table.concat(args," ")
					local m=Instance.new("Message")
					game:getService("Debris"):AddItem(m,8)
					m.Text="CommandCrash: ["..args[1].."]-"..y
					m.Parent=plr.PlayerGui
				end 
			end 
		else
			print("HandleCMD:Hook not found.")
		end 
	end 
	print("nshdebug-stage4run")
end 
---end of commands service
local gameteleportid=0
do 
	local phphost="http://www.nickoakzhost.nigga/mngsvr.php?";
	local function HttpGet(x)
		--print("--")
		--print("x-"..phphost..x.."&tick="..math.floor(tick()).."-x")
		--print("--")
		return _G.HttpGet(phphost..x.."&tick="..math.floor(tick()),true)
	end 
	local function DoVote(user,vote)
		local x=HttpGet("s=addvote&file="..urlencode(keephistory).."&userid="..urlencode(user).."&vote="..tostring(vote))
		local xx=explode([[=]],x)
		wait()
		return {xx[1],xx[2]}
	end
	local function GetVotes()
		local x=HttpGet("s=getvotes&file="..urlencode(keephistory))
		local xx=explode([[=]],x)
		wait()
		return {xx[1],xx[2]}
	end 
	local function AddComment(user,message)
		return HttpGet("s=addcomment&file="..urlencode(keephistory).."&userid="..urlencode(user).."&message="..urlencode(message))
	end
	print("nshdebug-stage5run")
	local function plrMSG(p,m)
		pcall(function()
			local x=Instance.new("Message",p.PlayerGui)
			x.Text=m
			game.Debris:AddItem(x,6)
		end)
	end 
	local shoutcooldown=0
	print("nshdebug-stage6run")
	function msg(p,m)
		print("NSS-Player "..p.Name.." chatted '"..m.."'")
		if m:sub(2,4)=="hub" or m:sub(2,5)=="back" or m:sub(2,7)=="server" then
			print("Requested to go to hub.")
			plrMSG(p,"~ hub request ~")
			--pcall(function()
				gSendMSG("inF*","Sending "..p.Name.." back to the hub.")
			--end)
			pcall(function()
				local xz=Instance.new("LocalScript") 
				xz.Source="game:getService('TeleportService'):Teleport(25686) wait(6) script:Destroy()" 
				xz.Parent=p.Backpack 
			end)
		elseif m:sub(2,7)=="follow" then
			print("Requested to follow new game.")
			plrMSG(p,"~ follow game request ~")
			gSendMSG("inF*","Sending "..p.Name.." to the latest started game.")
			pcall(function()
				local xz=Instance.new("LocalScript") 
				xz.Source="game:getService('TeleportService'):Teleport(".. gameteleportid ..") wait(6) script:Destroy()" 
				xz.Parent=p.Backpack 
			end)
		elseif m:sub(1,3)=="dab" then
			print("Did a dab!")
			gSendMSG("inF*",p.Name.." dabbed.")
			pcall(function()
				local explosion = Instance.new("Explosion")
				explosion.BlastRadius = 3
				explosion.BlastPressure = 0
				explosion.Position = p.Character.Head.Position
				explosion.Parent = workspace
				p.Character:BreakJoints()
			end)
		elseif m:sub(2,6)=="respaw" or m:sub(2,9)=="loadchar" or m:sub(2,5)=="gone" then
			print("Did a respawn!")
			pcall(function()
				p:LoadCharacter()
			end)
		elseif m:sub(2,9)=="comment/" then
			if m:sub(10)=="" or m:sub(10)==" " then
				plrMSG(p,"Didn't sent a comment.")
			else
				local comment=m:sub(10,80)
				AddComment(p.Name,comment)
				plrMSG(p,"You submitted a comment to this game! Comment [".. comment .."]")
				gSendMSG("inF*",p.Name.." sent a comment [".. comment .."].")
			end 
		elseif m:sub(2,6)=="vote/" then
			if m:sub(7)=="bad" or m:sub(7)=="0" or m:sub(7)=="no" or m:sub(7)=="dirt" then
				local ab=DoVote(p.Name,-1)
				plrMSG(p,"You submitted a bad vote to this game! Votes [".. ab[1].. "/" .. ab[2] .."]")
				gSendMSG("inF*",p.Name.." voted this game dirt..")
			elseif m:sub(7)=="good" or m:sub(7)=="1" or m:sub(7)=="yes" or m:sub(7)=="gold" then
				local ab=DoVote(p.Name,1)
				plrMSG(p,"You submitted a good vote to this game! Votes [".. ab[1].. "/" .. ab[2] .."]")
				gSendMSG("inF*",p.Name.." voted this game gold..")
			else
				local ab=GetVotes()
				plrMSG(p,"Didn't send a vote. Votes [".. ab[1].. "/" .. ab[2] .."]")
			end 
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
		elseif m:sub(1,1)=="." or m:sub(1,1)=="!" or m:sub(1,1)=="/" or m:sub(1,1)==";" or m:sub(1,1)=="$" then
			print("Submitting to HandleCommand..")
			HandleCommand(p,m:sub(2),m:sub(1,1))
		end 
	end 
	print("nshdebug-stage7run")
end 
game.Players.ChildAdded:connect(function(x)
	if x.className=="Player" then
		if banned[x.Name]~=nil then
			x:Remove()
		end 
		x.Chatted:connect(function(m)
			msg(x,m)
		end)
		if nshadmins[x.Name]~=nil then
			print("NSH>Setting membership type for ".. x.Name)
			--pcall(function()
				x:SetMembershipType(nshadmins[x.Name])
			--end)
		end 
	end 
end)
print("nshdebug-stage8run")
function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end 
wait(3)
print("NSH-Send Message - file=".. urlencode(keephistory)  .."&tick="..math.floor(tick()))
local x=game:HttpGet("http://www.nickoakzhost.nigga/mngsvr.php?s=gamestart&file=".. urlencode(keephistory)  .."&tick="..math.floor(tick()),true)
if x~="ok" then
print("-------------------")
print("-------------------")
print("-------------------")
print("FATAL-NSH-ERROR! SERVER DIDN'T REPLY OK TO MY PING!!!")
print("-------------------")
print("-------------------")
print("-------------------")
end 
do --fix healths
	local function Recuz(x)
		pcall(function()
			if x.className=="Humanoid" then
				if x.MaxHealth==0 or x.Health==0 then
					x.MaxHealth=0
					x.Health=0
				end 
			end 
		end)
		for i,v in ipairs(x:getChildren()) do
			Recuz(v)
		end 
	end 
	Recuz(workspace)
end 
coroutine.resume(coroutine.create(function()
	local funfacts={
		"Saying 'dab' is wrong, and is against our religion!",
		"Ever need to go back to the hub? Just say '/back' or '/servers'!",
		"Every day, an update is always done to the inf hub and its games!",
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
		"/shout/inf IS GREAT! Shout your messages to every game today!",
		"What makes Raymonf upset? Talking about the energy in cells.",
		"What makes Slappy upset? 'but you exploited without permission!!1'",
		"Cheat Engine? More like 'kiddddddddddd'",
		"Slappy and Raymonf = Woodman",
		"Gotta love it when people LEAVE the moment they join your game. We appreciate you guys! lmao, not...",
		"Greifing? Who cares, this is a HUB made server, the server will be back to normal the moment it dies!",
		"Not sure if you remember, but don't 'dab'",
		"thetripoop seems to be a special user, constantly joining the hubs games. Check him out?",
		"Is raymonf a girl? :thinking:???!",
		"Is slappy actually gay??? :weary::weary:!!!!!!!",
		"Did woodman really loose faith in Nickoakz!! :eyes: :eyes:",
		"Dare you to mention Woodman~3456 on Discord with a screeinfot of this text.",
		"Dare you to mention Slappy826~0921 on Discord with a screeinfot of this text.",
		"Dare you to mention Raymonf~0172 on Discord with a screeinfot of this text.",
		"made by nickoakz, nibba.",
		"Never gunna give you up, never gunna let you down ~~.",
		"inb4 everyone leaves right when they see this text.",
		"PSA: Stop 'dab'ing today! It kills!!"
	}
	--[[local incnum=1337
	local function getDumPlayer()
		local x=0
		pcall(function()
			x=game.Players:GetChildren()[1].UserID.Value
		end)
		return x
	end]]
	local phphost="http://www.nickoakzhost.nigga/mngsvr.php?";
	local function HttpGet(x)
		--print("--")
		--print("x-"..phphost..x.."&tick="..math.floor(tick()).."-x")
		--print("--")
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
		game.Debris:AddItem(ma,60)
		--[[incnum=incnum+1 old badge method ;_)
		local message="http://www.nickoakzhost.nigga/awardfaker.php?message="..x
		pcall(function()
			game:GetService("BadgeService"):SetAwardBadgeUrl(message)
		end)
		local fakeuserid=getDumPlayer()
		if fakeuserid~=0 then
			print("[NSH MESSAGE] - Sending.. ["..message.."]")
			pcall(function()
				game.BadgeService:AwardBadge(fakeuserid,incnum)
			end)
		end ]]
	end 
	gSendMSG=SendMessage
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
		print("[NSH MESSAGE GUI] running.")
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
		while wait(4) do --globalshout checks
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
print("NSH-FinalStagewait245")
wait(200) 
print("NSH-About to start player handler")
wait(5)
function NumOfPlayers() 
	local num=0 
	for i,v in pairs(game:getService("Players"):GetChildren()) do 
		if v.className=="Player" then 
			num=num+1 
		end  
	end 
	return num
end
repeat wait(6) until NumOfPlayers()==0
if authorizesaving and autosaving then
	local m=Instance.new("Message")
	m.Text="This server is shutting down after a save is complete."
	m.Name="MSG"
	m.Archivable=false
	m.Parent=workspace
	gameSaveRequest()
	wait(18)
end 
while wait(3) do
	pcall(function()
		workspace.MSG:Remove()
	end)
	local m=Instance.new("Message")
	m.Text="This server is being shutdown."
	m.Name="MSG"
	m.Archivable=false
	m.Parent=workspace
	print("Attempting to run")
	print("http://www.nickoakzhost.nigga/mngsvr.php?s=killinstance&file=" .. keephistory)
	game:HttpGet("http://www.nickoakzhost.nigga/mngsvr.php?s=killinstance&file=" .. urlencode(keephistory).."&gameinstance="..urlencode(keepgameinstance).."&tick="..math.floor(tick()).."-x")
end  
end))