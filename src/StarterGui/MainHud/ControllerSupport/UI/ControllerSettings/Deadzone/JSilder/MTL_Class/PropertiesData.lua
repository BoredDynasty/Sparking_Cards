local Main = script.Parent.Parent
local Properties = {
	GetPropertiesDataModuleRoot = function()
		return script
	end;
	PropertieName = {
		Properties = {
			"ClassName";
			"Parent";
			"Name";
			"AbsolutePosition";
			"AbsoluteSize";
			"AnchorPoint";
			"Visible";
			"Size";
			"Position";
			"SilderBackgroundColor3";
			"SilderColor3";
			"SilderValue";
			"SilderMax";
			"SilderIntOnly";
			"SilderGrid";
			"SilderGridColor3";
			"ValueLabelVisible";
			"ValueLabelTextColor3";
			"ValueLabelMultiply";
		};
		Event = {
			"MouseClickEvent";
		};
	};
	PropertieType = {
		ClassName="string";
		Parent="Instance";
		Name="string";
		AbsolutePosition="Vector2"; 
		AbsoluteSize="Vector2";
		AnchorPoint="Vector2";
		Visible="boolean";
		SilderBackgroundColor3="Color3";
		SilderColor3="Color3";
		SilderValue="number";
		SilderMax="number";
		SilderIntOnly="boolean";
		SilderGrid="boolean";
		SilderGridColor3="Color3";
		ValueLabelVisible="boolean";
		ValueLabelTextColor3="Color3";
		ValueLabelMultiply="number";
	};
	ReadOnry = {
		"ClassName";
		"AbsolutePosition";
		"AbsoluteSize";
	};
	StyleList = {
		"Contained";
		"Outlined";
		"Text";
	};
	ClassName = function()
		return script.Parent.Value -- Read Onry data
	end;
	Parent = function(Value)
		if Value == nil then
			return Main.Parent --Read
		else
			Main.Parent = Value --write
		end
	end;
	Name = function(Value)
		if Value == nil then
			return Main.Name
		else
			Main.Name = Value
		end
	end;
	AbsolutePosition = function(Value)
		return Main.AbsolutePosition
	end;
	AbsoluteSize = function(Value)
		return Main.AbsoluteSize
	end;
	AnchorPoint = function(Value)
		if Value == nil then
			return Main.AnchorPoint
		else
			Main.AnchorPoint = Value
		end
	end;
	Visible = function(Value)
		if Value == nil then
			return Main.Visible
		else
			Main.Visible = Value
		end
	end;
	Size = function(Value)
		if Value == nil then
			return Main.Size
		else
			Main.Size = Value
		end
	end;
	Position = function(Value)
		if Value == nil then
			return Main.Position
		else
			Main.Position = Value
		end
	end;
	SilderBackgroundColor3 = function(Value)
		if Value == nil then
			return Main.BackgroundColor3
		else
			Main.BackgroundColor3 = Value
		end
	end; 
	SilderColor3 = function(Value)
		if Value == nil then
			return Main.Back.BackgroundColor3
		else
			Main.Back.BackgroundColor3 = Value
			Main.Point.ImageColor3 = Value
			Main.Point.MouseDown.ImageColor3 = Value
			Main.Point.MouseOn.ImageColor3 = Value
			Main.Point.ValueLabel.ImageColor3 = Value
		end
	end;
	SilderValue = function(Value)
		if Value == nil then
			return Main.Value.Value
		else
			Main.Value.Value = Value
		end
	end;
	SilderMax = function(Value)
		if Value == nil then
			return Main.Max.Value
		else
			Main.Max.Value = Value
		end
	end;
	SilderIntOnly = function(Value)
		if Value == nil then
			return Main.IntOnly.Value
		else
			Main.IntOnly.Value = Value
		end
	end;
	SilderGrid = function(Value)
		if Value == nil then
			return Main.Grid.Value
		else
			Main.Grid.Value = Value
		end
	end;
	SilderGridColor3 = function(Value)
		if Value == nil then
			return Main.GridColor3.Value
		else
			Main.GridColor3.Value = Value
		end
	end;
	ValueLabelVisible = function(Value)
		if Value == nil then
			return Main.ValueLabel.Value
		else
			Main.ValueLabel.Value = Value
		end
	end;
	ValueLabelTextColor3 = function(Value)
		if Value == nil then
			return Main.Point.ValueLabel.Text.TextColor3
		else
			Main.Point.ValueLabel.Text.TextColor3 = Value
		end
	end;
	ValueLabelMultiply = function(Value)
		if Value == nil then
			return Main.ValueLabelMultiply.Value
		else
			Main.ValueLabelMultiply.Value = Value
		end
	end;
}
return Properties
