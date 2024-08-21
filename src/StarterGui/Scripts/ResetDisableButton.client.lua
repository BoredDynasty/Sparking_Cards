 coroutine.wrap(function()
       local sg = game:GetService('StarterGui')
       local maxTries = 20
       repeat 
               local success = pcall(function() 
                       sg:SetCore('ResetButtonCallback', false) 
               end) 
               wait(.2) 
               maxTries = maxTries - 1
        until success or maxTries == 0
end)()

--IMPORTANT! This disables the reset button in the tab. This is recommended for showcases or horror games.