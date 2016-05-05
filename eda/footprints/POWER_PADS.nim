import k12a.eda.footprintdsl

let pinOffset = fromMils(75)

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
  metalDiameter: fromMM(1.2),
  clearance: fromMils(30),
  maskDiameter: fromMM(1.4),
  drillDiameter: fromMM(0.8),
  name: "VCC",
  number: "1",
  flags: {},
).addTo(element)

discard Pin(
  centerPos: (x: pinOffset, y: fromMils(0)),
  metalDiameter: fromMM(1.2),
  clearance: fromMils(30),
  maskDiameter: fromMM(1.4),
  drillDiameter: fromMM(0.8),
  name: "GND",
  number: "2",
  flags: {},
).addTo(element)

discard Line(
  pos1: (x: pinOffset - fromMils(20), y: -pinOffset),
  pos2: (x: pinOffset + fromMils(20), y: -pinOffset),
  thickness: fromMM(0.2),
).addTo(element)

discard Line(
  pos1: (x: -pinOffset - fromMils(20), y: -pinOffset),
  pos2: (x: -pinOffset + fromMils(20), y: -pinOffset),
  thickness: fromMM(0.2),
).addTo(element)

discard Line(
  pos1: (x: -pinOffset, y: -pinOffset - fromMils(20)),
  pos2: (x: -pinOffset, y: -pinOffset + fromMils(20)),
  thickness: fromMM(0.2),
).addTo(element)

dump element
