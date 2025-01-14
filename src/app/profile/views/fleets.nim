import NimQml, json
import chronicles, strutils
import ../../../status/types as status_types
import ../../../status/[status, settings, accounts]

QtObject:
  type Fleets * = ref object of QObject
    status: Status

  proc setup(self: Fleets) =
    self.QObject.setup

  proc delete*(self: Fleets) =
    self.QObject.delete

  proc newFleets*(status: Status): Fleets =
    new(result, delete)
    result = Fleets()
    result.status = status
    result.setup

  proc fleetChanged*(self: Fleets, newFleet: string) {.signal.}

  proc triggerFleetChange*(self: Fleets) {.slot.} =
    self.fleetChanged($self.status.settings.getFleet())

  proc setFleet*(self: Fleets, newFleet: string) {.slot.} =
    let fleet = parseEnum[Fleet](newFleet)
    let statusGoResult = self.status.settings.setFleet(self.status.fleet.config, fleet)
    if statusGoResult.error != "":
      error "Error saving updated node config", msg=statusGoResult.error

    let isWakuV2 = if fleet == WakuV2Prod or fleet == WakuV2Test: true else: false
    # Updating waku version because it makes no sense for some fleets to run under wakuv1 or v2 config
    if isWakuV2:
      self.status.settings.setWakuVersion(2)
    else:
      self.status.settings.setWakuVersion(1)
    
    self.fleetChanged(newFleet)
    quit(QuitSuccess) # quits the app TODO: change this to logout instead when supported

  proc getFleet*(self: Fleets): string {.slot.} = $self.status.settings.getFleet()

  QtProperty[string] fleet:
    read = getFleet
    notify = fleetChanged
