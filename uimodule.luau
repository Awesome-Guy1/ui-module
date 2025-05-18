local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer.PlayerGui

local Libs = ReplicatedStorage.Libs

local PickRandom = require(Libs.PickRandom)
local DeepCopyTable = require(Libs.DeepCopyTable)

local UISounds = SoundService.UI

local Open = UISounds.Open
local Close = UISounds.Close
local Switch = UISounds.Switch

local UiModule = {}

UiModule.__index = UiModule

export type Tab = TextButton

export type Window = Frame & {
	Close: GuiButton
}

export type TabWindow = Window & {Frame | ScrollingFrame} & {
	Tabs: Frame & {Tab}
}


function UiModule.new(): typeof(UiModule)
	
	local new = setmetatable({}, UiModule)
	
	new.config = {
		["window"] = {
			tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back),
			open =  UDim2.new(0.5, 0, 0.5, 0),
			close = UDim2.new(0.5, 0, -1, 0),
		},
		["button"] = {
			buttonInfo = TweenInfo.new(1, Enum.EasingStyle.Back),
		}
	}
	
	return new
	
end

function UiModule:IntializeButton(button: GuiButton)
	
	if button:GetAttribute("Intialize") then
		return
	end
	
	button:SetAttribute("Intialize", true)
	
	local TargetSize = button.Size
	local debounce = false
	local CurrentTween
	
	local hovering = false
	
	local function pressed(x, y)

		if debounce == true then
			CurrentTween:Cancel()
		end

		debounce = true

		TargetSize = TargetSize - UDim2.new(0, 10, 0, 10)
		local PressedTween = TweenService:Create(button, self.config.button.buttonInfo,{Size = TargetSize})

		PressedTween.Completed:Once(function(playbackState)
			if playbackState == Enum.PlaybackState.Cancelled then
				button.Size = TargetSize
			else
				debounce = false
			end
		end)

		PressedTween:Play()
		CurrentTween = PressedTween
	end
	
	local function unpressed(x, y)

		if debounce == true then
			CurrentTween:Cancel()
		end

		debounce = true

		TargetSize = TargetSize + UDim2.new(0, 10, 0, 10)
		local UnpressedTween = TweenService:Create(button, self.config.button.buttonInfo,{Size = TargetSize})

		UnpressedTween.Completed:Once(function(playbackState)
			if playbackState == Enum.PlaybackState.Cancelled then
				button.Size = TargetSize
			else
				debounce = false
			end
		end)

		UnpressedTween:Play()
		CurrentTween = UnpressedTween
	end
	
	local function enter(x, y)

		if debounce == true then
			CurrentTween:Cancel()
		end

		debounce = true

		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			pressed(x, y)
		end

		TargetSize = TargetSize + UDim2.new(0, 5, 0, 5)
		local EnterTween = TweenService:Create(button, self.config.button.buttonInfo,{Size = TargetSize})

		EnterTween.Completed:Once(function(playbackState)
			if playbackState == Enum.PlaybackState.Cancelled then
				button.Size = TargetSize
			else
				debounce = false
			end
		end)

		EnterTween:Play()
		CurrentTween = EnterTween
	end
	
	local function unenter(x, y)

		if debounce == true then
			CurrentTween:Cancel()
		end

		debounce = true
		
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			unpressed(x, y)
		end

		TargetSize = TargetSize - UDim2.new(0, 5, 0, 5)
		local UnenterTween = TweenService:Create(button, self.config.button.buttonInfo,{Size = TargetSize})

		UnenterTween.Completed:Once(function(playbackState)
			if playbackState == Enum.PlaybackState.Cancelled then
				button.Size = TargetSize
			else
				debounce = false
			end
		end)

		UnenterTween:Play()
		CurrentTween = UnenterTween
	end

	button.MouseEnter:Connect(enter)
	button.MouseLeave:Connect(unenter)
	button.MouseButton1Down:Connect(pressed)
	button.MouseButton1Up:Connect(unpressed)
end


function UiModule:IsWindowVisible(window: Window | Frame)

	if window.Position == self.config.window.open then
		return true
	elseif window.Position == self.config.window.close then
		return false
	else
		return true
	end
end


function UiModule:CloseWindow(window: Window | Frame)
	
	local close = TweenService:Create(window, self.config.window.tweenInfo, {["Position"] = self.config.window.close})
	close:Play()
	PickRandom(Close:GetChildren()):Play()
end

function UiModule:CloseAllWindows()
	for i, v in ipairs(PlayerGui.Main:GetChildren()) do
		
		if v:GetAttribute("Window") == true then
			
			if self:IsWindowVisible(v) == true then
				self:CloseWindow(v)
			end
			
		end
		
	end
end

function UiModule:OpenWindow(window: Window | Frame)
	
	if window:GetAttribute("Window") == true then
		self:CloseAllWindows()
	end
	
	local open = TweenService:Create(window, self.config.window.tweenInfo, {["Position"] = self.config.window.open})
	open:Play()
	PickRandom(Open:GetChildren()):Play()
end

function UiModule:ToggleWindow(window: Window | Frame)

	local visible = self:IsWindowVisible(window)

	if visible then
		self:CloseWindow(window)
	else
		self:OpenWindow(window)
	end
end

function UiModule:IntializeWindow(window: Window)
	
	window:SetAttribute("Window", true)
	
	self:IntializeButton(window.Close)

	window.Close.MouseButton1Click:Connect(function()
		self:CloseWindow(window)
	end)
	
end

function UiModule:IntializeWindowButton(window: Window, button: GuiButton)

	self:IntializeButton(button)

	button.MouseButton1Click:Connect(function()
		self:ToggleWindow(window)
	end)
end

function UiModule:IntializeTabWindow(window: TabWindow, CurrentTab: Tab)
	
	self:IntializeWindow(window)
	
	local Tabs = window.Tabs
	
	for i, frame in ipairs(window:GetChildren()) do
		if frame.Name ~= "Tabs" and frame:IsA("Frame") or frame:IsA("ScrollingFrame") then
			frame.Visible = false
		end
	end
	
	window[CurrentTab.Name .. "List"].Visible = true
	
	for i, tab in ipairs(Tabs:GetChildren()) do
		if tab:IsA("TextButton") then
			tab.MouseButton1Click:Connect(function()

				PickRandom(Switch:GetChildren()):Play()

				CurrentTab = tab

				for i, frame in ipairs(window:GetChildren()) do
					if frame.Name ~= "Tabs" and frame:IsA("Frame") or frame:IsA("ScrollingFrame") then
						frame.Visible = false
					end
				end

				window[CurrentTab.Name .. "List"].Visible = true
			end)
		end
	end
	
end

return UiModule
