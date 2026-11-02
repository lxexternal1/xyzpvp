local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Storage = game:GetService("ReplicatedStorage")
local Input = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local World = game:GetService("Workspace")
local Player = Players.LocalPlayer
assert(Input.KeyboardEnabled and Input.MouseEnabled, "This interface requires a keyboard and mouse")
local Environment = getgenv()
local Previous = Environment.LxExternal
if Previous then
    Previous:Destroy()
end
local Rojo = Storage:FindFirstChild("Rojo")
local Remotes = Rojo and Rojo:FindFirstChild("Remotes")
local Fire = Remotes and Remotes:FindFirstChild("Fire")
assert(Player and Fire and Fire:IsA("RemoteEvent"), "Lx External: game client is unavailable")
assert(getrawmetatable and setreadonly and getnamecallmethod, "Required hook APIs are unavailable")

local Config = {
    SilentAim = {
        Enabled = true,
        Radius = 180,
        MaxDistance = 450,
        Part = "Head",
        FOV = 90,
        SelectionMode = "Angle",
        Priority = "Distance",
        VisibilityCheck = true,
        TeamCheck = false,
        SafeZoneCheck = true,
        ReadyCheck = true,
        ForceFieldCheck = true,
        HoldToAim = false,
        HitChance = 100,
        ShowRadius = true,
        RadiusColor = Color3.fromRGB(157, 176, 255),
        Origin = "Center",
        MissChance = 0,
        HeadChance = 100,
        MinDistance = 1,
        StickyTarget = false,
        StickyBias = 0.25,
        SwitchDelay = 0,
        IgnoreDowned = true,
        IgnoreFriends = false,
        IgnoreUnarmed = false,
        Activation = "Always",
        ActivationButton = "Right",
        ToggleKey = "Home",
        RadiusThickness = 1,
        RadiusTransparency = 0.35,
        RadiusFilled = false,
        FovRenderer = "Auto",
        ShowTarget = true,
        TargetLine = false,
        VisibilityMode = "Weapon",
        RespectWeaponRange = true,
        TargetColor = Color3.fromRGB(255, 209, 133),
    },
    Esp = {
        Enabled = true,
        MaxDistance = 600,
        TeamCheck = false,
        ShowSafeZone = true,
        Boxes = true,
        Names = true,
        DisplayNames = true,
        Health = true,
        HealthNumbers = false,
        Distance = true,
        Weapon = true,
        Armor = true,
        Status = true,
        Tracers = false,
        Skeleton = true,
        Highlights = true,
        ThroughWalls = true,
        TracerOrigin = "Bottom",
        FontSize = 12,
        FillTransparency = 0.85,
        OutlineTransparency = 0.15,
        Thickness = 1,
        ColorMode = "Player",
        BoxStyle = "Corners",
        CornerLength = 0.24,
        BoxFill = true,
        BoxFillTransparency = 0.96,
        BoxOutline = true,
        LabelBackground = true,
        LabelTransparency = 0.25,
        LabelPadding = 5,
        NameOffset = 7,
        DetailOffset = 7,
        Declutter = true,
        LabelSpacing = 3,
        MaxLabels = 28,
        DetailDistance = 250,
        NameDistance = 600,
        SkeletonDistance = 200,
        MinBoxHeight = 10,
        HealthWidth = 3,
        HealthGap = 5,
        DistanceFade = true,
        FadeStart = 300,
        FadeMinimum = 0.4,
        NameColor = Color3.fromRGB(245, 247, 255),
        DistanceColor = Color3.fromRGB(169, 184, 208),
        WeaponColor = Color3.fromRGB(195, 175, 255),
        ArmorColor = Color3.fromRGB(119, 183, 255),
        StatusColor = Color3.fromRGB(111, 220, 178),
        BackgroundColor = Color3.fromRGB(14, 18, 29),
        ShadowColor = Color3.fromRGB(5, 7, 13),
        HealthLowColor = Color3.fromRGB(255, 102, 128),
        HealthHighColor = Color3.fromRGB(103, 229, 171),
        HighlightColorMode = "Accent",
        HighlightFillColor = Color3.fromRGB(138, 151, 255),
        HighlightOutlineColor = Color3.fromRGB(200, 209, 255),
        EnemyColor = Color3.fromRGB(255, 115, 135),
        TeamColor = Color3.fromRGB(115, 185, 255),
        SafeColor = Color3.fromRGB(110, 220, 170),
        TextColor = Color3.fromRGB(235, 239, 250),
        BoundsMode = "Fast",
        HealthSmoothness = 0,
        MetadataRate = 6,
        HighlightLimit = 8,
        MaxPlayers = 18,
        SkeletonLimit = 6,
        SortRate = 8,
        OffscreenArrows = true,
        ArrowRadius = 0.4,
        ArrowSize = 11,
        ArrowLimit = 8,
        TargetAccent = true,
        TargetOnlySkeleton = false,
        TargetColor = Color3.fromRGB(255, 209, 133),
        ArmorBar = true,
        ArmorMaximum = 100,
        DownedStatus = true,
        ShowDowned = true,
        DistanceUnit = "Studs",
        ShowUsernames = false,
        OccludedColor = Color3.fromRGB(145, 153, 177),
        VisibilityColors = false,
        VisibilityRate = 5,
    },
    Visuals = {
        Crosshair = false,
        CrosshairSize = 5,
        CrosshairGap = 4,
        CrosshairThickness = 1,
        CrosshairDot = true,
        CrosshairColor = Color3.fromRGB(235, 239, 250),
    },
}
local Bounds = {
    FOV = { 1, 360 },
    MissChance = { 0, 100 },
    HeadChance = { 0, 100 },
    MinDistance = { 0, 10000 },
    StickyBias = { 0, 0.9 },
    SwitchDelay = { 0, 2 },
    RadiusThickness = { 1, 5 },
    RadiusTransparency = { 0, 1 },
    HealthSmoothness = { 0, 60 },
    MetadataRate = { 1, 30 },
    HighlightLimit = { 0, 31 },
    MaxPlayers = { 1, 64 },
    SkeletonLimit = { 0, 32 },
    SortRate = { 1, 30 },
    ArrowRadius = { 0.1, 0.48 },
    ArrowSize = { 5, 30 },
    ArrowLimit = { 0, 50 },
    ArmorMaximum = { 1, 1000 },
    VisibilityRate = { 1, 15 },
    CrosshairSize = { 1, 20 },
    CrosshairGap = { 0, 30 },
    CrosshairThickness = { 1, 5 },
    Radius = { 1, 2000 },
    MaxDistance = { 1, 10000 },
    HitChance = { 0, 100 },
    FontSize = { 9, 32 },
    Thickness = { 1, 4 },
    FillTransparency = { 0, 1 },
    OutlineTransparency = { 0, 1 },
    CornerLength = { 0.05, 0.5 },
    BoxFillTransparency = { 0, 1 },
    LabelTransparency = { 0, 1 },
    LabelPadding = { 0, 20 },
    NameOffset = { 0, 40 },
    DetailOffset = { 0, 40 },
    LabelSpacing = { 0, 20 },
    MaxLabels = { 1, 200 },
    DetailDistance = { 1, 10000 },
    NameDistance = { 1, 10000 },
    SkeletonDistance = { 1, 10000 },
    MinBoxHeight = { 2, 100 },
    HealthWidth = { 1, 10 },
    HealthGap = { 1, 20 },
    FadeStart = { 0, 10000 },
    FadeMinimum = { 0, 1 },
}
local Choices = {
    SelectionMode = { Angle = true, Screen = true },
    Part = { Head = true, UpperTorso = true, HumanoidRootPart = true, Weighted = true },
    Activation = { Always = true, Hold = true, Toggle = true },
    ActivationButton = { Left = true, Right = true, Middle = true },
    ToggleKey = { Home = true, Insert = true, F6 = true, F7 = true, F8 = true },
    FovRenderer = { Auto = true, Drawing = true, Gui = true },
    VisibilityMode = { World = true, Weapon = true },
    BoundsMode = { Fast = true, Accurate = true },
    DistanceUnit = { Studs = true, Meters = true },
    Priority = { Crosshair = true, Distance = true, Health = true },
    TracerOrigin = { Bottom = true, Center = true, Mouse = true },
    Origin = { Center = true, Mouse = true },
    ColorMode = { Player = true, Team = true, Health = true, Distance = true, Static = true },
    BoxStyle = { Corners = true, Full = true },
    HighlightColorMode = { Accent = true, Custom = true },
}
local Lx = {}
local Metatable = getrawmetatable(game)
local NamecallHook
local PreviousNamecall
local Active = true
local Records, Connections = {}, {}
local LabelRectangles = {}
local Camera = World.CurrentCamera
local RandomFloat = math.random
local Parameters = RaycastParams.new()
local GameConfig = require(Rojo:FindFirstChild("Config"))
local GameBulletCast = require(Rojo:FindFirstChild("BulletCast"))
local TargetCache = { Valid = false }
local IgnoredPlayers = {}
local CurrentTarget, SelectedAt = nil, 0
local ToggleActive = true
local FrameTime, FrameDelta = 0, 0
local SortedRecords = {}
local HighlightCount = 0
local ArrowCount = 0
local RadiusDrawing
local DrawingAvailable = false
local ConfigVersion = 0
local FrameId = 0
local LabelCount = 0
local DetailedCount = 0
local SkeletonCount = 0
local NextSort = 0
local EspWasEnabled = true
local Library
local InterfaceUnloading = false
local RefreshInterface
local UIUpdating = false
local MenuMouseState
local function RestoreMenuMouse()
    if not MenuMouseState then
        return
    end
    Input.MouseBehavior = MenuMouseState.Behavior
    Input.MouseIconEnabled = MenuMouseState.Icon
    MenuMouseState = nil
end
Parameters.FilterType = Enum.RaycastFilterType.Exclude
Parameters.IgnoreWater = true

local function Connect(signal, callback, list)
    local connection = signal:Connect(callback)
    table.insert(list or Connections, connection)
end
local function Disconnect(list)
    for _, connection in list do
        connection:Disconnect()
    end
    table.clear(list)
end
local function Create(class, properties, parent)
    local instance = Instance.new(class)
    for key, value in properties do
        instance[key] = value
    end
    instance.Parent = parent
    return instance
end
local PlayerGui = Player:FindFirstChildOfClass("PlayerGui") or Player:WaitForChild("PlayerGui", 10)
assert(PlayerGui, "PlayerGui is unavailable")
local Gui = Create("ScreenGui", {
    Name = "LxOverlay",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    DisplayOrder = 90,
}, PlayerGui)
local Radius = Create("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5) }, Gui)
Create("UICorner", { CornerRadius = UDim.new(1, 0) }, Radius)
local Ring = Create("UIStroke", { Thickness = 1, Transparency = 0.4 }, Radius)
if Drawing and type(Drawing.new) == "function" then
    local ok, circle = pcall(Drawing.new, "Circle")
    if ok then
        RadiusDrawing = circle
        DrawingAvailable = true
        circle.NumSides = 96
        circle.Visible = false
    end
end
local Bones = {
    { "Head", "UpperTorso" },
    { "UpperTorso", "LowerTorso" },
    { "UpperTorso", "LeftUpperArm" },
    { "LeftUpperArm", "LeftLowerArm" },
    { "LeftLowerArm", "LeftHand" },
    { "UpperTorso", "RightUpperArm" },
    { "RightUpperArm", "RightLowerArm" },
    { "RightLowerArm", "RightHand" },
    { "LowerTorso", "LeftUpperLeg" },
    { "LeftUpperLeg", "LeftLowerLeg" },
    { "LeftLowerLeg", "LeftFoot" },
    { "LowerTorso", "RightUpperLeg" },
    { "RightUpperLeg", "RightLowerLeg" },
    { "RightLowerLeg", "RightFoot" },
}
local LineStates = setmetatable({}, { __mode = "k" })
local function NewLine(parent)
    return Create(
        "Frame",
        { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Visible = false },
        parent
    )
end
local function Line(object, a, b, color)
    local state = LineStates[object]
    if not state then
        state = {}
        LineStates[object] = state
    end
    if state.From ~= a or state.To ~= b or state.Thickness ~= Config.Esp.Thickness then
        local delta = b - a
        object.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
        object.Size = UDim2.fromOffset(delta.Magnitude, Config.Esp.Thickness)
        object.Rotation = math.deg(math.atan2(delta.Y, delta.X))
        state.From, state.To, state.Thickness = a, b, Config.Esp.Thickness
    end
    if state.Color ~= color then
        object.BackgroundColor3 = color
        state.Color = color
    end
    if not object.Visible then
        object.Visible = true
    end
end
local function NewText(parent, anchor)
    return Create("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = anchor,
        Size = UDim2.fromOffset(0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        RichText = true,
        Font = Enum.Font.GothamMedium,
        TextStrokeTransparency = 0.75,
        TextStrokeColor3 = Color3.fromRGB(10, 12, 20),
    }, parent)
end
local function Allocate(record)
    local layer = Create("Frame", { BackgroundTransparency = 1, Visible = false }, Gui)
    local box = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, layer)
    local border = Create("UIStroke", { Thickness = 1 }, box)
    local edges, shadows = {}, {}
    for index = 1, 8 do
        shadows[index] = NewLine(layer)
        edges[index] = NewLine(layer)
        shadows[index].ZIndex = 1
        edges[index].ZIndex = 2
    end
    local top = NewText(layer, Vector2.new(0.5, 1))
    top.ZIndex = 4
    top.TextYAlignment = Enum.TextYAlignment.Bottom
    local bottom = NewText(layer, Vector2.new(0.5, 0))
    bottom.ZIndex = 4
    bottom.TextYAlignment = Enum.TextYAlignment.Top
    local health =
        Create("Frame", { BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(10, 12, 20) }, layer)
    local fill = Create(
        "Frame",
        { BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1) },
        health
    )
    local armor = Create("Frame", { BorderSizePixel = 0, BackgroundColor3 = Config.Esp.ShadowColor }, layer)
    local armorFill = Create("Frame", { BorderSizePixel = 0 }, armor)
    for _, label in { top, bottom } do
        Create("UICorner", { CornerRadius = UDim.new(0, 4) }, label)
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 2),
        }, label)
    end
    record.Overlay = {
        Layer = layer,
        Box = box,
        Border = border,
        Edges = edges,
        Shadows = shadows,
        Top = top,
        Bottom = bottom,
        Health = health,
        Fill = fill,
        Armor = armor,
        ArmorFill = armorFill,
        Tracer = NewLine(Gui),
        BoneLayer = nil,
        TopPadding = top:FindFirstChildOfClass("UIPadding"),
        BottomPadding = bottom:FindFirstChildOfClass("UIPadding"),
        Bones = {},
    }
    return record.Overlay
end
local function Bind(record, character)
    Disconnect(record.CharacterConnections)
    if record.Highlight then
        record.Highlight:Destroy()
        record.Highlight = nil
    end
    if record.Overlay then
        record.Overlay.Layer.Visible = false
        record.Overlay.Tracer.Visible = false
        if record.Overlay.BoneLayer then
            record.Overlay.BoneLayer.Visible = false
        end
    end
    record.Character, record.Humanoid = character, nil
    record.SmoothedHealth = nil
    table.clear(record.Parts)
    if not character then
        return
    end
    local function Add(child)
        if child:IsA("BasePart") then
            record.Parts[child.Name] = child
        end
        if child:IsA("Humanoid") then
            record.Humanoid = child
        end
    end
    for _, child in character:GetChildren() do
        Add(child)
    end
    Connect(character.ChildAdded, Add, record.CharacterConnections)
    Connect(character.ChildRemoved, function(child)
        if record.Parts[child.Name] == child then
            record.Parts[child.Name] = nil
        end
        if record.Humanoid == child then
            record.Humanoid = nil
        end
    end, record.CharacterConnections)
end
local function AddPlayer(player)
    if player == Player or Records[player] then
        return
    end
    local record = {
        Player = player,
        Parts = {},
        Connections = {},
        CharacterConnections = {},
        NextMetadata = 0,
        NextVisibility = 0,
        Visible = true,
        Projections = {},
        PlayerColor = Color3.fromHSV((player.UserId * 0.61803398875) % 1, 0.48, 1),
    }
    Records[player] = record
    NextSort = 0
    Connect(player.CharacterAdded, function(character)
        Bind(record, character)
    end, record.Connections)
    Connect(player.CharacterRemoving, function()
        Bind(record, nil)
    end, record.Connections)
    Bind(record, player.Character)
    task.spawn(function()
        local ok, friend = pcall(Player.IsFriendsWith, Player, player.UserId)
        if Records[player] == record then
            record.Friend = ok and friend or false
        end
    end)
end
local function RemovePlayer(player)
    local record = Records[player]
    if not record then
        return
    end
    Disconnect(record.Connections)
    Bind(record, nil)
    if record.Overlay then
        record.Overlay.Layer:Destroy()
        record.Overlay.Tracer:Destroy()
        if record.Overlay.BoneLayer then
            record.Overlay.BoneLayer:Destroy()
        end
    end
    if record.Arrow then
        record.Arrow:Destroy()
    end
    if CurrentTarget == record then
        CurrentTarget = nil
    end
    Records[player] = nil
    NextSort = 0
end
local function Teammate(player)
    return Player.Team ~= nil and not Player.Neutral and not player.Neutral and player.Team == Player.Team
end
local function Safe(record)
    return record.Player:GetAttribute("InGreenZone") == true
        or record.Character:GetAttribute("GZNoCollide") == true
end
local function Living(record)
    return record.Character
        and record.Character.Parent
        and record.Humanoid
        and (record.Humanoid.Health > 0 or Config.Esp.ShowDowned and record.Player:GetAttribute("BWDown") == true)
        and record.Parts.HumanoidRootPart
end
local function SelectionCenter()
    if Config.SilentAim.Origin == "Mouse" then
        return Input:GetMouseLocation()
    end
    return Camera.ViewportSize / 2
end
local function VisibilityHit(origin, delta)
    if Config.SilentAim.VisibilityMode == "Weapon" then
        return GameBulletCast.Raycast(World, origin, delta, Parameters)
    end
    return World:Raycast(origin, delta, Parameters)
end
local function Select(origin)
    local aim = Config.SilentAim
    if not Camera or not aim.Enabled then
        return
    end
    if aim.HoldToAim and not Input:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        return
    end
    if aim.Activation == "Toggle" and not ToggleActive then
        return
    end
    if aim.Activation == "Hold" then
        local button = aim.ActivationButton == "Left" and Enum.UserInputType.MouseButton1
            or aim.ActivationButton == "Middle" and Enum.UserInputType.MouseButton3
            or Enum.UserInputType.MouseButton2
        if not Input:IsMouseButtonPressed(button) then
            return
        end
    end
    local character = Player.Character
    if not character or not character:FindFirstChild("Head") then
        return
    end
    Parameters.FilterDescendantsInstances = { character, Camera }
    local center = SelectionCenter()
    local look = Camera.CFrame.LookVector
    local threshold = math.cos(math.rad(aim.FOV * 0.5))
    local maximumDistance = aim.MaxDistance
    if aim.RespectWeaponRange then
        local weapon = GameConfig.Weapons and GameConfig.Weapons[character:GetAttribute("Equipped")]
        local range = weapon and weapon.MaxRange or GameConfig.Weapon and GameConfig.Weapon.MaxRange
        if type(range) == "number" then
            maximumDistance = math.min(maximumDistance, range)
        end
    end
    local best, bestRecord, score
    local previousPart
    local now = os.clock()
    for _, record in Records do
        if not record.Character or not record.Humanoid or record.Humanoid.Health <= 0 then
            continue
        end
        if IgnoredPlayers[record.Player.UserId] then
            continue
        end
        if aim.IgnoreDowned and record.Player:GetAttribute("BWDown") == true then
            continue
        end
        if aim.IgnoreFriends and record.Friend then
            continue
        end
        if aim.IgnoreUnarmed and not record.Character:GetAttribute("Equipped") then
            continue
        end
        if aim.TeamCheck and Teammate(record.Player) then
            continue
        end
        if aim.SafeZoneCheck and Safe(record) then
            continue
        end
        if aim.ReadyCheck and record.Character:GetAttribute("PvPReady") ~= true then
            continue
        end
        if aim.ForceFieldCheck and record.Character:FindFirstChildOfClass("ForceField") then
            continue
        end
        local part = record.Parts[aim.Part == "Weighted" and "UpperTorso" or aim.Part]
        if not part or not part.Parent then
            continue
        end
        local distance = (part.Position - origin).Magnitude
        if distance <= math.max(0.01, aim.MinDistance) or distance > maximumDistance then
            continue
        end
        local direction = (part.Position - origin) / distance
        local alignment = direction:Dot(look)
        local offset = 1 - alignment
        if aim.SelectionMode == "Angle" then
            if alignment < threshold then
                continue
            end
        else
            local point, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen or point.Z <= 0 then
                continue
            end
            offset = (Vector2.new(point.X, point.Y) - center).Magnitude
            if offset > aim.Radius then
                continue
            end
        end
        local value = aim.Priority == "Distance" and distance
            or aim.Priority == "Health" and record.Humanoid.Health
            or offset
        if aim.StickyTarget and record == CurrentTarget then
            value *= 1 - aim.StickyBias
        end
        if score and value >= score and record ~= CurrentTarget then
            continue
        end
        if aim.VisibilityCheck then
            local hit = VisibilityHit(origin, part.Position - origin)
            if hit and not hit.Instance:IsDescendantOf(record.Character) then
                continue
            end
        end
        if record == CurrentTarget then
            previousPart = part
        end
        if not score or value < score then
            best, bestRecord, score = part, record, value
        end
    end
    if previousPart and now - SelectedAt < aim.SwitchDelay then
        return previousPart, CurrentTarget
    end
    if bestRecord ~= CurrentTarget then
        SelectedAt = now
    end
    CurrentTarget = bestRecord
    return best
end
local function UpdateSilentAim()
    TargetCache.Valid = false
    if not Camera or not Config.SilentAim.Enabled then
        CurrentTarget = nil
        return
    end
    local character = Player.Character
    local head = character and character:FindFirstChild("Head")
    if not head or not head:IsA("BasePart") then
        return
    end
    local cameraPosition = Camera.CFrame.Position
    local part = Select(cameraPosition)
    if not part then
        CurrentTarget = nil
        return
    end
    local origin = cameraPosition
    if (cameraPosition - head.Position).Magnitude > 9.5 then
        origin = head.Position
    end
    local delta = part.Position - origin
    if delta.Magnitude < 1 then
        return
    end
    TargetCache.Origin = origin
    TargetCache.Direction = delta.Unit
    TargetCache.Part = part
    TargetCache.Point = part.Position
    TargetCache.HeadPart = nil
    if Config.SilentAim.Part == "Weighted" then
        local targetHead = CurrentTarget and CurrentTarget.Parts.Head
        if targetHead and targetHead.Parent and Config.SilentAim.HeadChance > 0 then
            local headDelta = targetHead.Position - origin
            local allowed = true
            if Config.SilentAim.VisibilityCheck then
                local hit = VisibilityHit(origin, headDelta)
                allowed = not hit or hit.Instance:IsDescendantOf(CurrentTarget.Character)
            end
            if
                allowed
                and headDelta.Magnitude >= 1
                and headDelta.Magnitude <= Config.SilentAim.MaxDistance
            then
                TargetCache.HeadPart, TargetCache.HeadPoint, TargetCache.HeadDirection =
                    targetHead, targetHead.Position, headDelta.Unit
            end
        end
    end
    TargetCache.Valid = true
end
local function Escape(text)
    return (tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end
local function Colored(text, color)
    return string.format('<font color="#%s">%s</font>', color:ToHex(), Escape(text))
end
local function Accent(record, distance, fraction, teammate)
    local esp = Config.Esp
    if esp.TargetAccent and record == CurrentTarget and TargetCache.Valid then
        return esp.TargetColor
    end
    if esp.VisibilityColors and not record.Visible then
        return esp.OccludedColor
    end
    if esp.ColorMode == "Player" then
        return record.PlayerColor
    end
    if esp.ColorMode == "Health" then
        return esp.HealthLowColor:Lerp(esp.HealthHighColor, fraction)
    end
    if esp.ColorMode == "Distance" then
        return esp.TeamColor:Lerp(esp.EnemyColor, math.clamp(distance / esp.MaxDistance, 0, 1))
    end
    if esp.ColorMode == "Team" and teammate then
        return esp.TeamColor
    end
    return esp.EnemyColor
end
local function BodyBounds(record)
    if Config.Esp.BoundsMode == "Fast" then
        local head, root = record.Parts.Head, record.Parts.HumanoidRootPart
        if not head or not root then
            return
        end
        local foot = record.Parts.LeftFoot or record.Parts.RightFoot
        local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y * 0.5 + 0.15, 0))
        local bottom = Camera:WorldToViewportPoint(
            Vector3.new(
                root.Position.X,
                foot and foot.Position.Y - foot.Size.Y * 0.5 or root.Position.Y - 3,
                root.Position.Z
            )
        )
        if top.Z <= 0.1 or bottom.Z <= 0.1 then
            return
        end
        local height, x = bottom.Y - top.Y, (top.X + bottom.X) * 0.5
        return x - height * 0.3, top.Y, x + height * 0.3, bottom.Y
    end
    local left, top, right, bottom = math.huge, math.huge, -math.huge, -math.huge
    local cameraFrame = Camera.CFrame
    local rightVector, upVector = cameraFrame.RightVector, cameraFrame.UpVector
    for _, part in record.Parts do
        if part.Name == "HumanoidRootPart" or part.Transparency >= 1 then
            continue
        end
        local frame, size = part.CFrame, part.Size * 0.5
        local horizontal = math.abs(rightVector:Dot(frame.RightVector)) * size.X
            + math.abs(rightVector:Dot(frame.UpVector)) * size.Y
            + math.abs(rightVector:Dot(frame.LookVector)) * size.Z
        local vertical = math.abs(upVector:Dot(frame.RightVector)) * size.X
            + math.abs(upVector:Dot(frame.UpVector)) * size.Y
            + math.abs(upVector:Dot(frame.LookVector)) * size.Z
        local a = Camera:WorldToViewportPoint(part.Position - rightVector * horizontal + upVector * vertical)
        local b = Camera:WorldToViewportPoint(part.Position + rightVector * horizontal - upVector * vertical)
        if a.Z <= 0.1 or b.Z <= 0.1 then
            return
        end
        left, top, right, bottom =
            math.min(left, a.X), math.min(top, a.Y), math.max(right, b.X), math.max(bottom, b.Y)
    end
    if left == math.huge then
        return
    end
    return left, top, right, bottom
end
local function ReserveLabel(label, x, y, above)
    if not Config.Esp.Declutter then
        return true
    end
    local size = label.AbsoluteSize
    local gap = Config.Esp.LabelSpacing
    local left, right = x - size.X / 2 - gap, x + size.X / 2 + gap
    local top, bottom = above and y - size.Y - gap or y - gap, above and y + gap or y + size.Y + gap
    if LabelCount >= Config.Esp.MaxLabels then
        return false
    end
    for index = 1, LabelCount do
        local rect = LabelRectangles[index]
        if left < rect[3] and right > rect[1] and top < rect[4] and bottom > rect[2] then
            return false
        end
    end
    LabelCount += 1
    local rect = LabelRectangles[LabelCount]
    if rect then
        rect[1], rect[2], rect[3], rect[4] = left, top, right, bottom
    else
        LabelRectangles[LabelCount] = { left, top, right, bottom }
    end
    return true
end
local TargetMarker = Create("Frame", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.fromOffset(14, 14),
    Visible = false,
}, Gui)
Create("UICorner", { CornerRadius = UDim.new(1, 0) }, TargetMarker)
local MarkerStroke = Create("UIStroke", { Thickness = 1.5 }, TargetMarker)
local TargetLine = NewLine(Gui)
local Crosshair =
    Create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false }, Gui)
local CrosshairLines = {}
for index = 1, 4 do
    CrosshairLines[index] = NewLine(Crosshair)
end
local CrosshairDot = Create(
    "Frame",
    { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(2, 2) },
    Crosshair
)
local function UpdateVisuals()
    local visuals, aim = Config.Visuals, Config.SilentAim
    local center = Camera.ViewportSize * 0.5
    Crosshair.Visible = visuals.Crosshair
    if visuals.Crosshair then
        local gap, size = visuals.CrosshairGap, visuals.CrosshairSize
        for index = 1, 4 do
            local axis = index <= 2 and Vector2.new(1, 0) or Vector2.new(0, 1)
            local sign = index % 2 == 0 and -1 or 1
            Line(
                CrosshairLines[index],
                center + axis * gap * sign,
                center + axis * (gap + size) * sign,
                visuals.CrosshairColor
            )
            CrosshairLines[index].Size = UDim2.fromOffset(size, visuals.CrosshairThickness)
        end
        CrosshairDot.Visible = visuals.CrosshairDot
        CrosshairDot.Position, CrosshairDot.BackgroundColor3 =
            UDim2.fromOffset(center.X, center.Y), visuals.CrosshairColor
    end
    TargetMarker.Visible, TargetLine.Visible = false, false
    if TargetCache.Valid then
        local point, onScreen = Camera:WorldToViewportPoint(TargetCache.Point)
        if onScreen then
            TargetMarker.Visible = aim.ShowTarget
            TargetMarker.Position = UDim2.fromOffset(point.X, point.Y)
            MarkerStroke.Color = aim.TargetColor
            if aim.TargetLine then
                Line(TargetLine, SelectionCenter(), Vector2.new(point.X, point.Y), aim.TargetColor)
            end
        end
    end
    local fovCenter = aim.SelectionMode == "Angle" and center or SelectionCenter()
    local radius = aim.Radius
    if aim.SelectionMode == "Angle" then
        local angle = math.rad(math.min(aim.FOV, 179) * 0.5)
        radius = math.tan(angle) / math.tan(math.rad(Camera.FieldOfView * 0.5)) * Camera.ViewportSize.Y * 0.5
    end
    radius = math.min(radius, Camera.ViewportSize.Magnitude)
    local visible = aim.Enabled and aim.ShowRadius
    local useDrawing = DrawingAvailable and aim.FovRenderer ~= "Gui"
    Radius.Visible = visible and not useDrawing
    Radius.Position, Radius.Size =
        UDim2.fromOffset(fovCenter.X, fovCenter.Y), UDim2.fromOffset(radius * 2, radius * 2)
    Ring.Color, Ring.Thickness, Ring.Transparency =
        aim.RadiusColor, aim.RadiusThickness, aim.RadiusTransparency
    Radius.BackgroundColor3 = aim.RadiusColor
    Radius.BackgroundTransparency = aim.RadiusFilled and 0.97 or 1
    if RadiusDrawing then
        RadiusDrawing.Visible = visible and useDrawing
        RadiusDrawing.Position, RadiusDrawing.Radius = fovCenter, radius
        RadiusDrawing.Color, RadiusDrawing.Thickness = aim.RadiusColor, aim.RadiusThickness
        RadiusDrawing.Transparency, RadiusDrawing.Filled = 1 - aim.RadiusTransparency, aim.RadiusFilled
    end
end
local function UpdateArrow(record, screen, color)
    if not Config.Esp.OffscreenArrows or ArrowCount >= Config.Esp.ArrowLimit then
        return
    end
    ArrowCount += 1
    if not record.Arrow then
        record.Arrow = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = "▲",
            Font = Enum.Font.GothamBold,
            TextStrokeTransparency = 0.25,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(32, 32),
            ZIndex = 3,
        }, Gui)
    end
    local viewport = Camera.ViewportSize
    local direction = Vector2.new(screen.X - viewport.X * 0.5, screen.Y - viewport.Y * 0.5)
    if screen.Z < 0 then
        direction = -direction
    end
    direction = direction.Magnitude > 0.01 and direction.Unit or Vector2.new(0, 1)
    local position = viewport * 0.5
        + Vector2.new(direction.X * viewport.X, direction.Y * viewport.Y) * Config.Esp.ArrowRadius
    record.Arrow.Position = UDim2.fromOffset(position.X, position.Y)
    record.Arrow.Rotation = math.deg(math.atan2(direction.Y, direction.X)) + 90
    record.Arrow.TextSize, record.Arrow.TextColor3 = Config.Esp.ArrowSize * 2, color
    record.Arrow.Visible = true
end
local function HideOverlay(record)
    local overlay = record.Overlay
    if overlay then
        overlay.Layer.Visible = false
        overlay.Tracer.Visible = false
        if overlay.BoneLayer then
            overlay.BoneLayer.Visible = false
        end
    end
end
local function HideRecord(record)
    HideOverlay(record)
    if record.Arrow then
        record.Arrow.Visible = false
    end
    if record.Highlight then
        record.Highlight.Enabled = false
    end
end
local function StyleOverlay(overlay)
    local esp = Config.Esp
    local thickness, corner = esp.Thickness, esp.CornerLength
    overlay.Box.Visible = esp.Boxes
    overlay.Border.Enabled = esp.Boxes and esp.BoxStyle == "Full"
    overlay.Border.Thickness = thickness
    for index = 1, 8 do
        local right = index == 3 or index == 4 or index == 7 or index == 8
        local lower = index >= 5
        local horizontal = index % 2 == 1
        local position = UDim2.fromScale(right and 1 or 0, lower and 1 or 0)
        local anchor = horizontal and Vector2.new(right and 1 or 0, 0.5) or Vector2.new(0.5, lower and 1 or 0)
        local edge, shadow = overlay.Edges[index], overlay.Shadows[index]
        edge.AnchorPoint, shadow.AnchorPoint = anchor, anchor
        edge.Position, shadow.Position = position, position
        edge.Size = horizontal and UDim2.new(corner, 0, 0, thickness) or UDim2.new(0, thickness, corner, 0)
        shadow.Size = horizontal and UDim2.new(corner, 2, 0, thickness + 2)
            or UDim2.new(0, thickness + 2, corner, 2)
        edge.Rotation, shadow.Rotation = 0, 0
        edge.Visible = esp.Boxes and esp.BoxStyle == "Corners"
        shadow.Visible = edge.Visible and esp.BoxOutline
        shadow.BackgroundColor3 = esp.ShadowColor
    end
    overlay.Health.Visible = esp.Health
    overlay.Health.Position = UDim2.fromOffset(-esp.HealthGap - esp.HealthWidth, 0)
    overlay.Health.Size = UDim2.new(0, esp.HealthWidth, 1, 0)
    overlay.Top.Position = UDim2.new(0.5, 0, 0, -esp.NameOffset)
    overlay.Bottom.Position = UDim2.new(0.5, 0, 1, esp.DetailOffset + (esp.ArmorBar and 5 or 0))
    overlay.Armor.Position, overlay.Armor.Size = UDim2.new(0, 0, 1, 3), UDim2.new(1, 0, 0, 2)
    overlay.ArmorFill.BackgroundColor3 = esp.ArmorColor
    overlay.Top.TextSize, overlay.Bottom.TextSize = esp.FontSize, esp.FontSize
    overlay.Top.TextColor3, overlay.Bottom.TextColor3 = esp.TextColor, esp.TextColor
    overlay.Top.BackgroundColor3, overlay.Bottom.BackgroundColor3 = esp.BackgroundColor, esp.BackgroundColor
    local padding = UDim.new(0, esp.LabelPadding)
    overlay.TopPadding.PaddingLeft, overlay.TopPadding.PaddingRight = padding, padding
    overlay.BottomPadding.PaddingLeft, overlay.BottomPadding.PaddingRight = padding, padding
    overlay.StyleVersion = ConfigVersion
    overlay.Opacity, overlay.Color = nil, nil
    overlay.HealthFraction, overlay.ArmorValue = nil, nil
end
local function ColorOverlay(overlay, color, opacity)
    if overlay.Color ~= color then
        overlay.Color = color
        overlay.Box.BackgroundColor3, overlay.Border.Color = color, color
        for _, edge in overlay.Edges do
            edge.BackgroundColor3 = color
        end
    end
    opacity = math.floor(opacity * 64 + 0.5) / 64
    if overlay.Opacity == opacity then
        return
    end
    overlay.Opacity = opacity
    local esp = Config.Esp
    local transparency = 1 - opacity
    overlay.Box.BackgroundTransparency = esp.BoxFill and 1 - (1 - esp.BoxFillTransparency) * opacity or 1
    overlay.Border.Transparency = transparency
    overlay.Fill.BackgroundTransparency = transparency
    for index = 1, 8 do
        overlay.Edges[index].BackgroundTransparency = transparency
        overlay.Shadows[index].BackgroundTransparency = 1 - opacity * 0.8
    end
    local background = esp.LabelBackground and 1 - (1 - esp.LabelTransparency) * opacity or 1
    overlay.Top.BackgroundTransparency, overlay.Bottom.BackgroundTransparency = background, background
    overlay.Top.TextTransparency, overlay.Bottom.TextTransparency = transparency, transparency
end
local function JointProjection(record, name)
    local part = record.Parts[name]
    if not part then
        return
    end
    local cached = record.Projections[name]
    if not cached then
        cached = {}
        record.Projections[name] = cached
    end
    if cached.Frame ~= FrameId then
        cached.Point, cached.Visible = Camera:WorldToViewportPoint(part.Position)
        cached.Frame = FrameId
    end
    return cached.Point, cached.Visible
end
local function RenderSkeleton(record, overlay, distance, color)
    local esp = Config.Esp
    if
        not esp.Skeleton
        or distance > esp.SkeletonDistance
        or SkeletonCount >= esp.SkeletonLimit
        or esp.TargetOnlySkeleton and record ~= CurrentTarget
    then
        if overlay.BoneLayer then
            overlay.BoneLayer.Visible = false
        end
        return
    end
    SkeletonCount += 1
    if not overlay.BoneLayer then
        overlay.BoneLayer = Create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, Gui)
    end
    overlay.BoneLayer.Visible = true
    for index, pair in Bones do
        local first, firstVisible = JointProjection(record, pair[1])
        local second, secondVisible = JointProjection(record, pair[2])
        local line = overlay.Bones[index]
        if firstVisible and secondVisible then
            if not line then
                line = NewLine(overlay.BoneLayer)
                overlay.Bones[index] = line
            end
            Line(line, Vector2.new(first.X, first.Y), Vector2.new(second.X, second.Y), color)
        elseif line then
            line.Visible = false
        end
    end
end
local function UpdateLabels(record, overlay, distance, fraction, safe)
    local esp = Config.Esp
    if FrameTime < record.NextMetadata and record.MetadataVersion == ConfigVersion then
        return
    end
    record.NextMetadata, record.MetadataVersion = FrameTime + 1 / esp.MetadataRate, ConfigVersion
    local name = esp.DisplayNames and record.Player.DisplayName or record.Player.Name
    if esp.ShowUsernames and name ~= record.Player.Name then
        name ..= " (@" .. record.Player.Name .. ")"
    end
    local nameText = Colored(name, esp.NameColor)
    if overlay.Top.Text ~= nameText then
        overlay.Top.Text = nameText
    end
    local labels = record.LabelBuffer or {}
    local rows = record.RowBuffer or {}
    record.LabelBuffer, record.RowBuffer = labels, rows
    table.clear(labels)
    table.clear(rows)
    if esp.Distance then
        labels[#labels + 1] = Colored(
            string.format(
                esp.DistanceUnit == "Meters" and "%d m" or "%d studs",
                distance * (esp.DistanceUnit == "Meters" and 0.28 or 1)
            ),
            esp.DistanceColor
        )
    end
    local details = distance <= esp.DetailDistance
    if esp.HealthNumbers and details then
        labels[#labels + 1] = Colored(
            string.format("%d HP", record.Humanoid.Health),
            esp.HealthLowColor:Lerp(esp.HealthHighColor, fraction)
        )
    end
    local armor = record.Character:GetAttribute("Armor")
    local weapon = record.Character:GetAttribute("Equipped")
    record.Armor = type(armor) == "number" and armor or 0
    if esp.Armor and details and record.Armor > 0 then
        labels[#labels + 1] = Colored(string.format("%d armor", record.Armor), esp.ArmorColor)
    end
    if #labels > 0 then
        rows[#rows + 1] = table.concat(labels, "  ")
    end
    if esp.Weapon and details and type(weapon) == "string" and weapon ~= "" then
        rows[#rows + 1] = Colored(weapon:gsub("(%l)(%u)", "%1 %2"), esp.WeaponColor)
    end
    if esp.Status and safe and details then
        rows[#rows + 1] = Colored("SAFE ZONE", esp.StatusColor)
    end
    if esp.DownedStatus and details and record.Player:GetAttribute("BWDown") == true then
        rows[#rows + 1] = Colored("DOWNED", esp.TargetColor)
    end
    record.HasBottom = #rows > 0
    local text = table.concat(rows, "\n")
    if overlay.Bottom.Text ~= text then
        overlay.Bottom.Text = text
    end
end
local function Render(record)
    local esp = Config.Esp
    if record.Arrow then
        record.Arrow.Visible = false
    end
    if not esp.Enabled or not Living(record) then
        HideRecord(record)
        return
    end
    local teammate, safe = Teammate(record.Player), Safe(record)
    if esp.TeamCheck and teammate or safe and not esp.ShowSafeZone then
        HideRecord(record)
        return
    end
    local root, head = record.Parts.HumanoidRootPart, record.Parts.Head
    local distance = (root.Position - Camera.CFrame.Position).Magnitude
    if distance > esp.MaxDistance or not head then
        HideRecord(record)
        return
    end
    local fraction = math.clamp(record.Humanoid.Health / math.max(record.Humanoid.MaxHealth, 1), 0, 1)
    local color = Accent(record, distance, fraction, teammate)
    local screen, rootOnScreen = Camera:WorldToViewportPoint(root.Position)
    local viewport = Camera.ViewportSize
    local nearScreen = screen.Z > 0
        and screen.X >= -80
        and screen.X <= viewport.X + 80
        and screen.Y >= -100
        and screen.Y <= viewport.Y + 100
    if not rootOnScreen then
        UpdateArrow(record, screen, color)
    end
    if esp.Highlights and nearScreen and HighlightCount < esp.HighlightLimit then
        HighlightCount += 1
        if not record.Highlight then
            record.Highlight = Create("Highlight", { Name = "LxHighlight", Adornee = record.Character }, Gui)
        end
        local highlight = record.Highlight
        if record.HighlightVersion ~= ConfigVersion or record.HighlightColor ~= color then
            highlight.DepthMode = esp.ThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop
                or Enum.HighlightDepthMode.Occluded
            highlight.FillColor = esp.HighlightColorMode == "Accent" and color or esp.HighlightFillColor
            highlight.OutlineColor = esp.HighlightColorMode == "Accent"
                    and color:Lerp(Color3.new(1, 1, 1), 0.45)
                or esp.HighlightOutlineColor
            highlight.FillTransparency, highlight.OutlineTransparency =
                esp.FillTransparency, esp.OutlineTransparency
            record.HighlightVersion, record.HighlightColor = ConfigVersion, color
        end
        highlight.Enabled = true
    elseif record.Highlight then
        record.Highlight.Enabled = false
    end
    if not nearScreen or DetailedCount >= esp.MaxPlayers then
        HideOverlay(record)
        return
    end
    local left, top, right, bottom = BodyBounds(record)
    if not left then
        HideOverlay(record)
        return
    end
    local height, width, x = bottom - top, right - left, (left + right) * 0.5
    if
        height < esp.MinBoxHeight
        or width <= 0
        or right < 0
        or left > viewport.X
        or bottom < 0
        or top > viewport.Y
    then
        HideOverlay(record)
        return
    end
    DetailedCount += 1
    if esp.VisibilityColors and FrameTime >= record.NextVisibility then
        record.NextVisibility = FrameTime + 1 / esp.VisibilityRate
        local result = VisibilityHit(Camera.CFrame.Position, root.Position - Camera.CFrame.Position)
        record.Visible = not result or result.Instance:IsDescendantOf(record.Character)
        color = Accent(record, distance, fraction, teammate)
    end
    local overlay = record.Overlay or Allocate(record)
    if overlay.StyleVersion ~= ConfigVersion then
        StyleOverlay(overlay)
    end
    overlay.Layer.Position, overlay.Layer.Size = UDim2.fromOffset(left, top), UDim2.fromOffset(width, height)
    overlay.Layer.Visible = true
    local opacity = esp.DistanceFade
            and 1 - math.clamp(
                (distance - esp.FadeStart) / math.max(1, esp.MaxDistance - esp.FadeStart),
                0,
                1
            ) * (1 - esp.FadeMinimum)
        or 1
    ColorOverlay(overlay, color, opacity)
    if esp.Health or esp.HealthNumbers then
        local previous = record.SmoothedHealth or fraction
        local alpha = esp.HealthSmoothness == 0 and 1 or 1 - math.exp(-esp.HealthSmoothness * FrameDelta)
        local smoothed = previous + (fraction - previous) * alpha
        if math.abs(smoothed - fraction) < 0.001 then
            smoothed = fraction
        end
        if overlay.HealthFraction ~= smoothed then
            overlay.Fill.Size = UDim2.fromScale(1, smoothed)
            overlay.Fill.BackgroundColor3 = esp.HealthLowColor:Lerp(esp.HealthHighColor, fraction)
            overlay.HealthFraction = smoothed
        end
        record.SmoothedHealth = smoothed
    end
    UpdateLabels(record, overlay, distance, fraction, safe)
    overlay.Top.Visible = esp.Names
        and distance <= esp.NameDistance
        and ReserveLabel(overlay.Top, x, top - esp.NameOffset, true)
    overlay.Bottom.Visible = record.HasBottom
            and ReserveLabel(overlay.Bottom, x, bottom + esp.DetailOffset + (esp.ArmorBar and 5 or 0), false)
        or false
    local armor = esp.ArmorBar and (record.Armor or 0) > 0
    overlay.Armor.Visible = armor
    if armor and overlay.ArmorValue ~= record.Armor then
        overlay.ArmorFill.Size = UDim2.fromScale(math.clamp(record.Armor / esp.ArmorMaximum, 0, 1), 1)
        overlay.ArmorValue = record.Armor
    end
    if esp.Tracers then
        local start = esp.TracerOrigin == "Mouse" and Input:GetMouseLocation()
            or Vector2.new(viewport.X * 0.5, esp.TracerOrigin == "Center" and viewport.Y * 0.5 or viewport.Y)
        Line(overlay.Tracer, start, Vector2.new(x, bottom), color)
    else
        overlay.Tracer.Visible = false
    end
    RenderSkeleton(record, overlay, distance, color)
end

function Lx:Configure(patch)
    assert(Active and type(patch) == "table", "Configuration is unavailable or invalid")
    local changes = {}
    local aimPatch = patch.SilentAim
    if aimPatch then
        assert(type(aimPatch) == "table", "SilentAim settings must be a table")
        local minimum, maximum =
            aimPatch.MinDistance or Config.SilentAim.MinDistance,
            aimPatch.MaxDistance or Config.SilentAim.MaxDistance
        assert(
            type(minimum) == "number" and type(maximum) == "number" and minimum < maximum,
            "MinDistance must be smaller than MaxDistance"
        )
    end
    if aimPatch and aimPatch.HitChance ~= nil and aimPatch.MissChance ~= nil then
        assert(
            type(aimPatch.HitChance) == "number"
                and type(aimPatch.MissChance) == "number"
                and math.abs(aimPatch.HitChance + aimPatch.MissChance - 100) < 0.0001,
            "HitChance and MissChance must add to 100"
        )
    end
    for section, values in patch do
        assert(Config[section] and type(values) == "table", "Unknown configuration section")
        for key, value in values do
            assert(
                Config[section][key] ~= nil and typeof(value) == typeof(Config[section][key]),
                "Invalid option: " .. tostring(key)
            )
            if type(value) == "number" then
                assert(value == value and math.abs(value) < math.huge, "Expected finite number")
                local range = Bounds[key]
                if range then
                    assert(value >= range[1] and value <= range[2], "Option outside range: " .. key)
                end
            end
            if Choices[key] then
                assert(Choices[key][value], "Unsupported option: " .. key)
            end
            changes[#changes + 1] = { section, key, value }
        end
    end
    for _, change in changes do
        Config[change[1]][change[2]] = change[3]
    end
    if aimPatch then
        if aimPatch.MissChance ~= nil then
            Config.SilentAim.HitChance = 100 - aimPatch.MissChance
        elseif aimPatch.HitChance ~= nil then
            Config.SilentAim.MissChance = 100 - aimPatch.HitChance
        end
    end
    ConfigVersion += 1
    NextSort = 0
    if aimPatch then
        TargetCache.Valid = false
        CurrentTarget = nil
    end
    if RefreshInterface then
        RefreshInterface()
    end
    return self
end
function Lx:SetIgnoredPlayer(userId, ignored)
    assert(
        type(userId) == "number" and userId > 0 and userId % 1 == 0 and type(ignored) == "boolean",
        "Expected a user ID and a boolean"
    )
    IgnoredPlayers[userId] = ignored or nil
    TargetCache.Valid = false
    CurrentTarget = nil
    return self
end
function Lx:GetConfig()
    local result = {}
    for key, values in Config do
        result[key] = table.clone(values)
    end
    return result
end
function Lx:Destroy()
    if not Active then
        return
    end
    Active = false
    RunService:UnbindFromRenderStep("LxMenuInput")
    RestoreMenuMouse()
    if Library and not Library.Unloaded and not InterfaceUnloading then
        InterfaceUnloading = true
        Library:Unload()
    end
    RunService:UnbindFromRenderStep("LxOverlay")
    TargetCache.Valid = false
    if NamecallHook and Metatable.__namecall == NamecallHook then
        setreadonly(Metatable, false)
        Metatable.__namecall = PreviousNamecall
        setreadonly(Metatable, true)
    end
    Disconnect(Connections)
    local list = {}
    for player in Records do
        list[#list + 1] = player
    end
    for _, player in list do
        RemovePlayer(player)
    end
    Gui:Destroy()
    if RadiusDrawing then
        RadiusDrawing:Remove()
        RadiusDrawing = nil
    end
    if Environment.LxExternal == self then
        Environment.LxExternal = nil
    end
end
local function BuildInterface()
    local source = game:HttpGet(
        "https://raw.githubusercontent.com/mstudio45/LinoriaLib/a990198f968861412ce79519018ebfa438ea801e/Library.lua"
    )
    local loader, compileError = loadstring(source, "LinoriaLib")
    assert(loader, compileError)
    Library = loader()
    Library.IsMobile = false
    Library.ShowToggleFrameInKeybinds = false
    Library.ShowCustomCursor = false
    Library.AccentColor = Color3.fromRGB(153, 171, 255)
    Library.MainColor = Color3.fromRGB(22, 25, 34)
    Library.BackgroundColor = Color3.fromRGB(15, 18, 25)
    Library.OutlineColor = Color3.fromRGB(49, 55, 73)
    Library.FontColor = Color3.fromRGB(232, 236, 247)
    local originalDrag = Library.MakeDraggable
    function Library:MakeDraggable(frame, cutoff, mainWindow)
        if not mainWindow then
            return originalDrag(self, frame, cutoff, mainWindow)
        end
        frame.Active = true
        local screenGui = frame:FindFirstAncestorWhichIsA("ScreenGui")
        local dragStart, startPosition, startAbsolute
        local function Cursor()
            local position = Input:GetMouseLocation()
            if screenGui and not screenGui.IgnoreGuiInset then
                position -= GuiService:GetGuiInset()
            end
            return position
        end
        Connect(Input.InputBegan, function(input)
            if
                input.UserInputType ~= Enum.UserInputType.MouseButton1
                or not frame.Visible
                or Library.CantDragForced
            then
                return
            end
            local point, position, size = Cursor(), frame.AbsolutePosition, frame.AbsoluteSize
            if
                point.X < position.X
                or point.X > position.X + size.X
                or point.Y < position.Y
                or point.Y > position.Y + (cutoff or 25)
            then
                return
            end
            dragStart, startPosition, startAbsolute = point, frame.Position, position
        end)
        Connect(Input.InputChanged, function(input)
            if not dragStart or input.UserInputType ~= Enum.UserInputType.MouseMovement then
                return
            end
            if not frame.Visible or Library.CantDragForced then
                dragStart = nil
                return
            end
            local delta = Cursor() - dragStart
            local viewport = World.CurrentCamera and World.CurrentCamera.ViewportSize
                or Vector2.new(1920, 1080)
            local inset = screenGui and not screenGui.IgnoreGuiInset and GuiService:GetGuiInset()
                or Vector2.zero
            local x = math.clamp(startAbsolute.X + delta.X, 0, math.max(0, viewport.X - frame.AbsoluteSize.X))
            local y = math.clamp(
                startAbsolute.Y + delta.Y,
                0,
                math.max(0, viewport.Y - inset.Y - frame.AbsoluteSize.Y)
            )
            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + x - startAbsolute.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + y - startAbsolute.Y
            )
        end)
        Connect(Input.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragStart = nil
            end
        end)
        Connect(Input.WindowFocusReleased, function()
            dragStart = nil
        end)
    end
    Library:OnUnload(function()
        InterfaceUnloading = true
        Lx:Destroy()
    end)
    local viewport = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
    local window = Library:CreateWindow({
        Title = "Lx External",
        Center = true,
        AutoShow = true,
        Resizable = true,
        Size = UDim2.fromOffset(math.clamp(viewport.X - 80, 550, 720), math.clamp(viewport.Y - 80, 350, 630)),
        ShowCustomCursor = false,
        UnlockMouseWhileOpen = true,
        TabPadding = 12,
        MenuFadeTime = 0,
    })
    local tabs = {
        Aim = window:AddTab("Silent aim"),
        Esp = window:AddTab("ESP"),
        Appearance = window:AddTab("Appearance"),
        Settings = window:AddTab("Settings"),
    }
    RunService:BindToRenderStep("LxMenuInput", Enum.RenderPriority.Last.Value + 1, function()
        if Active and Library.Toggled and not Library.Unloaded then
            if not MenuMouseState then
                MenuMouseState = { Behavior = Input.MouseBehavior, Icon = Input.MouseIconEnabled }
            end
            Input.MouseBehavior = Enum.MouseBehavior.Default
            Input.MouseIconEnabled = true
        else
            RestoreMenuMouse()
        end
    end)
    local bindings = {}
    UIUpdating = true
    local function Bind(control, section, key, color)
        bindings[#bindings + 1] = { Control = control, Section = section, Key = key, Color = color }
        control:OnChanged(function()
            if UIUpdating or not Active then
                return
            end
            local ok, message = pcall(Lx.Configure, Lx, { [section] = { [key] = control.Value } })
            if not ok then
                RefreshInterface()
                Library:Notify(tostring(message), 4)
            end
        end)
        return control
    end
    local function Toggle(group, section, key, text, tooltip)
        return Bind(
            group:AddToggle(
                section .. key,
                { Text = text, Default = Config[section][key], Tooltip = tooltip }
            ),
            section,
            key
        )
    end
    local function Slider(group, section, key, text, minimum, maximum, decimals, suffix, tooltip)
        return Bind(
            group:AddSlider(section .. key, {
                Text = text,
                Default = Config[section][key],
                Min = minimum,
                Max = maximum,
                Rounding = decimals or 0,
                Suffix = suffix or "",
                Tooltip = tooltip,
            }),
            section,
            key
        )
    end
    local function Dropdown(group, section, key, text, values, tooltip)
        return Bind(
            group:AddDropdown(section .. key, {
                Text = text,
                Values = values,
                Default = table.find(values, Config[section][key]),
                Multi = false,
                Tooltip = tooltip,
            }),
            section,
            key
        )
    end
    local function Color(group, section, key, text)
        local label = group:AddLabel(text)
        label:AddColorPicker(section .. key, { Default = Config[section][key], Title = text })
        return Bind(Library.Options[section .. key], section, key, true)
    end
    RefreshInterface = function()
        if not Library or Library.Unloaded then
            return
        end
        UIUpdating = true
        for _, binding in bindings do
            local value = Config[binding.Section][binding.Key]
            if binding.Control.Value ~= value then
                if binding.Color then
                    binding.Control:SetValueRGB(value)
                else
                    binding.Control:SetValue(value)
                end
            end
        end
        UIUpdating = false
    end
    local target = tabs.Aim:AddLeftGroupbox("Targeting")
    Toggle(target, "SilentAim", "Enabled", "Enable silent aim")
    Dropdown(
        target,
        "SilentAim",
        "SelectionMode",
        "FOV measurement",
        { "Angle", "Screen" },
        "Angle uses degrees; Screen uses pixels."
    )
    Slider(target, "SilentAim", "FOV", "Angular FOV", 1, 180, 0, "°")
    Slider(target, "SilentAim", "Radius", "Screen radius", 10, 1000, 0, " px")
    Dropdown(target, "SilentAim", "Priority", "Target priority", { "Distance", "Crosshair", "Health" })
    Dropdown(
        target,
        "SilentAim",
        "Part",
        "Hit part",
        { "Head", "UpperTorso", "HumanoidRootPart", "Weighted" }
    )
    Slider(target, "SilentAim", "MaxDistance", "Maximum distance", 2, 450, 0, " studs")
    Toggle(target, "SilentAim", "RespectWeaponRange", "Respect equipped weapon range")
    local behavior = tabs.Aim:AddLeftGroupbox("Accuracy and activation")
    Slider(
        behavior,
        "SilentAim",
        "MissChance",
        "Miss chance",
        0,
        100,
        0,
        "%",
        "Leaves this percentage of shots unchanged; it does not force a miss."
    )
    Slider(
        behavior,
        "SilentAim",
        "HeadChance",
        "Weighted head chance",
        0,
        100,
        0,
        "%",
        "Used only when Hit part is Weighted."
    )
    Dropdown(behavior, "SilentAim", "Activation", "Activation", { "Always", "Hold", "Toggle" })
    Dropdown(behavior, "SilentAim", "ActivationButton", "Hold mouse button", { "Right", "Left", "Middle" })
    Dropdown(behavior, "SilentAim", "ToggleKey", "Toggle key", { "Home", "Insert", "F6", "F7", "F8" })
    Toggle(behavior, "SilentAim", "StickyTarget", "Prefer current target")
    Slider(behavior, "SilentAim", "SwitchDelay", "Target switch delay", 0, 0.5, 2, " s")
    local filters = tabs.Aim:AddRightGroupbox("Target filters")
    Toggle(filters, "SilentAim", "SafeZoneCheck", "Skip safe-zone players")
    Toggle(filters, "SilentAim", "IgnoreDowned", "Skip downed players")
    Toggle(filters, "SilentAim", "TeamCheck", "Skip teammates")
    Toggle(filters, "SilentAim", "IgnoreFriends", "Skip friends")
    Toggle(filters, "SilentAim", "IgnoreUnarmed", "Skip unarmed players")
    Toggle(filters, "SilentAim", "ReadyCheck", "Require PvP readiness")
    Toggle(filters, "SilentAim", "ForceFieldCheck", "Skip force fields")
    Toggle(filters, "SilentAim", "VisibilityCheck", "Require line of sight")
    Dropdown(
        filters,
        "SilentAim",
        "VisibilityMode",
        "Visibility rules",
        { "Weapon", "World" },
        "Weapon respects the game's glass and vehicle pass-through rules."
    )
    local fov = tabs.Aim:AddRightGroupbox("FOV and target display")
    Toggle(fov, "SilentAim", "ShowRadius", "Show FOV circle")
    Dropdown(fov, "SilentAim", "FovRenderer", "Circle renderer", { "Auto", "Drawing", "Gui" })
    Dropdown(fov, "SilentAim", "Origin", "Screen-mode center", { "Center", "Mouse" })
    Slider(fov, "SilentAim", "RadiusThickness", "Circle thickness", 1, 5)
    Slider(fov, "SilentAim", "RadiusTransparency", "Circle transparency", 0, 1, 2)
    Color(fov, "SilentAim", "RadiusColor", "FOV color")
    Toggle(fov, "SilentAim", "ShowTarget", "Mark selected target")
    Toggle(fov, "SilentAim", "TargetLine", "Line to selected target")
    Color(fov, "SilentAim", "TargetColor", "Target marker color")
    local elements = tabs.Esp:AddLeftGroupbox("Player information")
    for _, option in
        {
            { "Enabled", "Enable ESP" },
            { "Names", "Names" },
            { "DisplayNames", "Use display names" },
            { "ShowUsernames", "Include usernames" },
            { "Health", "Health bar" },
            { "HealthNumbers", "Health number" },
            { "ArmorBar", "Armor bar" },
            { "Armor", "Armor number" },
            { "Distance", "Distance" },
            { "Weapon", "Equipped weapon" },
            { "Status", "Safe-zone status" },
            { "DownedStatus", "Downed status" },
        }
    do
        Toggle(elements, "Esp", option[1], option[2])
    end
    Dropdown(elements, "Esp", "DistanceUnit", "Distance unit", { "Studs", "Meters" })
    local espFilters = tabs.Esp:AddLeftGroupbox("Visibility and distance")
    Slider(espFilters, "Esp", "MaxDistance", "ESP distance", 25, 1500, 0, " studs")
    Slider(espFilters, "Esp", "DetailDistance", "Detailed labels within", 25, 600, 0, " studs")
    Slider(espFilters, "Esp", "NameDistance", "Names within", 25, 1500, 0, " studs")
    Toggle(espFilters, "Esp", "ShowSafeZone", "Show safe-zone players")
    Toggle(espFilters, "Esp", "ShowDowned", "Show downed players")
    Toggle(espFilters, "Esp", "TeamCheck", "Hide teammates")
    local geometry = tabs.Esp:AddRightGroupbox("Boxes and skeletons")
    Toggle(geometry, "Esp", "Boxes", "Boxes")
    Dropdown(geometry, "Esp", "BoxStyle", "Box style", { "Corners", "Full" })
    Toggle(geometry, "Esp", "BoxOutline", "Corner outlines")
    Toggle(geometry, "Esp", "BoxFill", "Subtle box fill")
    Slider(geometry, "Esp", "Thickness", "Line thickness", 1, 4)
    Slider(geometry, "Esp", "CornerLength", "Corner length", 0.05, 0.5, 2)
    Toggle(geometry, "Esp", "Skeleton", "Skeletons")
    Toggle(geometry, "Esp", "TargetOnlySkeleton", "Skeleton only on selected target")
    Slider(geometry, "Esp", "SkeletonDistance", "Skeleton distance", 25, 600, 0, " studs")
    Toggle(geometry, "Esp", "Tracers", "Screen tracers")
    Dropdown(geometry, "Esp", "TracerOrigin", "Tracer origin", { "Bottom", "Center", "Mouse" })
    local arrows = tabs.Esp:AddRightGroupbox("Offscreen indicators")
    Toggle(arrows, "Esp", "OffscreenArrows", "Offscreen arrows")
    Slider(arrows, "Esp", "ArrowLimit", "Maximum arrows", 0, 20)
    Slider(arrows, "Esp", "ArrowSize", "Arrow size", 5, 25)
    Slider(arrows, "Esp", "ArrowRadius", "Distance from screen center", 0.1, 0.48, 2)
    local colors = tabs.Appearance:AddLeftGroupbox("ESP palette")
    Dropdown(
        colors,
        "Esp",
        "ColorMode",
        "Accent source",
        { "Player", "Static", "Team", "Health", "Distance" }
    )
    Toggle(colors, "Esp", "TargetAccent", "Accent selected target")
    for _, option in
        {
            { "EnemyColor", "Primary accent" },
            { "TeamColor", "Team / near accent" },
            { "TargetColor", "Selected target" },
            { "NameColor", "Names" },
            { "DistanceColor", "Distance" },
            { "WeaponColor", "Weapons" },
            { "ArmorColor", "Armor" },
            { "StatusColor", "Safe-zone status" },
            { "HealthLowColor", "Low health" },
            { "HealthHighColor", "Full health" },
            { "BackgroundColor", "Label background" },
        }
    do
        Color(colors, "Esp", option[1], option[2])
    end
    local labels = tabs.Appearance:AddRightGroupbox("Labels")
    Slider(labels, "Esp", "FontSize", "Text size", 9, 22)
    Toggle(labels, "Esp", "LabelBackground", "Label backgrounds")
    Slider(labels, "Esp", "LabelTransparency", "Background transparency", 0, 1, 2)
    Toggle(labels, "Esp", "Declutter", "Prevent overlapping labels")
    Slider(labels, "Esp", "MaxLabels", "Maximum labels", 4, 64)
    Slider(
        labels,
        "Esp",
        "HealthSmoothness",
        "Health-bar easing",
        0,
        30,
        0,
        "",
        "Only eases health changes; player positions always update immediately."
    )
    Toggle(labels, "Esp", "DistanceFade", "Fade distant players")
    local highlights = tabs.Appearance:AddRightGroupbox("Character highlights")
    Toggle(highlights, "Esp", "Highlights", "Highlights")
    Toggle(highlights, "Esp", "ThroughWalls", "Highlights through walls")
    Dropdown(highlights, "Esp", "HighlightColorMode", "Highlight colors", { "Accent", "Custom" })
    Color(highlights, "Esp", "HighlightFillColor", "Custom fill")
    Color(highlights, "Esp", "HighlightOutlineColor", "Custom outline")
    Slider(highlights, "Esp", "FillTransparency", "Fill transparency", 0, 1, 2)
    Slider(highlights, "Esp", "OutlineTransparency", "Outline transparency", 0, 1, 2)
    local performance = tabs.Settings:AddLeftGroupbox("ESP workload")
    performance:AddLabel("Positions update every frame after the camera.", true)
    performance:AddLabel("Reduce these limits for slower PCs.", true)
    Slider(
        performance,
        "Esp",
        "MaxPlayers",
        "Detailed players",
        1,
        64,
        0,
        "",
        "Nearest visible players first; the selected target takes priority."
    )
    Slider(performance, "Esp", "SkeletonLimit", "Simultaneous skeletons", 0, 20)
    Slider(performance, "Esp", "HighlightLimit", "Simultaneous highlights", 0, 24)
    Slider(
        performance,
        "Esp",
        "MetadataRate",
        "Label refresh rate",
        1,
        20,
        0,
        " Hz",
        "Changes text refresh only, not position updates."
    )
    Slider(performance, "Esp", "SortRate", "Priority refresh rate", 1, 20, 0, " Hz")
    Dropdown(
        performance,
        "Esp",
        "BoundsMode",
        "Body bounds",
        { "Fast", "Accurate" },
        "Fast uses head/feet projections. Accurate follows all body parts and costs more."
    )
    Toggle(
        performance,
        "Esp",
        "VisibilityColors",
        "Color occluded players",
        "Adds visibility raycasts; leave off for the lowest CPU cost."
    )
    Slider(performance, "Esp", "VisibilityRate", "Visibility checks", 1, 10, 0, " Hz")
    local crosshair = tabs.Settings:AddLeftGroupbox("Crosshair")
    Toggle(crosshair, "Visuals", "Crosshair", "Custom crosshair")
    Toggle(crosshair, "Visuals", "CrosshairDot", "Center dot")
    Slider(crosshair, "Visuals", "CrosshairSize", "Arm length", 1, 20)
    Slider(crosshair, "Visuals", "CrosshairGap", "Center gap", 0, 20)
    Color(crosshair, "Visuals", "CrosshairColor", "Crosshair color")
    local interface = tabs.Settings:AddRightGroupbox("Interface")
    interface
        :AddLabel("Menu key")
        :AddKeyPicker("LxMenuKey", { Default = "RightShift", Mode = "Toggle", NoUI = true, Text = "Menu" })
    Library.ToggleKeybind = Library.Options.LxMenuKey
    interface
        :AddLabel("Interface accent")
        :AddColorPicker("LxMenuAccent", { Default = Library.AccentColor, Title = "Interface accent" })
    Library.Options.LxMenuAccent:OnChanged(function()
        Library.AccentColor = Library.Options.LxMenuAccent.Value
        Library:UpdateColorsUsingRegistry()
    end)
    interface:AddButton({
        Text = "Hide menu",
        Func = function()
            Library:Toggle(false)
        end,
    })
    interface:AddButton({
        Text = "Unload",
        Func = function()
            Lx:Destroy()
        end,
        DoubleClick = true,
    })
    interface:AddLabel("Keyboard and mouse only. Right Shift opens the menu.", true)
    UIUpdating = false
    Library:UpdateColorsUsingRegistry()
end
local interfaceOk, interfaceError = pcall(BuildInterface)
if not interfaceOk then
    Lx:Destroy()
    error("Unable to initialize Lx External interface: " .. tostring(interfaceError), 0)
end

Connect(Players.PlayerAdded, AddPlayer)
Connect(Players.PlayerRemoving, RemovePlayer)
for _, player in Players:GetPlayers() do
    AddPlayer(player)
end
Connect(World:GetPropertyChangedSignal("CurrentCamera"), function()
    Camera = World.CurrentCamera
end)
Connect(Input.InputBegan, function(input, processed)
    if processed or Input:GetFocusedTextBox() then
        return
    end
    if input.KeyCode.Name == Config.SilentAim.ToggleKey then
        ToggleActive = not ToggleActive
    end
end)
RunService:BindToRenderStep("LxOverlay", Enum.RenderPriority.Last.Value, function(deltaTime)
    FrameTime, FrameDelta = os.clock(), math.min(deltaTime, 0.1)
    FrameId += 1
    if Camera then
        local ignore = {}
        if Player.Character then
            ignore[#ignore + 1] = Player.Character
        end
        ignore[#ignore + 1] = Camera
        Parameters.FilterDescendantsInstances = ignore
    end
    UpdateSilentAim()
    Gui.Enabled = Camera ~= nil
    if not Camera then
        if RadiusDrawing then
            RadiusDrawing.Visible = false
        end
        return
    end
    UpdateVisuals()
    if not Config.Esp.Enabled then
        if EspWasEnabled then
            for _, record in Records do
                HideRecord(record)
            end
        end
        EspWasEnabled = false
        return
    end
    EspWasEnabled = true
    LabelCount = 0
    if FrameTime >= NextSort then
        NextSort = FrameTime + 1 / Config.Esp.SortRate
        table.clear(SortedRecords)
        for _, record in Records do
            local root = record.Parts.HumanoidRootPart
            record.SortDistance = root and (root.Position - Camera.CFrame.Position).Magnitude or math.huge
            SortedRecords[#SortedRecords + 1] = record
        end
        table.sort(SortedRecords, function(a, b)
            return a.SortDistance < b.SortDistance
        end)
    end
    HighlightCount, ArrowCount, DetailedCount, SkeletonCount = 0, 0, 0, 0
    if CurrentTarget then
        Render(CurrentTarget)
    end
    for _, record in SortedRecords do
        if record ~= CurrentTarget then
            Render(record)
        end
    end
end)
PreviousNamecall = Metatable.__namecall
NamecallHook = function(self, ...)
    if getnamecallmethod() == "FireServer" and self == Fire and Active and Config.SilentAim.Enabled then
        local part = TargetCache.Part
        if
            TargetCache.Valid
            and part
            and part.Parent
            and (Config.SilentAim.HitChance >= 100 or RandomFloat() * 100 < Config.SilentAim.HitChance)
        then
            local point, direction = TargetCache.Point, TargetCache.Direction
            if
                Config.SilentAim.Part == "Weighted"
                and TargetCache.HeadPart
                and TargetCache.HeadPart.Parent
                and RandomFloat() * 100 < Config.SilentAim.HeadChance
            then
                part, point, direction =
                    TargetCache.HeadPart, TargetCache.HeadPoint, TargetCache.HeadDirection
            end
            local arguments = table.pack(...)
            arguments[1], arguments[2], arguments[3], arguments[4] =
                TargetCache.Origin, direction, part, point
            return PreviousNamecall(self, table.unpack(arguments, 1, math.max(arguments.n, 4)))
        end
    end
    return PreviousNamecall(self, ...)
end
setreadonly(Metatable, false)
Metatable.__namecall = NamecallHook
setreadonly(Metatable, true)
UpdateSilentAim()
Environment.LxExternal = Lx
return Lx
