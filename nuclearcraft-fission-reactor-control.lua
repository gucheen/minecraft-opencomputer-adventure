local component = require('component')
local event = require('event')
local reactor = component.nc_fission_reactor
local reactorMaxEnergy = reactor.getMaxEnergyStored()

function checkReactorEnergyStored()
  local storeLevel = reactor.getEnergyStored() / reactorMaxEnergy
  local isProcessing = reactor.isProcessing()
  local hasFuel = reactor.getCurrentProcessTime() > 0
  if isProcessing then
    if storeLevel > 0.85 then
      print(string.format('%s | deactivate reactor', os.date()))
      reactor.deactivate()
    end
  else
    if storeLevel < 0.2 and hasFuel then
      print(string.format('%s | activate reactor', os.date()))
      reactor.activate()
    end
  end
end
 
repeat
  checkReactorEnergyStored()
until event.pull(1) == "interrupted"
