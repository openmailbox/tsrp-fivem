local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    --local model = GetHashKey('prop_paper_bag_01')
    --local loc   = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId())

    --RequestModel(model)

    --while not HasModelLoaded(model) do
    --    Citizen.Wait(10)
    --end

    --print("creating at " .. loc)
    --CreateObject(model, loc, true, false, false)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
