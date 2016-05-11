import k12a.eda.footprintdsl

let pinOffset = fromMils(75)

let pinDrillDiameter = fromMM(0.8) # 22AWG hook-up wire is just over 0.6mm diameter
let pinMetalDiameter = pinDrillDiameter + 2*fromMils(16)
let pinMaskDiameter = pinMetalDiameter + 2*fromMils(3)

var element = Element(
  flags: {},
  description: "Power connector pads",
  markPosition: fromMils(200, 200),
  namePosition: (x: -pinOffset, y: fromMils(50)),
  nameRotation: 0,
  nameScale: 100,
  nameFlags: {},
  children: @[],
)

discard Pin(
  centerPos: (x: -pinOffset, y: fromMils(0)),
  metalDiameter: pinMetalDiameter,
  clearance: fromMils(30),
  maskDiameter: pinMaskDiameter,
  drillDiameter: pinDrillDiameter,
  name: "VCC",
  number: "1",
  flags: {},
).addTo(element)

discard Pin(
  centerPos: (x: pinOffset, y: fromMils(0)),
  metalDiameter: pinMetalDiameter,
  clearance: fromMils(30),
  maskDiameter: pinMaskDiameter,
  drillDiameter: pinDrillDiameter,
  name: "GND",
  number: "2",
  flags: {},
).addTo(element)

discard Line(
  pos1: (x: pinOffset - fromMils(20), y: -pinOffset),
  pos2: (x: pinOffset + fromMils(20), y: -pinOffset),
  thickness: fromMil(10),
).addTo(element)

discard Line(
  pos1: (x: -pinOffset - fromMils(20), y: -pinOffset),
  pos2: (x: -pinOffset + fromMils(20), y: -pinOffset),
  thickness: fromMil(10),
).addTo(element)

discard Line(
  pos1: (x: -pinOffset, y: -pinOffset - fromMils(20)),
  pos2: (x: -pinOffset, y: -pinOffset + fromMils(20)),
  thickness: fromMil(10),
).addTo(element)

dump element
