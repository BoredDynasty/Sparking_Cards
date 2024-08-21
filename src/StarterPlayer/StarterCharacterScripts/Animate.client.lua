local RunService = game:GetService('RunService')

local Player = game.Players.LocalPlayer
local Character = Player.Character
local HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')
local Humanoid = Character:WaitForChild('Humanoid')

local AnimationsFolder = script:WaitForChild('Animations')

local AnimationsTable = {
	['Idle'] = Humanoid:LoadAnimation( AnimationsFolder.Idle ),
	['WalkForward'] = Humanoid:LoadAnimation( AnimationsFolder.WalkForward ),
	['WalkRight'] = Humanoid:LoadAnimation( AnimationsFolder.WalkRight ),
	['WalkLeft'] = Humanoid:LoadAnimation( AnimationsFolder.WalkLeft ),
}

for _, Animation in AnimationsTable do

	Animation:Play( 0, 0.01, 0 )

end

RunService.RenderStepped:Connect(function()

	local DirectionOfMovement = HumanoidRootPart.CFrame:VectorToObjectSpace( HumanoidRootPart.AssemblyLinearVelocity )

	local Forward = math.abs( math.clamp( DirectionOfMovement.Z / Humanoid.WalkSpeed, -1, -0.01 ) )
	local Backwards = math.abs( math.clamp( DirectionOfMovement.Z / Humanoid.WalkSpeed, 0.01, 1 ) )
	local Right = math.abs( math.clamp( DirectionOfMovement.X / Humanoid.WalkSpeed, 0.01, 1 ) )
	local Left = math.abs( math.clamp( DirectionOfMovement.X / Humanoid.WalkSpeed, -1, -0.01 ) )

	local SpeedUnit = (DirectionOfMovement.Magnitude / Humanoid.WalkSpeed)

	local State = Humanoid:GetState()

	if DirectionOfMovement.Magnitude > 0.1 then
		if AnimationsTable.WalkForward.IsPlaying == false then
			AnimationsTable.WalkForward:Play( 0,0.01,0 )
			AnimationsTable.WalkRight:Play( 0,0.01,0  )
			AnimationsTable.WalkLeft:Play( 0,0.01,0  )
		end	
	end

	if DirectionOfMovement.Z/Humanoid.WalkSpeed < 0.1 then

		AnimationsTable.WalkForward:AdjustWeight( Forward )
		AnimationsTable.WalkRight:AdjustWeight( Right )
		AnimationsTable.WalkLeft:AdjustWeight( Left )

		AnimationsTable.WalkForward:AdjustSpeed( SpeedUnit )
		AnimationsTable.WalkRight:AdjustSpeed( SpeedUnit )
		AnimationsTable.WalkLeft:AdjustSpeed( SpeedUnit )

		AnimationsTable.Idle:AdjustWeight(0.001)

	else

		AnimationsTable.WalkForward:AdjustWeight( Backwards )
		AnimationsTable.WalkRight:AdjustWeight( Left )
		AnimationsTable.WalkLeft:AdjustWeight( Right )

		AnimationsTable.WalkForward:AdjustSpeed( SpeedUnit * -1 )
		AnimationsTable.WalkRight:AdjustSpeed( SpeedUnit * -1 )
		AnimationsTable.WalkLeft:AdjustSpeed( SpeedUnit * -1 )

		AnimationsTable.Idle:AdjustWeight(0.001)

	end


	if DirectionOfMovement.Magnitude < 0.1 then
		AnimationsTable.Idle:AdjustWeight(1)
	end



end)