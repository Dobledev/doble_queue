local maxPlayers = 2025  -- Cambia esto al límite de tu servidor
local queue = {}

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    Wait(0)
    deferrals.update("⌛ Conectando...")

    local playersCount = #GetPlayers()
    
    -- Si no hay cola y hay espacio en el servidor
    if #queue == 0 and playersCount < maxPlayers then
        table.insert(queue, {id = src, name = name, deferrals = deferrals})
        Wait(5000)
        deferrals.done()
        table.remove(queue, 1)
        return
    end

    -- Si hay cola o el servidor está lleno
    table.insert(queue, {id = src, name = name, deferrals = deferrals})

    while true do
        Wait(1000)

        playersCount = #GetPlayers()
        if queue[1] and queue[1].id == src and playersCount < maxPlayers then
            deferrals.done()
            table.remove(queue, 1)
            break
        else
            deferrals.update("⌛ Conectando... Posición en cola: " .. getPositionInQueue(src))
        end
    end
end)

function getPositionInQueue(playerId)
    for i, player in ipairs(queue) do
        if player.id == playerId then
            return i
        end
    end
    return -1
end
