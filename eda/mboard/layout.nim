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

echo $pcb
