loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacker1337/legohacks/main/PhysicsServiceOnClient.lua"))()
if _G.Fling == nil then _G.Fling = false end
if _G.ShowReal == nil then _G.ShowReal = false end
if _G.GodMode == nil then _G.GodMode = true end
if _G.R15toR6 == nil then _G.R15toR6 = true end
local PhysicsService = game:GetService("PhysicsService")
local check
pcall(function() check = PhysicsService:GetCollisionGroupId("NoCollide") end)
if not check then
	PhysicsService:CreateCollisionGroup("NoCollide")
end
PhysicsService:CollisionGroupSetCollidable("NoCollide", "NoCollide", false)

local plr = game.Players.LocalPlayer

local offsets = {
	["Left Arm"] = {["LeftUpperArm"] = CFrame.new(0,0.39,0),
		["LeftLowerArm"] = CFrame.new(0,-0.15,0),
		["LeftHand"] = CFrame.new(0,-0.85,0)
	},
	["Right Arm"] = {["RightUpperArm"] = CFrame.new(0,0.39,0),
		["RightLowerArm"] = CFrame.new(0,-0.15,0),
		["RightHand"] = CFrame.new(0,-0.85,0)
	},
	["Torso"] = {["UpperTorso"] = CFrame.new(0,0.2,0),
		["LowerTorso"] = CFrame.new(0,-0.8,0),
	},
	["Left Leg"] = {["LeftUpperLeg"] = CFrame.new(0,0.5,0),
		["LeftLowerLeg"] = CFrame.new(0,-0.05,0),
		["LeftFoot"] = CFrame.new(0,-0.85,0)
	},
	["Right Leg"] = {["RightUpperLeg"] = CFrame.new(0,0.5,0),
		["RightLowerLeg"] = CFrame.new(0,-0.05,0),
		["RightFoot"] = CFrame.new(0,-0.85,0)
	},
	["Head"] = {["Head"] = CFrame.new(0,0,0)},
	--["HumanoidRootPart"] = {["Head"] = CFrame.new(0,0,0)},
}

local Character,originalrig

local rigtype = plr.Character.Humanoid.RigType

if rigtype == Enum.HumanoidRigType.R15 and _G.R15toR6 then
	originalrig = plr.Character
	Character = game:GetObjects("rbxassetid://8232772380")[1]:Clone()
    Character.Parent = workspace
    local desc = game.Players:GetHumanoidDescriptionFromUserId(plr.UserId)
    Character.Humanoid:ApplyDescription(desc)
	Character.Name = "FakeBody"
    Character:MoveTo(plr.Character.HumanoidRootPart.Position)
    for i=1,10 do
        game["Run Service"].RenderStepped:Wait()
    end
else
	plr.Character.Archivable = true
	Character = plr.Character:Clone()
	plr.Character.Archivable = false
	originalrig = plr.Character
	Character.Parent = workspace
	Character.Name = "FakeBody"
end

for i,v in pairs(originalrig:GetDescendants()) do
	if v:IsA("Motor6D") and v.Name ~= "Neck" then v:Destroy()
	elseif v:IsA("BasePart") then
		local a = Instance.new("BodyVelocity",v)
		a.MaxForce = Vector3.new(math.huge,math.huge,math.huge); a.P = math.huge; a.Velocity = Vector3.new(-25.05,-25.05,-25.05)
		local a = Instance.new("BodyAngularVelocity",v)
		a.MaxTorque = Vector3.new(math.huge,math.huge,math.huge); a.P = math.huge; a.AngularVelocity = Vector3.new(0,0,0)
	end
end

local invisrig = _G.ShowReal and Character or originalrig
for i,v in pairs(invisrig:GetChildren()) do
	if v:IsA("BasePart") then
		v.Transparency = 1
		local selectionbox = Instance.new("SelectionBox",v)
		selectionbox.Transparency = 1; selectionbox.Adornee = v;
	elseif v:IsA("Accessory") then
		v.Handle.Transparency = 1
	end
end

plr.Character.Parent = Character
plr.Character = Character
if rigtype == Enum.HumanoidRigType.R15 and _G.R15toR6 then
    coroutine.resume(coroutine.create(function()
        _G.ForHonor = Character.Animate
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CenteredSniper/Kenzen/master/Animate"))()
    end))
else
    Character.Animate.Disabled = true; wait() Character.Animate.Disabled = false
end
workspace.CurrentCamera.CameraSubject = Character.Humanoid
for i,v in pairs(Character:GetDescendants()) do
	if v:IsA("BasePart") then
		PhysicsService:SetPartCollisionGroup(v, "NoCollide")
	end
end

--originalrig.Torso.Neck.Parent = nil

game["Run Service"].RenderStepped:Connect(function(delta)
	if rigtype == Enum.HumanoidRigType.R15 and _G.R15toR6 then
		for _,abc in pairs(offsets) do
			for i,abcd in pairs(abc) do
                coroutine.resume(coroutine.create(function()
                    if originalrig:FindFirstChild(i) then
                        local ExpectedPosition = Character[_].CFrame * abcd
                        game:GetService("TweenService"):Create(originalrig[i],TweenInfo.new((delta)),{CFrame = ExpectedPosition + Vector3.new(0.42,0.42,0.42)}):Play()
                    end
                end))
			end
		end
		for i,v in pairs(originalrig:GetChildren()) do
			coroutine.resume(coroutine.create(function()
				if v:IsA("BasePart") then
					v.CanCollide = false
					v.Velocity = Vector3.new(-25.05, -25.05, -25.05)
				elseif v:IsA("Accessory") then
					v.Handle.Velocity = Vector3.new(-25.05, -25.05, -25.05)
                    print(Character[v.Name].Handle.CFrame)
					game:GetService("TweenService"):Create(v.Handle,TweenInfo.new((delta)),{CFrame = Character[v.Name].Handle.CFrame + Vector3.new(0.42,0.42,0.42)}):Play()
				end
			end))
		end
		if originalrig:FindFirstChild("HumanoidRootPart") and _G.Fling then
			game:GetService("TweenService"):Create(originalrig["HumanoidRootPart"],TweenInfo.new((delta)),{CFrame = Character["HumanoidRootPart"].CFrame + Vector3.new(0.42,0.42,0.42)}):Play()
		end
	else
		for i,v in pairs(originalrig:GetChildren()) do
			coroutine.resume(coroutine.create(function()
				if v:IsA("BasePart") then
					v.CanCollide = false
					v.Velocity = Vector3.new(-25.05, -25.05, -25.05)
					if v.Name == "HumanoidRootPart" and _G.Fling then
						--nothing
					else
						game:GetService("TweenService"):Create(v,TweenInfo.new((delta)),{CFrame = Character[v.Name].CFrame + Vector3.new(0.42,0.42,0.42)}):Play()
					end
				elseif v:IsA("Accessory") then
					v.Handle.Velocity = Vector3.new(-25.05, -25.05, -25.05)
					game:GetService("TweenService"):Create(v.Handle,TweenInfo.new((delta)),{CFrame = Character[v.Name].Handle.CFrame + Vector3.new(0.42,0.42,0.42)}):Play()
				end
			end))
		end
	end
end)

plr.Chatted:Connect(function(msg)
	if string.sub(msg,1,6) == "/parts" then
		for i,v in pairs(originalrig:GetChildren()) do
			if v:IsA("BasePart") then
				if v.SelectionBox.Transparency == 0 then v.SelectionBox.Transparency = 1 else
					v.SelectionBox.Transparency = 0 end
			end
		end
	end
end)

Character.Humanoid.Died:Connect(function()
	plr.Character = originalrig
	originalrig:ClearAllChildren()
	originalrig.Parent = workspace
	Character:Destroy()
end)

if _G.GodMode then
	wait(game.Players.RespawnTime + 1)
    repeat wait() until isnetworkowner(originalrig.Head)
	originalrig:FindFirstChild("Neck",true).Parent = nil
end