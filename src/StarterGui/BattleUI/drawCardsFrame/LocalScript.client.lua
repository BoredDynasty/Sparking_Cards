local textLabelTemplate = script.TextLabel

local plr = game.Players.LocalPlayer

newClone = textLabelTemplate:Clone()
newClone.Parent = script.Parent.Main

newClone.Text = tostring(plr:WaitForChild("leaderstats").Cards.Value) .. "can be drawn."
