repeat task.wait(); until game:IsLoaded();

local bullshit = {
    maxDistance = 1000;
    lootObjects = {};
}

local userInputService  = game:GetService('UserInputService');
local runService        = game:GetService('RunService');
local replicatedStorage = game:GetService('ReplicatedStorage');
local coreGui           = game:GetService('CoreGui');
local httpService       = game:GetService('HttpService');
local lightingService   = game:GetService('Lighting');
local teamService       = game:GetService('Team');
local playerService     = game:GetService('Players');

local localPlayer       = playerService.LocalPlayer;
local currentCamera     = workspace.CurrentCamera;
local playerMouse       = localPlayer:GetMouse();
local random            = Random.new();

local function charFunction(player, func)
    if (player) and (player.Character) then if (player.Character:FindFirstChild('HumanoidRootPart')) then
        func(player.Character);
    end; end;
end;

local function newThread(func)
    task.spawn(func);
end;

newThread(function()
    while task.wait(1) do
        for _, thing in pairs(workspace.Loot:GetDescendants()) do
            if (thing:IsA('CFrameValue')) then
                if (not bullshit.lootObjects[thing]) then
                    bullshit.lootObjects[thing] = {txt; pos;};
                    local lot = bullshit.lootObjects[thing];
                    lot.txt = Drawing.new('Text');
                    lot.txt.ZIndex = 1;
                    lot.txt.Visible = true;
                    lot.txt.Transparency = 1;
                    lot.txt.Color = Color3.new(1, 0.5, 0.5);
                    lot.txt.Font = Drawing.Fonts.Plex;
                    lot.txt.Size = 13;
                    lot.txt.Outline = true;
                    
                    lot.pos = thing;
                end;
            end;
        end;
    end;
end);

runService.RenderStepped:Connect(function()
    for _, object in pairs(bullshit.lootObjects) do
        if (object.pos) then
            object.txt.Visible = false;
            charFunction(localPlayer, function(localCharacter)
                if ((localCharacter.HumanoidRootPart.Position - object.pos.Value.Position).magnitude<2500) then
                    local itemPos, itemVis = currentCamera:WorldToViewportPoint(object.pos.Value.Position);
                    if (itemVis) then
                        object.txt.Visible = true;
                        object.txt.Position = Vector2.new(itemPos.X, itemPos.Y)
                        object.txt.Text = object.pos.Name
                    end;
                end;
            end);
        else
            object.txt:Remove();
            object.txt = nil;
            object.pos = nil;
            object = nil;
        end;
    end;
end);
