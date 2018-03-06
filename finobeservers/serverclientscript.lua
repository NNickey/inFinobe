--[[clientscript]]
--local approvedwhitelist={"Nickoak","EggsBenedict","Raymonf","Woodman","NimmyJewtron","Paris","P4risAndStuff","d4ve","Mussolini","Figgy","Gooby","Myra","pixelpower","KurtCobain"}
local exes={}
local banlist={"x"}
for a=1,#banlist do
	exes[banlist[a]]=true
end
if exes[script.Parent.Parent.Parent.Name]~=nil then
	error('not approved')
end 


local serverrequesthub=game.Lighting.serverRequestCache

local games={};
local showinggames={};

local storage=game.Lighting;
local prints=print;
function print(...)
	--local x=table.concat(...,"-")
	local xs=Instance.new("StringValue",storage.clientLogs)
	xs.Value=tostring(...)
	prints("plr:"..script.Parent.Parent.Parent.Name.."||",...)
end 

local shownsfw=false;
local showuser=2;
--0 show both
--1 show inF
--2 show userup
local sorttype=1;
--0 search query
--1 vote
--2 name
local sortedlist=false;
local searchqueue="";


-----
----fuzzy search//dropped
-----

--[===[
do
local mmin, unpack = math.min, unpack

-- returns indexes of character within string (str)
local function find_chars(str, first_char)
  local i = 0
  local res = {}
  while i do
    i = str:find(first_char, i + 1, true)
    res[#res + 1] = i
  end
  return res
end

-- returns last index of pattern within string (str) starting after first index (index)
local function find_end(str, index, query)
  local last = index
  for i=2, #query do
    last = str:find(query:sub(i,i), index + 1, true) --or last
    if not last then return nil end
  end
  return last
end

-- returns length of match within str
local function compute_match_len(str, query)
  local first_char = query:sub(1,1)
  local first_indexes = find_chars(str, first_char)
  local res = {}
  -- find last indexes
  for i, index in ipairs(first_indexes) do
    local last_index = find_end(str, index, query)
    if last_index then
      res[#res + 1] = last_index - index 
    end
  end

  if #res == 0 then return nil end
  return mmin(unpack(res)) --crash if #matches is over MAXSTACK (defined at compile time)
end

-- usage: local fuzzy = require 'fuzzy'; 
--        fuzzy("map.tmx", "tm") --> 0.28571428571429
-- returns score (normalized 0..1?) of string
function fuzzyscore(str, query)
  if #query == 0 then return 1 end
  if #str == 0 then return 0 end

  str = str:lower()
  local match_len = compute_match_len(str, query)
  if not match_len or match_len == 0 then return 0 end

  local score = #query / match_len
  return score / #str
end
end ]===]
--dropped fuzzy search.


--new fuzzy search--
local fuzzyscore=nil
local stringmatchmodule=nil
local fuzzymodule=nil
do
		--[[
		The matcher module provides easy and advanced matching of strings.

		@author Nils Nordman <nino at nordman.org>
		@copyright 2011-2012
		@license MIT (see LICENSE)
		@module _M.textui.util.matcher
		]]

		local _G, string, table, math = _G, string, table, math
		local ipairs, type, setmetatable, tostring, append =
			  ipairs, type, setmetatable, tostring, table.insert

		local matcher = {}
		local _ENV = matcher
		--if setfenv then setfenv(1, _ENV) end
		--nah fuck that.

		--[[ Constructs a new matcher.
		@param candidates The candidates to consider for matching. A table of either
		string, or tables containing strings.
		@param search_case_insensitive Whether searches are case insensitive or not.
		Defaults to `true`.
		@param search_fuzzy Whether fuzzy searching should be used in addition to
		explicit matching. Defaults to `true`.
		]]
		--apparently didn't match matcher? idk what the ruck
		function matcher.new(candidates, search_case_insensitive, search_fuzzy)
		  local m = {
			search_case_insensitive = search_case_insensitive,
			search_fuzzy = search_fuzzy
		  }
		  setmetatable(m, { __index = matcher })
		  m:_set_candidates(candidates)
		  return m
		end

		-- Applies search matchers on a line.
		-- @param line The line to match
		-- @param matchers The search matchers to apply
		-- @return A numeric score if the line matches or nil otherwise. For scoring,
		-- lower is better.
		local function match_score(line, matchers)
		  local score = 0

		  for _, matcher in ipairs(matchers) do
			local matcher_score = matcher(line)
			if not matcher_score then return nil end
			score = score + matcher_score
		  end
		  return score
		end

		--[[ Explains the match for a given search.
		@param search The search string to match
		@param text The text to match against
		@return A list of explanation tables. Each explanation table contains the
		following fields:
		  `score`: The score for the match
		  `start_pos`: The start position of the best match
		  `end_pos`: The end position of the best match
		  `1..n`: Tables of matching positions with the field start_pos and length
		]]
		function matcher:explain(search, text)
		  if not search or #search == 0 then return {} end
		  if self.search_case_insensitive then
			search = search:lower()
			text = text:lower()
		  end
		  local matchers = self:_matchers_for_search(search)
		  local explanations = {}

		  for _, matcher in ipairs(matchers) do
			local score, start_pos, end_pos, search = matcher(text)
			if not score then return {} end
			local explanation = { score = score, start_pos = start_pos, end_pos = end_pos }
			local s_start, s_index = 1, 1
			local l_start, l_index = start_pos, start_pos
			while s_index <= #search do
			  repeat
				s_index = s_index + 1
				l_index = l_index + 1
			  until search:sub(s_index, s_index) ~= text:sub(l_index, l_index) or s_index > #search
			  append(explanation, { start_pos = l_start, length = l_index - l_start })
			  if s_index > #search then break end
			  repeat
				l_index = l_index + 1
			  until search:sub(s_index, s_index) == text:sub(l_index, l_index) or l_index > end_pos
			  l_start = l_index
			end
			append(explanations, explanation)
		  end

		  return explanations
		end

		-- Matches search against the candidates.
		-- @param search The search string to match
		-- @return A table of matching candidates, ordered by relevance.
		function matcher:match(search)
		  if not search or #search == 0 then return self.candidates end
		  local cache = self.cache
		  if self.search_case_insensitive then search = search:lower() end
		  local matches = cache.matches[search] or {}
		  if #matches > 0 then return matches end
		  local lines = cache.lines[string.sub(search, 1, -2)] or self.lines
		  local matchers = self:_matchers_for_search(search)

		  local matching_lines = {}
		  for i, line in ipairs(lines) do
			local score = match_score(line.text, matchers)
			if score then
			  matches[#matches + 1] = { index = line.index, score = score }
			  matching_lines[#matching_lines + 1] = line
			end
		  end
		  cache.lines[search] = matching_lines

		  table.sort(matches, function(a ,b) return a.score < b.score end)
		  local matching_candidates = {}
		  for _, match in ipairs(matches) do
			matching_candidates[#matching_candidates + 1] = self.candidates[match.index]
		  end
		  self.cache.matches[search] = matching_candidates
		  return matching_candidates
		end

		function matcher:_set_candidates(candidates)
		  self.candidates = candidates
		  self.cache = {
			lines = {},
			matches = {}
		  }
		  local lines = {}
		  local fuzzy_score_penalty = 0

		  for i, candidate in ipairs(candidates) do
			if type(candidate) ~= 'table' then candidate = { candidate } end
			local text = table.concat(candidate, ' ')
			if self.search_case_insensitive then text = text:lower() end
			lines[#lines + 1] = {
			  text = text,
			  index = i
			}
			fuzzy_score_penalty = math.max(fuzzy_score_penalty, #text)
		  end
		  self.lines = lines
		  self.fuzzy_score_penalty = fuzzy_score_penalty
		end

		local pattern_escapes = {}
		for c in string.gmatch('^$()%.[]*+-?', '.') do pattern_escapes[c] = '%' .. c end

		local function fuzzy_search_pattern(search)
		  local pattern = ''
		  for i = 1, #search do
			local c = search:sub(i, i)
			c = pattern_escapes[c] or c
			pattern = pattern .. c .. '.-'
		  end
		  return pattern
		end

		--- Creates matches for the specified search
		-- @param search_string The search string
		-- @return A table of matcher functions, each taking a line as parameter and
		-- returning a score (or nil for no match).
		function matcher:_matchers_for_search(search_string)
		  local fuzzy = self.search_fuzzy
		  local fuzzy_penalty = self.fuzzy_score_penalty
		  local groups = {}
		  for part in search_string:gmatch('%S+') do groups[#groups + 1] = part end
		  local matchers = {}

		  for _, search in ipairs(groups) do
			local fuzzy_pattern = fuzzy and fuzzy_search_pattern(search)
			matchers[#matchers + 1] = function(line)
			  local start_pos, end_pos = line:find(search, 1, true)
			  local score = start_pos
			  if not start_pos and fuzzy then
				start_pos, end_pos = line:find(fuzzy_pattern)
				if start_pos then
				  score = (end_pos - start_pos) + fuzzy_penalty
				end
			  end
			  if score then
				return score + #line, start_pos, end_pos, search
			  end
			end
		  end
		  return matchers
		end

		--return matcher
	fuzzymodule=matcher
end 
--------------------
--end of new fuzzy search module
-----

wait()


repeat wait() until #storage.gameData:GetChildren()>1
wait()
for i,v in ipairs(storage.gameData:getChildren()) do
	local kakk=35
	local kakz=false
	if v:findFirstChild("MaxPlayers")~=nil then
		kakk=v.MaxPlayers.Value
	end 
	if v:findFirstChild("NSFW")~=nil then
		kakz=v.NSFW.Value
	end 
	local game={v.Name,kakk,v.Value,kakz}
	local gamepos=tonumber(v.Value)
	if gamepos==nil then gamepos=#games end 
	table.insert(games,gamepos,game)
end 

--implement script usable function for search querys
do
	--generate options
	local Options = {}
	for _, Class in pairs(games) do
		table.insert(Options, Class[1])
	end
	stringmatchmodule = fuzzymodule.new(Options, true, true)
	--[[local returnfirstgame(macc)
		for i,v in ipairs(games) do
			if v[1]==macc then
				return i
			end 
		end 
	end  ]]
	function fuzzyscore(str)
		local RankMap={}
		local Matches = stringmatchmodule:match(str)
		for Index, Match in pairs(Matches) do
			--print("Match attempt.")
			--print("Results")
			--print("Match>",Match)
			--print("Index>",Index)
			RankMap[Match] = #Matches - Index
		end 
		local Options = {}
		for _, Class in pairs(games) do
			if RankMap[Class[1]] then
				--print("Added option!")
				table.insert(Options, Class)
			end
		end
		table.sort(Options, function(A, B)
			if RankMap[A] == RankMap[B] then
				return A[1] < B[1]
			end
			return RankMap[A] > RankMap[B]
		end)
		print("Returned #"..#Options.." results for request '".. str .."'.")
		return Options
	end 
	
	--[=[
		local Matches = self.StringMatcher:match(Settings.Filter)
		for Index, Match in pairs(Matches) do
			RankMap[Classes[Match]] = #Matches - Index
		end --to index a rankmap?
	
	]=]
	--[[
		local Options = {}
		for _, Class in pairs(Classes) do
			if RankMap[Class] and DoInclude(Class) then
				table.insert(Options, Class)
			end
		end
		table.sort(Options, function(A, B)
			if RankMap[A] == RankMap[B] then
				return A.ClassName < B.ClassName
			end
			return RankMap[A] > RankMap[B]
		end)
		return Options --list of things to display as is
	]]
end 
--StringMatcher.new(Options, true, true)?

--[[table.sort(games, function(a, b)
	return a[3] < b[3]
end)]]

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function processReturnGameList()
	local returnlist;
	sortedlist=false
	--0 show both
	--1 show inF
	--2 show userup
	returnlist=deepcopy(games)
	local remqueue={}
	for i,v in ipairs(returnlist) do
		if storage.gameData[v[1]]:findFirstChild("usergame")==nil then
			print("v[1] bad! ".. v[1])
		end 
		if storage.gameData[v[1]]['usergame'].Value==true and showuser==1 then
			table.insert(remqueue,i)
		elseif storage.gameData[v[1]]['usergame'].Value==false and showuser==2 then
			table.insert(remqueue,i)
		end 
	end 
	table.sort(remqueue, function(a, b)
		return a > b
	end)
	for i,v in ipairs(remqueue) do
		table.remove(returnlist,v)
	end 
	return returnlist
end 

function wfc(x,c)
	local tix=0
	while wait() and x:findFirstChild(c)==nil do
		tix=tix+1
		if tix>150 and tix<500 then
			print("tix- waiting for "..c.." for a while now..")
			tix=505
		end
	end
end 

function explode(div,str)
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

function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end 

local gui=script.Parent

local serverbox=gui.list.box.list.server:Clone()
gui.list.box.list:ClearAllChildren()
wfc(gui.game,"coms")
wfc(gui.game.coms,"comss")
wfc(gui.game.coms.comss,"comsss")
wfc(gui.game.coms.comss.comsss,"comnt")
local commentbox=gui.game.coms.comss.comsss.comnt:Clone()
function clrcmts()
for i,v in ipairs(gui.game.coms.comss.comsss:getChildren()) do
v:Remove()
end
end 
clrcmts()
local pagenum=1

local pages=0

showinggames=processReturnGameList()
pages=(math.floor(#showinggames/18)) +1

local gameselection=1
local gameselectiondata={}

local gamestabledata=""

gui.list.Visible=true
gui.game.Visible=false





do --game request handler
	local debuf=false
	--[[storage.serverRequestCache.ChildAdded:connect(function(x)
	--x.Value = game selection
	---requesting.Value = player that requested
	---requestversion.Value = server version requested 2007/2012
	---status.Value = status of request]]
	local function gameRequest(version)
		local x=nil;
		if gameselectiondata.userUploaded~=nil and gameselectiondata.userUploaded==true then
			x=Instance.new("StringValue")
			x.Name="startMyUserServer"
			x.Value=gameselectiondata
		else
			x=Instance.new("StringValue")
			x.Name="startMyServer"
			x.Value=gameselectiondata
		end 
		print("Sending a request to get game... ".. gameselectiondata)
		local xx=Instance.new("StringValue",x)
		xx.Name="status"
		xx.Value="Requested Server Hub for game."
		local xxx=Instance.new("StringValue",x)
		xxx.Name="requestversion"
		xxx.Value=version
		local xxxx=Instance.new("BoolValue",x)
		xxxx.Name="serverdone"
		xxxx.Value=false
		local xxxx=Instance.new("ObjectValue",x)
		xxxx.Name="creator"
		xxxx.Value=script.Parent.Parent.Parent
		x.Parent=storage.serverRequestCache
		--[[repeat 
			wait()
			gui.game.status.Text=xx.Value
		until
			xxxx.Value==true]]
		local bxd=gui.gamerequest:Clone()
		bxd.Parent=gui
		bxd.Name="gamerequestx"
		bxd.Visible=true
		local guix=gui.gamerequestx.bg
		guix.close.Visible=false
		guix.close.MouseButton1Click:connect(function()
			pcall(function()
				gui.gamerequestx.Visible=false
				gui.gamerequestx:Remove()
			end)
			gui.game.Visible=false
			gui.load.Visible=true
			RefreshGamePage()
			gui.load.Visible=false
			gui.game.Visible=true
		end)
		guix.xtitle.Text=gameselectiondata:sub(1,-6)
		xx.Changed:connect(function()
			if guix~=nil then
			if xx.Value:sub(1,4)=="fail" then 
				if xx.Value:sub(5)=="alreadyrunning" then
					guix.one.Text="Server is already running?"
					guix.one.ico.Image="https://i.imgur.com/tV1CMd9.png"
				elseif xx.Value:sub(5)=="busy" then
					guix.one.Text="Server is busy, blame the cookies.."
					guix.one.ico.Image="https://i.imgur.com/tV1CMd9.png"
				elseif xx.Value:sub(5)=="maxservers" then
					guix.one.Text="Server reported max limit reached."
					guix.one.ico.Image="https://i.imgur.com/tV1CMd9.png"
				elseif xx.Value:sub(5)=="dofile" then
					guix.three.Text="Server failed request."
					guix.three.ico.Image="https://i.imgur.com/tV1CMd9.png"
				elseif xx.Value:sub(5)=="toolong" then
					guix.six.Text="Server didn't report online in time."
					guix.six.ico.Image="https://i.imgur.com/tV1CMd9.png"
				end 
				guix.final.Text="Game did not start."
				guix.final.ico.Image="https://i.imgur.com/tV1CMd9.png"
				guix.close.Visible=true
			elseif xx.Value=="loggingin" then 
				guix.two.Text="Logged in"
				guix.one.Text="Server Ready"
				guix.one.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.two.ico.Image="https://i.imgur.com/s4YOJTh.png"
			elseif xx.Value=="siteinstance" then 
				guix.three.Text="Site Instance Requested"
				guix.one.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.two.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.three.ico.Image="https://i.imgur.com/s4YOJTh.png"
			elseif xx.Value:sub(1,6)=="dofile" then 
				guix.one.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.two.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.three.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.three.Text="Site Instance Created"
				guix.four.Text="Creating Studio Instance (".. xx.Value:sub(7)..")"
			elseif xx.Value=="startstudio" then 
				guix.one.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.two.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.three.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.four.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.five.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.five.Text="Server Start requested"
			elseif xx.Value:sub(1,12)=="startingtick" then 
				guix.close.Visible=true
				guix.six.Text="Waiting for server(".. xx.Value:sub(13) ..")"
			elseif xx.Value=="pass" then 
				guix.one.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.two.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.three.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.four.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.five.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.six.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.six.Text="Server reported online"
				guix.final.Text="Game has started."
				guix.final.ico.Image="https://i.imgur.com/s4YOJTh.png"
				guix.close.Visible=true
			end 
			end 
		end)
	end 
	gui.unstable.bg.ok.Visible=false
	gui.game.start.MouseButton1Click:connect(function()
		wait()
		if debuf==false then debuf=true
			gui.game.start.Visible=false
			gui.game.dummystart.Visible=true
			gui.game.status.Text="Opening game page.."
			wait(.2)
			gui.game.Visible=false
			gui.load.Visible=true
			--start getting game stable reports
			local stable=true
			local sevenall=0
			local sevengood=0
			local sevenstable=true
			local twelveall=0
			local twelvegood=0
			local twelvestable=true
			local total=0
			do
				--[[local x=Instance.new("StringValue")
				x.Name="StableReport"
				x.Value=tostring(gameselectiondata[3])
				x.Parent=storage.gameStableGet
				repeat 
					wait()
				until x.Value~=tostring(gameselectiondata[3])]]
				local z=tostring(gamestabledata)
				print("GotStableResult - " .. z)
				local main=explode([[|]],z)
				local twelve=explode([[=]],main[1])
				local seven=explode([[=]],main[2])
				total=tonumber(main[3])
				sevenall=seven[2]
				sevengood=seven[1]
				twelveall=twelve[2]
				twelvegood=twelve[1]
				
				if twelveall~=0 then
					if twelve[1]/twelve[2] < .6 then
						twelvestable=false
						stable=false
					end
				end 
				if sevenall~=0 then
					if seven[1]/seven[2] < .6 then
						sevenstable=false
						stable=false
					end
				end 
			end 
			if stable==false then
				gui.unstable.bg.xtitle.Text="Game ["..gameselectiondata:sub(1,-6).."]"
				if twelvestable==false then
					gui.unstable.bg.twelve.BackgroundColor3=Color3.new(1,0,0)
				else
					gui.unstable.bg.twelve.BackgroundColor3=Color3.new(51/255, 204/255, 51/255)
				end 
				if sevenstable==false then
					gui.unstable.bg.seven.BackgroundColor3=Color3.new(1,0,0)
				else
					gui.unstable.bg.seven.BackgroundColor3=Color3.new(51/255, 204/255, 51/255)
				end 
				if tonumber(twelveall)~=0 then
					gui.unstable.bg.twelvepercent.Text=math.floor( ( twelvegood/twelveall ) *100)/100
				else
					gui.unstable.bg.twelvepercent.Text=0
				end 
				if tonumber(sevenall)~=0 then
					gui.unstable.bg.sevenpercent.Text=math.floor( ( sevengood/sevenall ) *100)/100
				else
					gui.unstable.bg.sevenpercent.Text=0
				end 
				gui.unstable.bg.twelvestarts.Text=twelvegood .. " good starts out of " .. twelveall
				gui.unstable.bg.sevenstarts.Text=sevengood .. " good starts out of " .. sevenall
				gui.load.Visible=false
				gui.unstable.Visible=true
			else
				--is such n shit
				print("Attempting to show game selection... "..gameselectiondata)
				gui.gamestart.bg.xtitle.Text="Game ["..gameselectiondata:sub(1,-6).."]"
				gui.load.Visible=false
				gui.gamestart.Visible=true
			end 
		debuf=false end 
	end)
	gui.unstable.bg.ok.MouseButton1Down:connect(function()
		print("Attempting to show UNSTABLE game selection... ".. gameselectiondata)
		gui.gamestart.bg.xtitle.Text="Game [".. gameselectiondata:sub(1,-6) .."]"
		gui.unstable.Visible=false
		gui.gamestart.Visible=true
	end)
	gui.unstable.bg.back.MouseButton1Down:connect(function()
		gui.unstable.Visible=false
		gui.game.Visible=true
	end)
	--[[gui.gamestart.bg.seven.MouseButton1Click:connect(function()
		wait()
		if debuf==false then debuf=true
			gui.game.status.Text="Starting 2007 server..."
			gui.gamestart.Visible=false
			gameRequest("2007")
			debuf=false 
		end 
	end)]]
	gui.gamestart.bg.twelve.MouseButton1Click:connect(function()
		wait()
		if debuf==false then debuf=true
			gui.game.status.Text="Starting 2012 server..."
			gui.gamestart.Visible=false
			gameRequest("2012")
			debuf=false 
		end 
	end)
	gui.game.back.MouseButton1Click:connect(function()
		RenderServerList()
	end)
end 

function ClearList()
	for i,v in ipairs(gui.list.box.list:getChildren()) do
		v:Remove()
	end 
end 

function stopSpamming(title,msg,waits)
	local waito=waits or 2;
	gui.popup.title.Text=title
	gui.popup.msg.Text=msg
	gui.popup.ok.Visible=false
	gui.popup.Visible=true
	wait(waito)
	gui.popup.ok.Visible=true
end 

gui.popup.ok.MouseButton1Click:connect(function(x)
	gui.popup.Visible=false
end)

function RefreshGamePage()
	local x=Instance.new("BoolValue")
	x.Name="refreshData"
	x.Value=false
	x.Parent=storage.gameData[gameselectiondata].RefreshHandle
	repeat wait() until x.Value~=false
	--[[local x=Instance.new("NumberValue")
	x.Name="GameRequest"
	x.Value=gameselectiondata[3]
	local xx=Instance.new("StringValue",x)
	xx.Name="status"
	xx.Value="busy"
	local xxx=Instance.new("StringValue",x)
	xxx.Name="serverrunning"
	xxx.Value=""
	wait(.01)
	x.Parent=storage.gameInfoRequest
	--print("isbusy")
	repeat wait() until xxx.Value~=""]]
	--print("responded")
	print("Im with selection.. ..".. tostring(gameselectiondata))
	gui.game.running.Text=(storage.gameData[gameselectiondata].running.Value and "Server Running!") or "Server not running."
	--get data
	
	
	---getvotedata
	--[[local x=Instance.new("StringValue")
	x.Name="getVoteData"
	x.Value=gameselectiondata[3]
	local xx=Instance.new("StringValue",x)
	xx.Name="votey"
	local xxx=Instance.new("StringValue",x)
	xxx.Name="votes"
	x.Parent=storage.gameGetVotes
	repeat wait() until x.Value=="done"]]
	wait()
	local xvotes=storage.gameData[gameselectiondata].votes.Value
	--print("votes? " .. xvotes)
	xvotes=explode("=",xvotes)
	local voteyesobj=gui.game.votebar.voteyes
	local votesobj=gui.game.votebar.votes
	voteyesobj.Value=xvotes[1]
	votesobj.Value=xvotes[2]
	gui.game.votebar.nums.Text=xvotes[1].."/"..xvotes[2]
	--
	gui.game.votebar.bar.Size=UDim2.new(0,0,1,0)
	local getsize=1
	if votesobj.Value==0 then
		getsize=.5
	else
		getsize=voteyesobj.Value / votesobj.Value
	end 
	clrcmts()
	---getcommentdata
	--[[local x=Instance.new("StringValue")
	x.Name="getCommentsData"
	x.Value=gameselectiondata[3]
	x.Parent=storage.gameGetComments
	repeat wait() until x.Value~=gameselectiondata[3]]
	wait()
	local comdata=storage.gameData[gameselectiondata].comments.Value
	local num=explode('\n',comdata)
	--print("hey, heres that comment.. `"..x.Value.."`")
	do
		local xdex=0
		if num then
			for i,v in ipairs(num) do
				if v~="" then
					--print("yay comment - how cool > `"..v.."` <")
					local hfind=string.find(v,":")
					if not hfind then
						print("broke hfind! ".. v)
					end 
					local usr=string.sub(v,1,hfind-1)
					local msg=string.sub(v,hfind+1)
					local cmb=commentbox:Clone()
					cmb.Text=msg
					cmb.user.Text=usr
					cmb.Parent=gui.game.coms.comss.comsss
					cmb.Position=UDim2.new(0,1,-xdex,1)
					xdex=xdex+1;
				end 
			end 
		else
			print("num was false 4 comments")
		end 
	end 
	--get data
	--getstabledata
	
	--[[local x=Instance.new("StringValue")
	x.Name="StableReport"
	x.Value=tostring(gameselectiondata[3])
	x.Parent=storage.gameStableGet
	repeat 
		wait()
	until x.Value~=tostring(gameselectiondata[3])]]
	
	if storage.gameData[gameselectiondata]:findFirstChild("stabledata")~=nil then
		gamestabledata=storage.gameData[gameselectiondata].stabledata.Value
		gui.game.trustable.Text=gamestabledata
	end 
	
	--endofstabledata
	gui.game.title.Text=gameselectiondata:sub(1,-6)
	gui.game.dummystart.Visible=false
	gui.game.start.Visible=false
	gui.load.Visible=false
	gui.game.Visible=true
	gui.game.teleport.Visible=false
	wait()
	gui.game.votebar.bar:TweenSize(UDim2.new(getsize,0,1,0),nil,nil,.8)
	gui.game.status.Text="Anti-Spam hold."
	gui.load.Visible=false
	gui.game.start.Visible=false
	gui.game.holdstart.Visible=true
	wait(1)
	if gui.game.running.Text=="Server is running" then
		gui.game.status.Text="Ready to join server."
		gui.game.holdstart.Visible=false
		gui.game.teleport.Visible=true
	else
		gui.game.status.Text="Ready to start server."
		gui.game.holdstart.Visible=false
		gui.game.start.Visible=true
	end 
end 

function RenderServerList()
	--showinggames=processReturnGameList()
	--gui.list.box.list:ClearAllChildren()
	ClearList()
	if shownsfw==false then
		if sortedlist==false then
			showinggames=processReturnGameList()
			sortedlist=true
			if sorttype==1 then --sort by votes
				table.sort(showinggames, function(a, b)
					local avalue=0.2;
					local bvalue=.9;
					
					if storage.gameData[a[1]]:findFirstChild("votes")~=nil then
						local az=storage.gameData[a[1]].votes;
						local y=explode([[=]],az.Value)
						avalue=tonumber(y[1]) / tonumber(y[2])
						if tonumber(y[2])==0 then
							avalue=nil
							--print("Game ".. a[1] .." has no votes???!")
						end 
					else
						avalue=nil
					end 					
					if storage.gameData[b[1]]:findFirstChild("votes")~=nil then
						local az=storage.gameData[b[1]].votes;
						local y=explode([[=]],az.Value)
						bvalue=tonumber(y[1]) / tonumber(y[2])
						if tonumber(y[2])==0 then
							bvalue=nil
							--print("Game ".. b[1] .." has no votes???!")
						end 
					else
						bvalue=nil
					end 
					if bvalue==nil and avalue~=nil then
						bvalue=0
						avalue=.9
					elseif avalue==nil and bvalue~=nil then
						avalue=0
						bvalue=.9
					elseif avalue==nil and bvalue==nil then
						avalue=.1
						bvalue=.9
					end 
					--print(avalue.." vs "..bvalue)
					return avalue*100 > bvalue*100
				end)
			elseif sorttype==2 then  --sort by names
				table.sort(showinggames, function(a, b)
					return a[1] > b[1]
				end)
			elseif sorttype==3 then  --sort by running
				table.sort(showinggames, function(a, b)
					local avalue=0;
					local bvalue=0;
					
					if storage.gameData[a[1]]:findFirstChild("running")~=nil then
						if storage.gameData[a[1]].running.Value then
							avalue=1
						else
							avalue=0
						end 
					end 
					
					if storage.gameData[b[1]]:findFirstChild("running")~=nil then
						if storage.gameData[b[1]].running.Value then
							bvalue=1
						else
							bvalue=0
						end 
					end 
					
					--print(avalue.." vs "..bvalue)
					return avalue > bvalue
				end)
			elseif sorttype==0 then  --sort by search query
				--[[for i,v in ipairs(showinggames) do
					v[5]=fuzzyscore(v[1],searchqueue)
				end 
				table.sort(showinggames, function(a, b)
					return a[5] > b[5]
				end)]]--old method
				--get results for searchqueue
				showinggames=fuzzyscore(searchqueue)
			end 
		end 
	end
	--print("Going to be "..pages.." pages.")
	pages=(math.floor(#showinggames/30)) +1
	gui.list.box.page.Text="Page "..pagenum.."/"..pages
	gui.load.Visible=false
	gui.game.Visible=false
	gui.gamestart.Visible=false
	gui.list.Visible=true
	local getrange=((pagenum-1)*30)
	local rowindex=0
	for a=getrange+1,getrange+30 do --do game list
		if showinggames[a] then
			local adxpos=0
			local s=serverbox:Clone()
			if (a%2)==0 and a~=getrange then
				adxpos=.5
				s.Position=UDim2.new(adxpos,5,((rowindex/15.5)) +.01,0)
				rowindex=rowindex+1
			else
				s.Position=UDim2.new(adxpos,0,((rowindex/15.5)) +.01,0)
			end
			s.Text=showinggames[a][1]:sub(1,-6)
			s.Parent=gui.list.box.list
			if storage.gameData[showinggames[a][1]]:findFirstChild("votes")~=nil then
				local vote=explode('=',storage.gameData[showinggames[a][1]].votes.Value)
				if tonumber(vote[2])~=0 then 
					local votey=tonumber(vote[1])
					local votes=tonumber(vote[2])
					local sizeed=votey / votes
					s.back.Visible=true
					s.middle.Visible=true
					s.ranking.Visible=true
					s.votee.Visible=true
					s.votee.Text=tostring( (math.floor(sizeed*100))/100 )
					s.ranking.Size=UDim2.new(sizeed,-1,0,3)
				else
					s:ClearAllChildren()
					--print("dont show results for "..a)
				end 
			else
				s:ClearAllChildren()
			end 
			local xxoos=storage.gameData[showinggames[a][1]]:findFirstChild("running")
			if xxoos~=nil then
				if storage.gameData[showinggames[a][1]]:findFirstChild("running")~=nil then
					if storage.gameData[showinggames[a][1]].running.Value==true then
						s.BackgroundColor3=Color3.new(0, 215/255, 135/255)--(102/255, 204/255, 255/255) --0; 214; 135
					end 
				end 
			end 
			if storage.gameData[showinggames[a][1]].usergame.Value==true then
				s.BackgroundColor3=Color3.new(
					s.BackgroundColor3.r + (0/255),
					s.BackgroundColor3.g + (75/255),
					s.BackgroundColor3.b + (50/255)
				)
			end 
			--end 
			local indexo=tonumber(a);
			s.MouseButton1Click:connect(function()
				--gameselection=indexo; --new sort feature breaks this.
				gameselectiondata=showinggames[indexo][1];
				print("game selection is now .. " .. gameselectiondata)
				gui.list.Visible=false
				gui.load.Visible=true
				
				RefreshGamePage()
				
			end)
		end
	end 
end 

do --do a vote request
	local deboax=false
	local plr=script.Parent.Parent.Parent
	local voteyesobj=gui.game.votebar.voteyes
	local votesobj=gui.game.votebar.votes
	local function doVotex(a)
		--print("dx2")
		local x=Instance.new("StringValue")
		x.Name="VoteRequest"
		x.Value=gameselectiondata
		local xx=Instance.new("ObjectValue",x)
		xx.Name="name"
		xx.Value=plr
		local xxx=Instance.new("StringValue",x)
		xxx.Name="vote"
		xxx.Value=a
		x.Parent=storage.gameVoteRequest
		--print("dx3")
		repeat wait() until x.Value~=tostring(gameselectiondata[3])
		--print("dx3.5 result > "..x.Value)
		local y=explode([[=]],x.Value)
		--print("dx4 and i got > "..y[1].." and > "..y[2])
		voteyesobj.Value=y[1]
		votesobj.Value=y[2]
		local getsize=1
		if votesobj.Value==0 then
			getsize=.5
		else
			getsize=voteyesobj.Value / votesobj.Value
		end 
		gui.game.votebar.nums.Text=voteyesobj.Value.."/"..votesobj.Value
		gui.game.votebar.bar.Size=UDim2.new(0,0,1,0)
		gui.game.votebar.bar:TweenSize(UDim2.new(getsize,0,1,0),nil,nil,.4)
		--print("dx5;(")
	end 
	gui.game.votebar.gold.MouseButton1Click:connect(function()
		wait()
		if deboax==false then deboax=true 
			print("DoingGoldRequest")
			doVotex("1")
			wait(6)
			deboax=false 
		else
			stopSpamming("Too many vote requests.","You can't 'gold' a game too fast. Please wait for 10 seconds.")
		end  
	end)
	gui.game.votebar.dirt.MouseButton1Click:connect(function()
		wait()
		if deboax==false then deboax=true 
			doVotex("-1")
			wait(6)
			deboax=false 
		else
			stopSpamming("Too many vote requests.","You can't 'dirt' a game too fast. Please wait for 10 seconds.")
		end 
	end)
end 

do --teleport request
	local deboax=false
	local plr=script.Parent.Parent.Parent
	gui.game.teleport.MouseButton1Click:connect(function()
		wait()
		if deboax==false then deboax=true 
			gui.game.teleport.Text="Sent teleport request."
			local x=Instance.new("StringValue")
			x.Value=gameselectiondata[3]
			x.Name="teleportReqeuest"
			local xx=Instance.new("ObjectValue",x)
			xx.Value=plr
			xx.Name="plr"
			wait()
			x.Parent=storage.teleportRequest
			wait(8)
			gui.game.teleport.Text="Teleport"
		deboax=false end 
	end)
end 

do --game page refresh
	local deboax=false
	gui.game.refresh.MouseButton1Click:connect(function()
		wait()
		if deboax==false then deboax=true 
			gui.game.refresh.Text="Freeze."
			gui.game.Visible=false
			gui.load.Visible=true
			
			RefreshGamePage()
			
			gui.load.Visible=false
			gui.game.Visible=true
			wait(5)
			gui.game.refresh.Text="Refresh"
			deboax=false 
		end 
	end)
end 

do --comment handler
	local deboax=false
	local plr=script.Parent.Parent.Parent
	gui.game.sendcomment.MouseButton1Click:connect(function()
		wait()
		print("Click??")
		if deboax==false then deboax=true 
			print("DoingNewComment")
			if gui.game.commentbox.Text:sub(1,7)=="New com" then
				stopSpamming("Comment?","You didn't put anything in the comment box..")
			else 
			for i,v in ipairs(gui.game.coms.comss.comsss:GetChildren()) do
				--shifter.
				v.Position=v.Position+UDim2.new(0,0,-1,0)
			end 
			local cmb=commentbox:Clone()
			local queuemsg=gui.game.commentbox.Text
			cmb.Text="waiting for server."
			gui.game.commentbox.Text="Sending comment..."
			cmb.user.Text=plr.Name
			cmb.Parent=gui.game.coms.comss.comsss
			cmb.Position=UDim2.new(0,1,0,1)
			--send new comment
			local x=Instance.new("StringValue")
			x.Value=gameselectiondata[3]
			x.Name="newComment"
			local xx=Instance.new("ObjectValue",x)
			xx.Value=plr
			xx.Name="name"
			local xxx=Instance.new("StringValue",x)
			xxx.Name="comment"
			xxx.Value=queuemsg
			wait()
			x.Parent=storage.gameCommentsRequest
			repeat wait() until x.Value~=gameselectiondata[3]
			wait()
			cmb.Text=queuemsg
			gui.game.commentbox.Text="New comment here."
			--end of new comment send
			--[[storage.gameCommentsRequest.ChildAdded:connect(function(x)
	--x.Value = game selection
	---name.Value = player that commented, objectValue
	---comment.Value = message
	x.Value=AddComment(x.name.Value.Name,x.Value,x.comment.Value)
end)]]
			wait(22)
			end 
			deboax=false 
		else
			stopSpamming("Too fast.","Please wait for 30 seconds before sending another comment.")
		end  
	end)
end 

do --refresh games list
	local deboax=false
	gui.list.refresh.MouseButton1Click:connect(function()
		wait()
		if deboax==false then deboax=true 
			local x=Instance.new("StringValue",storage.runningServers)
			gui.list.refresh.Text="Refreshing.."
			repeat wait() until x==nil or x.Parent~=storage.runningServers
			gui.list.server.Text="Servers Running: ".. storage.runningServers.Value .."/8"  --howmanyserverauth--allow how many servers--how many running servers
			RenderServerList()
			gui.list.refresh.Text="Refreshed"
			wait(3)
			gui.list.refresh.Text="Refresh"
		deboax=false end 
	end)
end 

gui.list.box.nsfw.MouseButton1Click:connect(function()
	shownsfw=not shownsfw
	if shownsfw then
		gui.list.box.nsfw.Text="NSFW:show"
	else
		gui.list.box.nsfw.Text="NSFW:hide"
	end 
	showinggames={};
	showinggames=processReturnGameList()
	pages=(math.floor(#showinggames/18)) +1
	pagenum=1
	RenderServerList()
end)

gui.list.box.userupx.MouseButton1Click:connect(function()
	showuser=showuser+1
	if showuser>2 then
		showuser=0
	end 
	--0 show both
	--1 show inF
	--2 show userup
	if showuser==0 then
		gui.list.box.userupx.Text="Games: All"
	elseif showuser==1 then
		gui.list.box.userupx.Text="Games: inF"
	else
		gui.list.box.userupx.Text="Games: Users"
	end 
	showinggames={};
	gui.load.Visible=true
	gui.list.Visible=false
	wait()
	showinggames=processReturnGameList()
	wait(.5)
	gui.load.Visible=false
	gui.list.Visible=true
	pages=(math.floor(#showinggames/18)) +1
	pagenum=1
	RenderServerList()
end)

gui.list.left.MouseButton1Click:connect(function()
	if pagenum-1>0 then
		pages=(math.floor(#showinggames/18)) +1
		pagenum=pagenum-1
		RenderServerList()
	end 
end)

gui.list.right.MouseButton1Click:connect(function()
	if pagenum<pages then
		pages=(math.floor(#showinggames/18)) +1
		pagenum=pagenum+1
		RenderServerList()
	end 
end)
gui.list.server.Text="Servers Running: ".. storage.runningServers.Value .."/8"

--check if user approved tos.

gui.load.Visible=false
gui.list.Visible=false
do --tos accept
	local buffa=false
	gui.tos.accept.MouseButton1Click:connect(function() wait()
		if buffa==false then
			buffa=true
			gui.load.Visible=true
			gui.tos.Visible=false
			wait()
			showinggames=processReturnGameList()
			RenderServerList()
			wait(3)
			buffa=false
		end 
	end)

end 

gui.list.box.vote.MouseButton1Down:connect(function()
	sorttype=sorttype+1
	if sorttype>3 then
		sorttype=1
	end 
	if sorttype==1 then
		gui.list.box.vote.Text="SortBy: Vote"
		sortedlist=false
		RenderServerList()
	elseif sorttype==2 then
		gui.list.box.vote.Text="SortBy: Name"
		sortedlist=false
		RenderServerList()
	elseif sorttype==3 then
		gui.list.box.vote.Text="SortBy: Running"
		sortedlist=false
		RenderServerList()
	end 
end)

do
	local vis=false
	gui.hubkey.MouseButton1Down:connect(function()
		vis=not vis
		gui.tos.Visible=vis
		gui.list.Visible=false
		gui.game.Visible=false
		gui.gamerequest.Visible=false
		gui.load.Visible=false
		gui.popup.Visible=false
		gui.unstable.Visible=false
		if vis==true then
			gui.hubkey.Text="< skdaddle"
		else
			gui.hubkey.Text="switsh >"
		end 
	end)
end 

do
	local doSearch=false
	local texe=tick()
	local doingSearching=""
	local focuslostempty=false
	gui.list.box.search.MouseButton1Down:connect(function()
		if doSearch==false then
			doSearch=true
			gui.list.box.search.Text="Searching"
			sortedlist=false
			sorttype=0
			gui.list.box.vote.Text="SortBy: Search"
			RenderServerList()
			focuslostempty=false
			repeat wait(.2)
				if gui.list.box.searchbox.Text~=doingSearching then
					print("New Text!")
					gui.list.box.list:ClearAllChildren()
					doingSearching=gui.list.box.searchbox.Text
					searchqueue=tostring(doingSearching)
					sortedlist=false
					RenderServerList()
				end 
			until focuslostempty==true or doSearch==false or gui.list.box.vote.Text~="SortBy: Search" or sorttype~=0
			if gui.list.box.searchbox.Text~=doingSearching then
				doingSearching=gui.list.box.searchbox.Text
				searchqueue=tostring(doingSearching)
				sortedlist=false
				RenderServerList()
			end 
			doSearch=false
			focuslostempty=true
		else
			gui.list.box.search.Text="Search"
			doSearch=false
			focuslostempty=true
		end 
	end)
	gui.list.box.searchbox.FocusLost:connect(function()
		if gui.list.box.searchbox.Text~=doingSearching then
			doingSearching=gui.list.box.searchbox.Text
			searchqueue=tostring(doingSearching)
			sortedlist=false
			RenderServerList()
		end 
		if gui.list.box.searchbox.Text=="" or gui.list.box.searchbox.Text==" " or gui.list.box.searchbox.Text=="  " then
			focuslostempty=true
			doSearch=false
		end 
	end)
end 