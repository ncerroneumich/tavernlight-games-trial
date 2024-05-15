# Q7 - Nickolas Cerrone

<h3>Video Demo</h3>

https://github.com/ncerroneumich/tavernlight-games-trial/assets/97428535/1b71135b-b555-4ff0-8a25-34d63b4c1070
<h3>Overview</h3>

To reproduce the UI game shown in the video I created an OTClient module. After inspecting the other modules that came with OTClient and the provided video, I felt I had a good enough understanding to begin work on the game. In order to produce a psuedo update loop, I create a cycle event that gets called at a set interval. I had a really great experience experimenting with everything OTClient modules can do. When I got the game to work it was quite satisfying! Shown below it the script that handles all game logic. All module files can be found in the module folder.

<h3>Game Script</h3>


```Lua
-- UI Variables
local jumpWindow = nil
local topMenuJumpWindowButton = nil
local jumpButton = nil

-- Margin Variables
local rightMarginLowerBound = 10
local rightMarginUpperBound = nil
local currentRightMargin = 10
local rightMarginIncrement = 10
local bottomMarginLowerBound = 10
local bottomMarginUpperBound = nil
local marginClipBuffer = 50 -- Used to avoid button clipping outside of the window

-- Event Variables
local eventCycleMs = 100
local scheduledEvent = nil

function init()
  connect(g_game, { onGameStart = online,
                    onGameEnd   = offline })

  -- Load in UI elements from OTUI file and sets them as the child of the right panel
  jumpWindow = g_ui.displayUI('jump_window', modules.game_interface.getRightPanel())
  jumpWindow:hide()

  -- Add toggle button in client UI
  topMenuJumpWindowButton = modules.client_topmenu.addRightGameToggleButton('topMenuJumpWindowButton', tr('Jump Window'), '/images/game/minimap/cross', toggle)
  
  topMenuJumpWindowButton:setOn(false)

  jumpButton = jumpWindow:getChildById('buttonJump')

  -- Calculate margin bounds to prevent clipping outside the window
  rightMarginUpperBound = jumpWindow:getWidth() - jumpButton:getWidth() - marginClipBuffer
  bottomMarginUpperBound = jumpWindow:getHeight() - jumpButton:getHeight() - marginClipBuffer 
  
  if g_game.isOnline() then
    online()
  end

end

function terminate()
  disconnect(g_game, { onGameStart = online,
                       onGameEnd   = offline })

  -- Clean up UI elements
  jumpWindow:destroy()
  topMenuJumpWindowButton:destroy()
end

function online()
  topMenuJumpWindowButton:show()

  -- Call moveButton function on a timed cycle
  scheduledEvent = cycleEvent(moveButton, eventCycleMs)
end

function offline()
  jumpWindow:hide()
  topMenuJumpWindowButton:setOn(false)

  -- End button movement event when the game goes offline
  RemoveEvent(scheduledEvent)
end

function toggle()
  -- Toggle the UI panel on and off
  if topMenuJumpWindowButton:isOn() then
    topMenuJumpWindowButton:setOn(false)
    jumpWindow:hide()
  else
    topMenuJumpWindowButton:setOn(true)
    jumpWindow:show()
    jumpWindow:raise()
    jumpWindow:focus()
  end
end

function moveButton()
  -- Increment button position and reset button 
  -- margin if it would exit the window area
  if currentRightMargin + rightMarginIncrement > rightMarginUpperBound then
    resetButtonHorizontalPosition()
    setButtonHeightRandom() 
  else
    currentRightMargin = currentRightMargin + rightMarginIncrement
    jumpButton:setMarginRight(currentRightMargin)
  end

end

function setButtonHeightRandom() 
  local randomMargin = math.random(bottomMarginLowerBound, bottomMarginUpperBound)
  jumpButton:setMarginBottom(randomMargin)
end

function resetButtonHorizontalPosition()
  currentRightMargin = rightMarginLowerBound
  jumpButton:setMarginRight(currentRightMargin)
end

function onJumpButtonClick()
  -- Reset the horizontal and vertical position of the button
  setButtonHeightRandom() 
  resetButtonHorizontalPosition()
end
```
