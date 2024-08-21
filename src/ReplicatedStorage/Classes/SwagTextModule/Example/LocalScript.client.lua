local SwagText = require(script.Parent.Parent)
local use = "normal, <red>red</red>, <blue>blue</blue>, <color=#00ff00>green</color>, <bold>bold</bold>, <italic>italic</italic>, <red><bold><shake>impact</shake></red></bold>, <warp><rainbow>chroma</rainbow></warp>, <color=#aaaaaa><pause=0.5>slow</pause></color>"

-- == EXAMPLE HERE == --
SwagText.AnimateText(use, script.Parent.Frame, 0.04, Enum.Font.Arial, "fade diverge", 1, nil, nil, nil, nil)
wait(3)
SwagText.ClearText(script.Parent.Frame)
SwagText.AnimateText("long bunch of text thats quick because i  havent implemented instant text yet, but soon", script.Parent.Frame, 0)