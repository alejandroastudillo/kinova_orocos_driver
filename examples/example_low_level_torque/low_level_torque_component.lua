require("rttlib")
require("math")

--This component generates a sine wave for joint velocities

tc=rtt.getTC()



measured_angles = rtt.InputPort("array", "measured_angles")
tc:addPort(measured_angles)

measured_velocities = rtt.InputPort("array", "measured_velocities")
tc:addPort(measured_velocities)

measured_torques = rtt.InputPort("array", "measured_torques")
tc:addPort(measured_torques)

desired_torques = rtt.OutputPort("array", "desired_torques")
tc:addPort(desired_torques)

sent_setpoints = rtt.InputPort("array", "sent_setpoints")
tc:addPort(sent_setpoints)


local joint_setpoints=rtt.Variable("array")

function configureHook()
    return true
end

function startHook()

    return true
end

time = 0
frequency = 0.2
amplitud = 3 --6 N.m

function updateHook()

    torque = math.sin(2*math.pi*frequency*time )*amplitud
    mytab = {0,0,0,0,0,0,torque} --For torques

    joint_setpoints:fromtab(mytab)
    desired_torques:write(joint_setpoints)
    
    time = time + tc:getPeriod()
    
    local fs,val= measured_angles:read()
    myTable = val:totab()
    -- -- for k,v in pairs(myTable) do
    -- --   print("actuator  #" .. k .. "    value:  " .. round(v*180/math.pi,1) )
    -- -- end

    local fs,val_vel= measured_velocities:read()
    myTable_vel = val_vel:totab()

    local fs,val_tor= measured_torques:read()
    myTable_tor = val_tor:totab()
    -- print("a7 - tau:  " .. myTable_tor[7])

    print("actuator 7 - tau:  " .. round(myTable_tor[7],4) .. " - q: " ..  round(myTable[7],4)  .. " - q_dot: " ..  round(myTable_vel[7],4) )

    -- local fs,val_set= sent_setpoints:read()
    -- myTable_set = val_set:totab()
    -- -- print("actuator #7 - setpoint:  " .. myTable_set[7])

    -- print("a7 - tau:  " .. myTable_tor[7] .. ",   setpoint:  " .. myTable_set[7])
end


function cleanupHook()

end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end