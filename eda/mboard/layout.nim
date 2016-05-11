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
pcb.groups = "1,c:6,s:7:8"
pcb.layers = @[
  initLayer(),
  initLayer(),
  initLayer(),
  initLayer(),
  initLayer(),
  initLayer(),
]
pcb.layers[0].number = 1
pcb.layers[0].name = "top"
pcb.layers[1].number = 6
pcb.layers[1].name = "bottom"
pcb.layers[2].number = 7
pcb.layers[2].name = "outline"
pcb.layers[3].number = 8
pcb.layers[3].name = "spare"
pcb.layers[4].number = 9
pcb.layers[4].name = "silk"
pcb.layers[5].number = 10
pcb.layers[5].name = "silk"

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
  pcb.mfindElement(elementName).rotateCCW()
  pcb.mfindElement(elementName).markPos = (
    x: dipAnchorsX[i mod 4],
    y: dipAnchorsY[i div 4],
  )

# Move upper breakout pins into position
for i in 0 .. 15:
  let elementName = "U" & $(i + 1) & "/CONN1"
  pcb.mfindElement(elementName).markPos = (
    x: dipAnchorsX[i mod 4] + dipWidth/2,
    y: dipAnchorsY[i div 4] - dipHeight - 150.mil(),
  )

# Move lower breakout pins into position
for i in 0 .. 15:
  let elementName = "U" & $(i + 1) & "/CONN2"
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

proc drawTrack(point1, point2: Vector) =
  pcb.mfindLayer("bottom").lines.add((
    point1: point1,
    point2: point2,
    thickness: 16.mil(),
    clearance: 30.mil(),
    flags: {},
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

echo $pcb
