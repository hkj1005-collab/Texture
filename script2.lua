-- =====================================================================
-- UNDERTALE TEXTURE PACK (MOBILE SILENT DIRECT-LOAD OVERRIDE)
-- =====================================================================

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- State system tracker
local OriginalAssets = setmetatable({}, {__mode = "k"})

-- 移動端本地緩存解碼機制 (直讀強解)
local function getAsset(url: string, backupRobloxId: string): string
	if url == "" or not url then return backupRobloxId end
	local success, result = pcall(function()
		if writefile and isfile and getcustomasset then
			local fileExt = string.match(url, "%.%w+$") or ".asset"
			local fileName = "ut_silent_cache_" .. tostring(string.len(url) % 999) .. "_" .. tostring(string.byte(url, -1) or 1) .. fileExt
			
			if not isfile(fileName) then
				local data = game:HttpGet(url)
				if data and #data > 50 then 
					writefile(fileName, data) 
				end
			end
			
			local asset = getcustomasset(fileName)
			if asset and asset ~= "" then 
				return asset 
			end
		end
		return backupRobloxId
	end)
	return (success and result) or backupRobloxId
end

-- 終極對齊映射矩陣表 (完全按照你的實體雲端網址重新對齊)
local Rules = {
	{ids = {12187323909, 12187320363, 12187354260, 12187342816, 12187280273, 12187303601, 12187262242, 12187288714, 12187341500, 12187271237, 12187341020}, url = "https://githubusercontent.com", backup = "rbxassetid://12187323909"},
	{ids = {6384899588}, url = "https://githubusercontent.com", backup = "rbxassetid://9069609268"}, -- 開場
	{ids = {8483887957}, url = "https://githubusercontent.com", backup = "rbxassetid://9114223147"}, -- 拔出
	{ids = {16537337310, 16537449730}, url = "https://githubusercontent.com", backup = "rbxassetid://6541285184"}, -- 擊碎
	{ids = {7658055825}, url = "", backup = "rbxassetid://6372755229"}, -- arena change to basalt
	{ids = {17016581922}, url = "https://githubusercontent.com", backup = "rbxassetid://6541285184"}, -- 淘汰
	{ids = {16810321565}, url = "https://githubusercontent.com", backup = "rbxassetid://9083072214"}, -- 落敗
	{ids = {16770456156}, url = "https://githubusercontent.com", backup = "rbxassetid://9114221327"}, -- 二段跳
	{ids = {177266782}, url = "https://githubusercontent.com", backup = "rbxassetid://9114227181"}, -- 點擊 UI
	{ids = {16492958314}, url = "https://githubusercontent.com", backup = "rbxassetid://9117325515"}, -- 衝刺
	{ids = {16802957270}, url = "https://githubusercontent.com", backup = "rbxassetid://16802957270"},
	{ids = {103035811146294}, url = "https://githubusercontent.com", backup = "rbxassetid://9114223147"}, -- 地圖載入
	{ids = {81461991645938}, url = "https://githubusercontent.com", backup = "rbxassetid://81461991645938"},
	{ids = {16810041280}, url = "https://githubusercontent.com", backup = "rbxassetid://2923588961"}, -- 勝利
	{ids = {16530229695, 16530229541, 16530229616}, url = "https://githubusercontent.com", backup = "rbxassetid://5534241639"}, -- 擊殺
	{ids = {17138490999}, url = "https://githubusercontent.com", backup = "rbxassetid://6541282202"}, -- 治療
	{ids = {13854780042}, url = "https://githubusercontent.com", backup = "rbxassetid://13854780042"},
	{ids = {13854780213}, url = "https://githubusercontent.com", backup = "rbxassetid://13854780213"},
	{ids = {17803962335}, url = "https://githubusercontent.com", backup = "rbxassetid://17803962335"},
	{ids = {18525513345}, url = "https://githubusercontent.com", backup = "rbxassetid://9114227181"}, -- 配對
	{ids = {13110130082}, url = "https://githubusercontent.com", backup = "rbxassetid://5534241639"}, -- 命中
	{ids = {17153811469}, url = "https://githubusercontent.com", backup = "rbxassetid://9113636306"}, -- 揮空
	{ids = {13188153054, 13188242420, 13220167472, 13220167337}, url = "https://githubusercontent.com", backup = "rbxassetid://13188153054"},
	{ids = {17826470563}, url = "https://githubusercontent.com", backup = "rbxassetid://3410787012"}, -- 倒數
	{ids = {17026600996}, url = "https://githubusercontent.com", backup = "rbxassetid://9113636306"}, -- 賽點
	{ids = {17467242617}, url = "https://githubusercontent.com", backup = "rbxassetid://3410787012"}, -- 延長賽
	{ids = {18221725850, 18239670056, 18221726246}, url = "https://githubusercontent.com", backup = "rbxassetid://2923588961"}, -- 勝利2
	{ids = {17813065011, 17813065464, 12099785239}, url = "", backup = ""}, -- remove ambience
	{ids = {2108482005, 14147881792, 135908632589654, 84214501374682, 10196550937, 12261809766, 2108545280, 10196550667, 14147882149, 103020541883227, 89972436184102, 12261813110, 14147883091, 2108482395, 10196550128, 14147882405, 2108482542, 10196549902, 14147881297, 72960281658487, 92138082970751, 2108482676, 10196567794, 12261813678, 14147882761, 10196550367, 2108482231}, url = "", backup = "rbxassetid://7658055825"}, -- trap the skybox
	{ids = {127338559130032, 16294586406, 75156669118637, 93477262732302}, url = "https://githubusercontent.com", backup = "rbxassetid://127338559130032"},
	{ids = {17697682466, 17733314783}, url = "https://githubusercontent.com", backup = "rbxassetid://9043887031"}, -- 背景音樂
	{ids = {133917828562858, 121503061771505}, url = "https://githubusercontent.com", backup = "rbxassetid://133917828562858"}, -- flowey
	{ids = {133793956251748}, url = "https://githubusercontent.com", backup = "rbxassetid://133793956251748"}, -- arch to x+
	{ids = {116941545385923}, url = "https://githubusercontent.com", backup = "rbxassetid://116941545385923"}, -- nem to x standard
	{ids = {106623367501544, 131795064007344, 73543520622815}, url = "https://githubusercontent.com", backup = "rbxassetid://106623367501544"}, -- bronze 3
	{ids = {80716950169934}, url = "https://githubusercontent.com", backup = "rbxassetid://80716950169934"}, -- silver 1
	{ids = {136100661820261}, url = "https://githubusercontent.com", backup = "rbxassetid://136100661820261"}, -- silver 2
	{ids = {107898816876115}, url = "https://githubusercontent.com", backup = "rbxassetid://107898816876115"}, -- silver 3
	{ids = {134520747948636}, url = "https://githubusercontent.com", backup = "rbxassetid://134520747948636"}, -- gold 1
	{ids = {114166096331502}, url = "https://githubusercontent.com", backup = "rbxassetid://114166096331502"}, -- gold 2
	{ids = {90039594400813}, url = "https://githubusercontent.com", backup = "rbxassetid://90039594400813"}, -- gold 3
	{ids = {133903971285645}, url = "https://githubusercontent.com", backup = "rbxassetid://133903971285645"}, -- plat 1
	{ids = {82834564754747}, url = "https://githubusercontent.com", backup = "rbxassetid://82834564754747"}, -- plat 2
	{ids = {73345783863790}, url = "https://githubusercontent.com", backup = "rbxassetid://73345783863790"}, -- plat 3
	{ids = {113997689031026}, url = "https://githubusercontent.com", backup = "rbxassetid://113997689031026"}, -- diam 1
	{ids = {88059506918419}, url = "https://githubusercontent.com", backup = "rbxassetid://88059506918419"}, -- diam 2
	{ids = {112183171942172}, url = "https://githubusercontent.com", backup = "rbxassetid://112183171942172"}, -- diam 3
	{ids = {104871954739030}, url = "https://githubusercontent.com", backup = "rbxassetid://104871954739030"}, -- o1 to s
	{ids = {109012386782238}, url = "https://githubusercontent.com", backup = "rbxassetid://109012386782238"}, -- o2 to ss
	{ids = {127982903682334}, url = "https://githubusercontent.com", backup = "rbxassetid://127982903682334"}, -- o3 to u
{ids = {106623367501544}, url = "githubusercontent.com", backup = "rbxassetid://106623367501544"}, -- bronze 1
{ids = {131795064007344}, url = "githubusercontent.com", backup = "rbxassetid://131795064007344"}, -- b2 to heart
{ids = {17175092502, 17094014569}, url = "githubusercontent.com", backup = "rbxassetid://17175092502"}, -- streak icon
{ids = {111599878354131}, url = "githubusercontent.com", backup = "rbxassetid://111599878354131"} -- unranked
}
-- 核心哈希解析
local IdMap = {}
for _, rule in ipairs(Rules) do
local asset = rule.backup
if string.sub(rule.url, 1, 4) == "http" then
asset = getAsset(rule.url, rule.backup)
end
for _, id in ipairs(rule.ids) do
IdMap[tostring(id)] = asset
end
end
-- 全局材質替換邏輯
local function applyTextureSwap(obj: Instance)
if not obj then return end
local function replace(property: string)
local success, value = pcall(function() return obj[property] end)
if not success or type(value) ~= "string" then return end
local id = string.match(value, "%d+")
if id and IdMap[id] then
if not OriginalAssets[obj] then OriginalAssets[obj] = {} end
if not OriginalAssets[obj][property] then OriginalAssets[obj][property] = value end
pcall(function() obj[property] = IdMap[id] end)
end
end
if obj:IsA("Sound") then
replace("SoundId")
elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
replace("Image")
elseif obj:IsA("Decal") or obj:IsA("Texture") then
replace("Texture")
elseif obj:IsA("MeshPart") then
replace("TextureID")
end
end
-- 靜默一鍵全自動加載啟動
batchProcess(game:GetDescendants(), applyTextureSwap, 150)
