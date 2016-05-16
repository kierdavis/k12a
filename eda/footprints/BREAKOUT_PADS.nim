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

let pinDrillDiameter = fromMils(28) # 22AWG hook-up wire is just over 0.6mm diameter
let pinMetalDiameter = pinDrillDiameter + 2*fromMils(16)
let pinMaskDiameter = pinMetalDiameter + 2*fromMils(3)

for i in 0..7:
  let x = fromMils((float(i) - 3.5) * 100)
  let number = $(i + 1)
  let name = "pin" & number
  discard Pin(
    centerPos: (x: x, y: fromMils(50)),
    metalDiameter: pinMetalDiameter,
    clearance: fromMils(30),
    maskDiameter: pinMaskDiameter,
    drillDiameter: pinDrillDiameter,
    name: name,
    number: number,
    flags: {},
  ).addTo(element)
  discard Pin(
    centerPos: (x: x, y: fromMils(-50)),
    metalDiameter: pinMetalDiameter,
    clearance: fromMils(30),
    maskDiameter: pinMaskDiameter,
    drillDiameter: pinDrillDiameter,
    name: name,
    number: number,
    flags: {},
  ).addTo(element)

dump element
