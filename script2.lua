-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- UNLOAD & STATE SYSTEM TRACKER
-- ==========================================
local isUnloaded = false
local Connections = {}

local function TrackConnection(conn)
	if conn then
		table.insert(Connections, conn)
	end
	return conn
end

-- UI Parent Setup
local TargetParent = game:GetService("CoreGui")
if gethui then TargetParent = gethui() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomTextureLuaUI_Mobile"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = TargetParent end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- ==========================================
-- HELPER: BATCH PROCESSING 
-- ==========================================
local function batchProcess(items, callback, batchSize)
    batchSize = batchSize or 120
    task.spawn(function()
        for i = 1, #items do
            if isUnloaded then break end 
            callback(items[i])
            if i % batchSize == 0 then
                task.wait()
            end
        end
    end)
end

-- ==========================================
-- NOTIFICATION SYSTEM (BOTTOM LEFT)
-- ==========================================
local function showNotification(titleText, bodyText, duration)
    if isUnloaded then return end
    duration = duration or 5

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "NotificationFrame"
    NotifFrame.Size = UDim2.new(0, 250, 0, 52)
    NotifFrame.Position = UDim2.new(0, -270, 1, -70)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    NotifFrame.BorderColor3 = Color3.fromRGB(65, 65, 70)
    NotifFrame.BorderSizePixel = 1
    NotifFrame.ZIndex = 200
    NotifFrame.Parent = ScreenGui

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 3, 1, 0)
    AccentBar.Position = UDim2.new(0, 0, 0, 0)
    AccentBar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    AccentBar.BorderSizePixel = 0
    AccentBar.ZIndex = 201
    AccentBar.Parent = NotifFrame

    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -15, 0, 20)
    NotifTitle.Position = UDim2.new(0, 12, 0, 6)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Font = Enum.Font.Code
    NotifTitle.Text = titleText
    NotifTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
    NotifTitle.TextSize = 12
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.ZIndex = 201
    NotifTitle.Parent = NotifFrame

    local NotifBody = Instance.new("TextLabel")
    NotifBody.Size = UDim2.new(1, -15, 0, 20)
    NotifBody.Position = UDim2.new(0, 12, 0, 26)
    NotifBody.BackgroundTransparency = 1
    NotifBody.Font = Enum.Font.Code
    NotifBody.Text = bodyText
    NotifBody.TextColor3 = Color3.fromRGB(200, 200, 205)
    NotifBody.TextSize = 11
    NotifBody.TextXAlignment = Enum.TextXAlignment.Left
    NotifBody.ZIndex = 201
    NotifBody.Parent = NotifFrame

    local tweenIn = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 15, 1, -70)
    })
	tweenIn:Play()

    task.delay(duration, function()
        if not isUnloaded and NotifFrame and NotifFrame.Parent then
            local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0, -270, 1, -70)
            })
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                NotifFrame:Destroy()
			end)
        end
    end)
end

showNotification("Undertale Mobile Loaded!", "Custom Build for Mobile Users", 5)

-- ==========================================
-- MAIN CONTAINER BUILD
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.BorderColor3 = Color3.fromRGB(65, 65, 70)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true 
MainFrame.Parent = ScreenGui

-- Mobile Screen Toggle Button
local MobileMenuBtn = Instance.new("TextButton")
MobileMenuBtn.Name = "MobileMenuBtn"
MobileMenuBtn.Size = UDim2.new(0, 110, 0, 32)
MobileMenuBtn.Position = UDim2.new(0, 15, 0, 15)
MobileMenuBtn.BackgroundColor3 = Color3.fromRGB(24, 22, 26)
MobileMenuBtn.BorderColor3 = Color3.fromRGB(255, 100, 100)
MobileMenuBtn.BorderSizePixel = 1
MobileMenuBtn.Font = Enum.Font.Code
MobileMenuBtn.Text = "[❤️Close UI]"
MobileMenuBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
MobileMenuBtn.TextSize = 12
MobileMenuBtn.ZIndex = 150
MobileMenuBtn.Active = true
MobileMenuBtn.Draggable = true 
MobileMenuBtn.Parent = ScreenGui

local function updateMenuButtonText()
    if isUnloaded then return end
    if MainFrame.Visible then
        MobileMenuBtn.Text = "[❤️Close UI]"
        MobileMenuBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
    else
        MobileMenuBtn.Text = "[❤️Open UI]"
        MobileMenuBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end

TrackConnection(MobileMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    updateMenuButtonText()
end))

-- Header Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 22)
TitleLabel.Position = UDim2.new(0, 10, 0, 2)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.Code
TitleLabel.Text = "Undertale Texture Pack | [🏆Mobile Remake]"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -10, 0, 24)
TabBar.Position = UDim2.new(0, 5, 0, 26)
TabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
TabBar.BorderColor3 = Color3.fromRGB(50, 50, 55)
TabBar.BorderSizePixel = 1
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = TabBar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -10, 1, -56)
ContentContainer.Position = UDim2.new(0, 5, 0, 54)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Tabs = {}
local function createTab(name, width)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, width, 1, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    TabButton.BorderColor3 = Color3.fromRGB(55, 55, 60)
    TabButton.BorderSizePixel = 1
    TabButton.Font = Enum.Font.Code
    TabButton.Text = "[" .. name .. "]"
    TabButton.TextColor3 = Color3.fromRGB(160, 160, 165)
    TabButton.TextSize = 11
    TabButton.Parent = TabBar

    local TabPage = Instance.new("Frame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.Parent = ContentContainer

    TrackConnection(TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Page.Visible = false
            tab.Button.TextColor3 = Color3.fromRGB(160, 160, 165)
            tab.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        end
        TabPage.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    end))

    table.insert(Tabs, { Button = TabButton, Page = TabPage })
    if #Tabs == 1 then
        TabPage.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	end

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 5)
    ListLayout.Parent = TabPage

    return TabPage
end

-- UI Tabs
local TexturesTab = createTab("Texture Pack", 100)
local MapTab = createTab("Map Darkener", 100)
local SettingsTab = createTab("Unload", 100)

local OriginalAssets = setmetatable({}, {__mode = "k"})
local ActivePackDisableFunc = nil
local ActivePackButton = nil

-- DYNAMIC AUDIO/ASSET GETTER WITH BUILT-IN ROBLOX ID FALLBACKS
local function getAsset(url: string, backupRobloxId: string): string
	local success, result = pcall(function()
		if writefile and isfile and getcustomasset then
			local fileName = "ut_" .. tostring(string.len(url) % 99999) .. "_" .. tostring(string.byte(url, 10) or 1) .. ".asset"
			if not isfile(fileName) then
				local data = game:HttpGet(url)
				if data and #data > 80 then writefile(fileName, data) end
			end
			local asset = getcustomasset(fileName)
			if asset and asset ~= "" then return asset end
		end
		return backupRobloxId
	end)
	return (success and result) or backupRobloxId
end

-- 【完美重組優化版】：全面導入你給的實體雲端網址，並內建高相容性的純數字官方備用 ID
local Rules = {
	{ids = {12187323909, 12187320363, 12187354260, 12187342816, 12187280273, 12187303601, 12187262242, 12187288714, 12187341500, 12187271237, 12187341020}, url = "https://githubusercontent.com", backup = "rbxassetid://12187323909"},
	{ids = {6384899588}, url = "https://githubusercontent.com", backup = "rbxassetid://9069609268"}, -- 開場
	{ids = {8483887957}, url = "https://githubusercontent.com", backup = "rbxassetid://9114223147"}, -- 拔出
{ids = {16537337310, 16537449730}, url = "githubusercontent.com", backup = "rbxassetid://6541285184"}, -- 擊碎
{ids = {7658055825}, url = "rbxassetid://6372755229", backup = "rbxassetid://6372755229"},
{ids = {17016581922}, url = "githubusercontent.com", backup = "rbxassetid://6541285184"}, -- 淘汰
{ids = {16810321565}, url = "githubusercontent.com", backup = "rbxassetid://9083072214"}, -- 落敗
{ids = {16770456156}, url = "githubusercontent.com", backup = "rbxassetid://9114221327"}, -- 二段跳
{ids = {177266782}, url = "githubusercontent.com", backup = "rbxassetid://9114227181"}, -- 點擊 UI
{ids = {16492958314}, url = "githubusercontent.com", backup = "rbxassetid://9117325515"}, -- 衝刺
{ids = {16802957270}, url = "githubusercontent.com", backup = "rbxassetid://16802957270"},
{ids = {103035811146294}, url = "githubusercontent.com", backup = "rbxassetid://9114223147"}, -- 地圖載入
{ids = {81461991645938}, url = "githubusercontent.com", backup = "rbxassetid://81461991645938"},
{ids = {16810041280}, url = "githubusercontent.com", backup = "rbxassetid://2923588961"}, -- 勝利
{ids = {16530229695, 16530229541, 16530229616}, url = "githubusercontent.com", backup = "rbxassetid://5534241639"}, -- 擊殺
{ids = {17138490999}, url = "githubusercontent.com", backup = "rbxassetid://6541282202"}, -- 治療
{ids = {13854780042}, url = "githubusercontent.com", backup = "rbxassetid://13854780042"},
{ids = {13854780213}, url = "githubusercontent.com", backup = "rbxassetid://13854780213"},
{ids = {17803962335}, url = "githubusercontent.com", backup = "rbxassetid://17803962335"},
{ids = {18525513345}, url = "githubusercontent.com", backup = "rbxassetid://9114227181"}, -- 配對
{ids = {13110130082}, url = "githubusercontent.com", backup = "rbxassetid://5534241639"}, -- 命中
{ids = {17153811469}, url = "githubusercontent.com", backup = "rbxassetid://9113636306"}, -- 近戰揮空
{ids = {13188153054, 13188242420, 13220167472, 13220167337}, url = "githubusercontent.com", backup = "rbxassetid://13188153054"},
{ids = {17826470563}, url = "githubusercontent.com", backup = "rbxassetid://3410787012"}, -- 倒數
{ids = {17026600996}, url = "githubusercontent.com", backup = "rbxassetid://9113636306"}, -- 賽點
{ids = {17467242617}, url = "githubusercontent.com", backup = "rbxassetid://3410787012"}, -- 延長賽
{ids = {18221725850, 18239670056, 18221726246}, url = "githubusercontent.com", backup = "rbxassetid://2923588961"}, -- 另一勝利
{ids = {17813065011, 17813065464, 12099785239}, url = "", backup = ""},
{ids = {2108482005, 14147881792, 135908632589654, 84214501374682, 10196550937, 12261809766, 2108545280, 10196550667, 14147882149, 103020541883227, 89972436184102, 12261813110, 14147883091, 2108482395, 10196550128, 14147882405, 2108482542, 10196549902, 14147881297, 72960281658487, 92138082970751, 2108482676, 10196567794, 12261813678, 14147882761, 10196550367, 2108482231}, url = "rbxassetid://7658055825", backup = "rbxassetid://7658055825"},
{ids = {127338559130032, 16294586406, 75156669118637, 93477262732302}, url = "githubusercontent.com", backup = "rbxassetid://127338559130032"},
{ids = {17697682466, 17733314783}, url = "githubusercontent.com", backup = "rbxassetid://9043887031"}, -- 音樂 (Megalovania)
{ids = {133917828562858, 121503061771505}, url = "githubusercontent.com", backup = "rbxassetid://133917828562858"},
{ids = {133793956251748}, url = "githubusercontent.com", backup = "rbxassetid://133793956251748"},
{ids = {116941545385923}, url = "githubusercontent.com", backup = "rbxassetid://116941545385923"},
{ids = {106623367501544, 131795064007344, 73543520622815}, url = "githubusercontent.com", backup = "rbxassetid://106623367501544"},
{ids = {80716950169934}, url = "githubusercontent.com", backup = "rbxassetid://80716950169934"},
{ids = {136100661820261}, url = "githubusercontent.com", backup = "rbxassetid://136100661820261"},
{ids = {107898816876115}, url = "githubusercontent.com", backup = "rbxassetid://107898816876115"},
{ids = {134520747948636}, url = "githubusercontent.com", backup = "rbxassetid://134520747948636"},
{ids = {114166096331502}, url = "githubusercontent.com", backup = "rbxassetid://114166096331502"},
{ids = {90039594400813}, url = "githubusercontent.com", backup = "rbxassetid://90039594400813"},
{ids = {133903971285645}, url = "githubusercontent.com", backup = "rbxassetid://133903971285645"},
{ids = {82834564754747}, url = "githubusercontent.com", backup = "rbxassetid://82834564754747"},
{ids = {73345783863790}, url = "githubusercontent.com", backup = "rbxassetid://73345783863790"},
{ids = {113997689031026}, url = "githubusercontent.com", backup = "rbxassetid://113997689031026"},
{ids = {88059506918419}, url = "githubusercontent.com", backup = "rbxassetid://88059506918419"},
{ids = {112183171942172}, url = "githubusercontent.com", backup = "rbxassetid://112183171942172"},
{ids = {104871954739030}, url = "githubusercontent.com", backup = "rbxassetid://104871954739030"},
{ids = {109012386782238}, url = "githubusercontent.com", backup = "rbxassetid://109012386782238"},
{ids = {127982903682334}, url = "githubusercontent.com", backup = "rbxassetid://127982903682334"},
{ids = {106623367501544}, url = "githubusercontent.com", backup = "rbxassetid://106623367501544"},
{ids = {131795064007344}, url = "githubusercontent.com", backup = "rbxassetid://131795064007344"},
{ids = {17175092502, 17094014569}, url = "githubusercontent.com", backup = "rbxassetid://17175092502"},
{ids = {111599878354131}, url = "githubusercontent.com", backup = "rbxassetid://111599878354131"}
}
local IdMap = {}
for _, rule in ipairs(Rules) do
local asset = rule.url
if string.sub(rule.url, 1, 4) == "http" then
asset = getAsset(rule.url, rule.backup)
end
for _, id in ipairs(rule.ids) do IdMap[tostring(id)] = asset end
end
local function restoreAllOriginalAssets()
for obj, props in pairs(OriginalAssets) do
if obj and obj.Parent then
for propName, origVal in pairs(props) do
pcall(function() obj[propName] = origVal end)
end
end
end
table.clear(OriginalAssets)
if ActivePackDisableFunc then
ActivePackDisableFunc()
ActivePackDisableFunc = nil
end
if ActivePackButton then
ActivePackButton.Text = string.gsub(ActivePackButton.Text, "%[ON%]", "[OFF]")
ActivePackButton.TextColor3 = Color3.fromRGB(210, 210, 215)
ActivePackButton = nil
end
end
local function applyTextureSwap(obj: Instance)
if isUnloaded or not obj then return end
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
if obj:IsA("Sound") then replace("SoundId")
elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then replace("Image")
elseif obj:IsA("Decal") or obj:IsA("Texture") then replace("Texture")
elseif obj:IsA("MeshPart") then replace("TextureID") end
end
-- Undertale Custom Pack Button
local UndertalePackBtn = Instance.new("TextButton")
UndertalePackBtn.Size = UDim2.new(1, 0, 0, 28)
UndertalePackBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
UndertalePackBtn.BorderColor3 = Color3.fromRGB(70, 65, 65)
UndertalePackBtn.BorderSizePixel = 1
UndertalePackBtn.Font = Enum.Font.Code
UndertalePackBtn.Text = "[OFF] Undertale Theme Pack"
UndertalePackBtn.TextColor3 = Color3.fromRGB(210, 210, 215)
UndertalePackBtn.TextSize = 11
UndertalePackBtn.Parent = TexturesTab
local packEnabled = false
local textureConn = nil
TrackConnection(UndertalePackBtn.MouseButton1Click:Connect(function()
packEnabled = not packEnabled
if packEnabled then
UndertalePackBtn.Text = "[ON] Undertale Theme Pack"
UndertalePackBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ActivePackButton = UndertalePackBtn
batchProcess(game:GetDescendants(), applyTextureSwap, 150)
textureConn = game.DescendantAdded:Connect(function(obj)
if packEnabled and not isUnloaded and (obj:IsA("Sound") or obj:IsA("ImageLabel") or obj:IsA("ImageButton") or obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("MeshPart")) then
task.defer(applyTextureSwap, obj)
end
end)
TrackConnection(textureConn)
else
UndertalePackBtn.Text = "[OFF] Undertale Theme Pack"
UndertalePackBtn.TextColor3 = Color3.fromRGB(210, 210, 215)
if textureConn then
textureConn:Disconnect()
textureConn = nil
end
restoreAllOriginalAssets()
end
end))
-- ==========================================
-- MAP DARKENER SYSTEM
-- ==========================================
local darkenerEnabled = false
local darknessLevel = 10
local originalPartColors = setmetatable({}, {__mode = "k"})
local originalLighting = {
Brightness = Lighting.Brightness,
OutdoorAmbient = Lighting.OutdoorAmbient,
Ambient = Lighting.Ambient
}
local function getMultiplier()
return (10 - darknessLevel) * 0.06
end
local function updateLighting()
if darkenerEnabled and not isUnloaded then
local mult = getMultiplier()
Lighting.Brightness = mult
Lighting.OutdoorAmbient = Color3.fromRGB(math.floor(20 * mult), math.floor(20 * mult), math.floor(25 * mult))
Lighting.Ambient = Color3.fromRGB(math.floor(15 * mult), math.floor(15 * mult), math.floor(20 * mult))
end
end
local function darkenInstance(part)
if isUnloaded or not darkenerEnabled or not part or not part:IsA("BasePart") or not part:IsDescendantOf(workspace) then return end
local model = part:FindFirstAncestorOfClass("Model")
if model and Players:GetPlayerFromCharacter(model) then return end
if part.Name == "HumanoidRootPart" or (part.Parent and part.Parent.Name == "Camera") then return end
if not originalPartColors[part] then
originalPartColors[part] = part.Color
end
local h, s, v = Color3.toHSV(originalPartColors[part])
local targetVal = math.clamp(v * getMultiplier(), 0, 1)
part.Color = Color3.fromHSV(h, s, targetVal)
end
local function applyDarknessToAll()
updateLighting()
batchProcess(workspace:GetDescendants(), darkenInstance, 200)
end
local function restoreLightingAndMap()
darkenerEnabled = false
Lighting.Brightness = originalLighting.Brightness
Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
Lighting.Ambient = originalLighting.Ambient
for part, origColor in pairs(originalPartColors) do
if part and part:IsDescendantOf(workspace) then
pcall(function() part.Color = origColor end)
end
end
table.clear(originalPartColors)
end
local DarkenerBtn = Instance.new("TextButton")
DarkenerBtn.Size = UDim2.new(1, 0, 0, 28)
DarkenerBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
DarkenerBtn.BorderColor3 = Color3.fromRGB(65, 65, 70)
DarkenerBtn.BorderSizePixel = 1
DarkenerBtn.Font = Enum.Font.Code
DarkenerBtn.Text = "[OFF] Map Darkener"
DarkenerBtn.TextColor3 = Color3.fromRGB(210, 210, 215)
DarkenerBtn.TextSize = 11
DarkenerBtn.Parent = MapTab
local LevelLabel = Instance.new("TextLabel")
LevelLabel.Size = UDim2.new(1, 0, 0, 18)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Font = Enum.Font.Code
LevelLabel.Text = "Darkness Level: [ 1 (Gray) -> 10 (Black) ]"
LevelLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
LevelLabel.TextSize = 10
LevelLabel.TextXAlignment = Enum.TextXAlignment.Left
LevelLabel.Parent = MapTab
local LevelContainer = Instance.new("Frame")
LevelContainer.Size = UDim2.new(1, 0, 0, 26)
LevelContainer.BackgroundTransparency = 1
LevelContainer.Parent = MapTab
local LevelListLayout = Instance.new("UIListLayout")
LevelListLayout.FillDirection = Enum.FillDirection.Horizontal
LevelListLayout.SortOrder = Enum.SortOrder.LayoutOrder
LevelListLayout.Padding = UDim.new(0, 2)
LevelListLayout.Parent = LevelContainer
local LevelButtons = {}
for i = 1, 10 do
local LvlBtn = Instance.new("TextButton")
LvlBtn.Size = UDim2.new(0, 38, 1, 0)
LvlBtn.BackgroundColor3 = (i == darknessLevel) and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(24, 24, 28)
LvlBtn.BorderColor3 = (i == darknessLevel) and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(60, 60, 65)
LvlBtn.BorderSizePixel = 1
LvlBtn.Font = Enum.Font.Code
LvlBtn.Text = tostring(i)
LvlBtn.TextColor3 = (i == darknessLevel) and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(180, 180, 185)
LvlBtn.TextSize = 10
LvlBtn.Parent = LevelContainer
table.insert(LevelButtons, LvlBtn)
TrackConnection(LvlBtn.MouseButton1Click:Connect(function()
darknessLevel = i
for idx, btn in ipairs(LevelButtons) do
btn.BackgroundColor3 = (idx == darknessLevel) and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(24, 24, 28)
btn.BorderColor3 = (idx == darknessLevel) and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(60, 60, 65)
btn.TextColor3 = (idx == darknessLevel) and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(180, 180, 185)
end
if darkenerEnabled then
applyDarknessToAll()
end
end))
end
local darkenerConn = nil
TrackConnection(DarkenerBtn.MouseButton1Click:Connect(function()
darkenerEnabled = not darkenerEnabled
DarkenerBtn.Text = darkenerEnabled and "[ON] Map Darkener" or "[OFF] Map Darkener"
DarkenerBtn.TextColor3 = darkenerEnabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(210, 210, 215)
if darkenerEnabled then
applyDarknessToAll()
darkenerConn = workspace.DescendantAdded:Connect(function(obj)
if darkenerEnabled and not isUnloaded and obj:IsA("BasePart") then
task.defer(darkenInstance, obj)
end
end)
TrackConnection(darkenerConn)
else
if darkenerConn then
darkenerConn:Disconnect()
darkenerConn = nil
end
restoreLightingAndMap()
end
end))
-- ==========================================
-- ULTIMATE CRASH/UNLOAD SYSTEM
-- ==========================================
local UnloadBtn = Instance.new("TextButton")
UnloadBtn.Size = UDim2.new(1, 0, 0, 32)
UnloadBtn.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
UnloadBtn.BorderColor3 = Color3.fromRGB(120, 50, 50)
UnloadBtn.BorderSizePixel = 1
UnloadBtn.Font = Enum.Font.Code
UnloadBtn.Text = "❌ UNLOAD SCRIPT"
UnloadBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
UnloadBtn.TextSize = 12
UnloadBtn.Parent = SettingsTab
local function Unload()
if isUnloaded then return end
isUnloaded = true
for _, conn in ipairs(Connections) do
if conn and conn.Connected then
pcall(function() conn:Disconnect() end)
end
end
table.clear(Connections)
restoreAllOriginalAssets()
restoreLightingAndMap()
if ScreenGui then
pcall(function() ScreenGui:Destroy() end)
end
table.clear(OriginalAssets)
table.clear(originalPartColors)
table.clear(IdMap)
table.clear(Rules)
table.clear(Tabs)
table.clear(LevelButtons)
pcall(function()
collectgarbage("collect")
end)
end
TrackConnection(UnloadBtn.MouseButton1Click:Connect(Unload))
