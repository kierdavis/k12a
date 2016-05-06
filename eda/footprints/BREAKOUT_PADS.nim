import k12a.eda.footprintdsl

var element = Element(
  flags: {},
  description: "Two rows of 8 breakout pads",
  markPosition: fromMils(400, 100),
  namePosition: fromMils(-350, -160),
  nameRotation: 0,
  nameScale: 100,
  nameFlags: {},
  children: @[],
)

let pinDrillDiameter = fromMM(0.8) # 22AWG hook-up wire is just over 0.6mm diameter
let pinMetalDiameter = pinDrillDiameter + 2*fromMM(0.2)
let pinMaskDiameter = pinMetalDiameter + 2*fromMM(0.1)

let traceMetalThickness = fromMils(15)
let traceMaskThickness = traceMetalThickness + 2*fromMM(0.1)

for i in 0..7:
  let x = fromMils((float(i) - 3.5) * 100)
  let number = $i
  let name = "pin" & number
  let nearPin = Pin(
    centerPos: (x: x, y: fromMils(50)),
    metalDiameter: pinMetalDiameter,
    clearance: fromMils(30),
    maskDiameter: pinMaskDiameter,
    drillDiameter: pinDrillDiameter,
    name: name,
    number: number,
    flags: {},
  ).addTo(element)
  let farPin = Pin(
    centerPos: (x: x, y: fromMils(-50)),
    metalDiameter: pinMetalDiameter,
    clearance: fromMils(30),
    maskDiameter: pinMaskDiameter,
    drillDiameter: pinDrillDiameter,
    name: name,
    number: number,
    flags: {},
  ).addTo(element)
  let interconnectOffset = (x: fromMils(0), y: nearPin.drillDiameter / 2)
  #discard Pad(
  #  pos1: nearPin.centerPos - interconnectOffset,
  #  pos2: farPin.centerPos + interconnectOffset,
  #  metalThickness: traceMetalThickness,
  #  clearance: fromMils(30),
  #  maskThickness: traceMaskThickness,
  #  name: name,
  #  number: number,
  #  flags: {}
  #).addTo(element)

dump element
