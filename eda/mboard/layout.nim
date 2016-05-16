import pcb.manip
import pcb.parse
import pcb.stringify
import pcb.types

var pcb = parseStdin()

# Set metadata
pcb.name = "mboard"

# Set board dimensions
const width = 10.cm()
const height = 10.cm()
pcb.width = width
pcb.height = height

# Set grid size
pcb.grid.step = 25.mil().float()

# Set up layers
assert pcb.layers.len() == 10
pcb.groups = "1,c:2:3:4:5:6,s:7:8"
pcb.layers[0].name = "top"
pcb.layers[1].name = "ground (unused)"
pcb.layers[2].name = "signal2 (unused)"
pcb.layers[3].name = "signal3 (unused)"
pcb.layers[4].name = "power (unused)"
pcb.layers[5].name = "bottom"
pcb.layers[6].name = "outline"
pcb.layers[7].name = "spare"
pcb.layers[8].name = "silk"
pcb.layers[9].name = "silk"
const topLayer = 1
const bottomLayer = 6

# Move DIP16 items into position
const midX = width / 2
const midY = height / 2
const dipWidth = 700.mil()
const dipHeight = 300.mil()
const dipHozSeparation = 150.mil()
const dipVertSeparation = 600.mil()
const dipAnchorsX = [
  midX - dipHozSeparation/2 - dipWidth - dipHozSeparation - dipWidth,
  midX - dipHozSeparation/2 - dipWidth,
  midX + dipHozSeparation/2,
  midX + dipHozSeparation/2 + dipWidth + dipHozSeparation,
]
const dipAnchorsY = [
  midY - dipVertSeparation/2 - dipHeight - dipVertSeparation,
  midY - dipVertSeparation/2,
  midY + dipVertSeparation/2 + dipHeight,
  midY + dipVertSeparation/2 + dipHeight + dipVertSeparation + dipHeight,
]
for i in 0 .. 15:
  let elementName = "U" & $(i + 1) & "/CONN3"
  pcb.mfindElement(elementName).flags.incl(ofHideName)
  pcb.mfindElement(elementName).rotateCCW()
  pcb.mfindElement(elementName).markPos = (
    x: dipAnchorsX[i mod 4],
    y: dipAnchorsY[i div 4],
  )

# Move upper breakout pins into position
for i in 0 .. 15:
  let elementName = "U" & $(i + 1) & "/CONN1"
  pcb.mfindElement(elementName).flags.incl(ofHideName)
  pcb.mfindElement(elementName).markPos = (
    x: dipAnchorsX[i mod 4] + dipWidth/2,
    y: dipAnchorsY[i div 4] - dipHeight - 150.mil(),
  )

# Move lower breakout pins into position
for i in 0 .. 15:
  let elementName = "U" & $(i + 1) & "/CONN2"
  pcb.mfindElement(elementName).flags.incl(ofHideName)
  pcb.mfindElement(elementName).rotate180()
  pcb.mfindElement(elementName).markPos = (
    x: dipAnchorsX[i mod 4] + dipWidth/2,
    y: dipAnchorsY[i div 4] + 150.mil(),
  )

# Move decoupling capacitors into position
const dcapAnchorsX = [
  dipAnchorsX[0] - 200.mil(),
  dipAnchorsX[3] + dipWidth + 200.mil(),
]
for i in 0 .. 7:
  let elementName = "C" & $(i + 1)
  pcb.mfindElement(elementName).textPos.x -= 50.mil()
  pcb.mfindElement(elementName).rotateCW()
  pcb.mfindElement(elementName).markPos = (
    x: dcapAnchorsX[i div 4],
    y: dipAnchorsY[i mod 4] - 200.mil(),
  )

# Move power LED assembly into position
const powerLedAnodeAnchor = (
  x: dipAnchorsX[3] - dipHozSeparation/2 - 50.mil(),
  y: height - 125.mil(),
)
pcb.mfindElement("LED1").textPos.x += 200.mil()
pcb.mfindElement("R1").textPos.y -= 50.mil()
pcb.mfindElement("LED1").markPos = powerLedAnodeAnchor
pcb.mfindElement("R1").markPos = powerLedAnodeAnchor - (x: 500.mil(), y: 0.mil())

# Move power connectors into position
pcb.mfindElement("CONN1").markPos = (x: midX, y: 100.mil())
pcb.mfindElement("CONN2").rotateCCW()
pcb.mfindElement("CONN2").markPos = (x: 100.mil(), y: midY)
pcb.mfindElement("CONN3").rotate180()
pcb.mfindElement("CONN3").markPos = (x: midX, y: height - 100.mil())
pcb.mfindElement("CONN4").rotateCW()
pcb.mfindElement("CONN4").markPos = (x: width - 100.mil(), y: midY)

# Set up ground and power planes
pcb.mfindLayer("bottom").polygons.add((
  flags: {ofClearPoly},
  vertices: @[
    (x: Dimension(0), y: Dimension(0)),
    (x: width, y: Dimension(0)),
    (x: width, y: height),
    (x: Dimension(0), y: height),
  ],
))
pcb.mfindLayer("top").polygons.add((
  flags: {ofClearPoly},
  vertices: @[
    (x: Dimension(0), y: Dimension(0)),
    (x: width, y: Dimension(0)),
    (x: width, y: height),
    (x: Dimension(0), y: height),
  ],
))

proc drawTrack(point1, point2: Vector) =
  pcb.mfindLayer("bottom").lines.add((
    point1: point1,
    point2: point2,
    thickness: 16.mil(),
    clearance: 30.mil(),
    flags: {ofClearLine},
  ))

# Draw tracks connecting the DIP sockets to the breakout pins
for i in 0 .. 15:
  for j in 0 .. 7:
    let x = dipAnchorsX[i mod 4] + j * 100.mil()
    let yBottom = dipAnchorsY[i div 4]
    let yTop = yBottom - dipHeight
    if j != 0:
      drawTrack((x: x, y: yTop), (x: x, y: yTop - 200.mil()))
    if j != 7:
      drawTrack((x: x, y: yBottom), (x: x, y: yBottom + 200.mil()))

# Draw a track connecting the power LED with its resistor
drawTrack(powerLedAnodeAnchor, powerLedAnodeAnchor - (x: 100.mil(), y: 0.mil()))

# Add thermals to DIP16s and breakout pins
for i in 1 .. 16:
  for pin in pcb.mfindElement("U" & $i & "/CONN3").pins.mitems():
    if pin.number == "8":
      pin.thermals.add(bottomLayer)
    if pin.number == "16":
      pin.thermals.add(topLayer)
  for pin in pcb.mfindElement("U" & $i & "/CONN2").pins.mitems():
    if pin.number == "1":
      pin.thermals.add(bottomLayer)
  for pin in pcb.mfindElement("U" & $i & "/CONN1").pins.mitems():
    if pin.number == "1":
      pin.thermals.add(topLayer)

# Add thermals to decoupling caps
for i in 1 .. 8:
  for pin in pcb.mfindElement("C" & $i).pins.mitems():
    if pin.number == "1":
      pin.thermals.add(topLayer)
    if pin.number == "2":
      pin.thermals.add(bottomLayer)

# Add thermals to power connectors
for i in 1 .. 4:
  for pin in pcb.mfindElement("CONN" & $i).pins.mitems():
    if pin.number == "1":
      pin.thermals.add(topLayer)
    if pin.number == "2":
      pin.thermals.add(bottomLayer)

# Add thermals to power LED assembly
for pin in pcb.mfindElement("R1").pins.mitems():
  if pin.number == "1":
    pin.thermals.add(topLayer)
for pin in pcb.mfindElement("LED1").pins.mitems():
  if pin.number == "2":
    pin.thermals.add(bottomLayer)

echo $pcb
