Exports = {}

function Exports.start_session(options)
    TriggerEvent(Events.CREATE_SHOWROOM_SESSION, options)
end
exports("StartSession", Exports.start_session)
