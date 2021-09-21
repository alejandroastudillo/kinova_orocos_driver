require("rttlib")
require("math")

--This component generates a sine wave for joint velocities

tc=rtt.getTC()



measured_angles = rtt.InputPort("array", "measured_angles")
tc:addPort(measured_angles)

measured_velocities = rtt.InputPort("array", "measured_velocities")
tc:addPort(measured_velocities)

desired_velocities = rtt.OutputPort("array", "desired_velocities")
tc:addPort(desired_velocities)

local joint_setpoints=rtt.Variable("array")

function configureHook()
    return true
end

function startHook()

    return true
end

time = 0
frequency = 0.2
amplitud = 20*math.pi/180 --Radians
-- amplitud = 1.22 --Radians
function updateHook()

angle = math.sin(2*math.pi*frequency*time )*amplitud
-- angle = math.cos(2*math.pi*frequency*time )*amplitud*2*math.pi*frequency
mytab = {0,0,0,0,0,0,angle} --For velocities
-- mytab = {0,0,0,0,0,0,2*math.pi/180} --For velocities

joint_setpoints:fromtab(mytab)
desired_velocities:write(joint_setpoints)
time = time + tc:getPeriod()

    --Uncomment for printing the measured angles in the terminal:
    -- local fs,val= measured_angles:read()
    -- myTable = val:totab()
    -- for k,v in pairs(myTable) do
    --   print("actuator  #" .. k .. "    value:  " .. round(v*180/math.pi,1) )
    -- end

    local fs,val_vel= measured_velocities:read()
    myTable_vel = val_vel:totab()
    print("actuator  #7 des_vel: " .. round(angle,3) .. ",   act_vel:  " .. round(myTable_vel[7],3) )

end


function cleanupHook()

end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
