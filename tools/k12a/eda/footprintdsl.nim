import ropes, parseopt2

type
  Dimension* = distinct int
  
  Vector* = tuple
    x, y: Dimension
  
  Flag* = enum
    flagPin
    flagVia
    flagHole
    flagShowName
    flagOnSolder
    flagSquare
    flagOctagon
    flagEdge2
  
  Pad* = object
    pos1*: Vector
    pos2*: Vector
    metalThickness*: Dimension
    clearance*: Dimension
    maskThickness*: Dimension
    name*: string
    number*: string
    flags*: set[Flag]
  
  Pin* = object
    centerPos*: Vector
    metalDiameter*: Dimension
    clearance*: Dimension
    maskDiameter*: Dimension
    drillDiameter*: Dimension
    name*: string
    number*: string
    flags*: set[Flag]
  
  Line* = object
    pos1*: Vector
    pos2*: Vector
    thickness*: Dimension  
  
  Arc* = object
    centerPos*: Vector
    hozRadius*: Dimension
    vertRadius*: Dimension
    startAngle*: int
    sweepAngle*: int
    thickness*: Dimension
  
  ElementItemKind* = enum
    elementItemPad
    elementItemPin
    elementItemLine
    elementItemArc
  
  ElementItem* = object
    case kind*: ElementItemKind
    of elementItemPad:
      pad*: Pad
    of elementItemPin:
      pin*: Pin
    of elementItemLine:
      line*: Line
    of elementItemArc:
      arc*: Arc
  
  Element* = object
    flags*: set[Flag]
    description*: string
    markPosition*: Vector
    namePosition*: Vector
    nameRotation*: int
    nameScale*: int
    nameFlags*: set[Flag]
    children*: seq[ElementItem]

proc `+`*(a, b: Dimension): Dimension =
  Dimension(int(a) + int(b))

proc `-`*(a, b: Dimension): Dimension =
  Dimension(int(a) - int(b))

proc `*`*(a: Dimension, b: int): Dimension =
  Dimension(int(a) * b)

proc `*`*(a: int, b: Dimension): Dimension =
  Dimension(a * int(b))

proc `/`*(a: Dimension, b: int): Dimension =
  Dimension(int(a) / b)

proc `-`*(a: Dimension): Dimension =
  Dimension(-int(a))

proc fromMils*(x: float): Dimension =
  Dimension(x * 100.0)

proc fromMM*(x: float): Dimension =
  Dimension(x * 3937.01)

proc toMils*(x: Dimension): float =
  float(x) / 100.0
  
proc toMM*(x: Dimension): float =
  float(x) / 3937.01

proc fromMils*(x, y: float): Vector =
  (x: x.fromMils(), y: y.fromMils())

proc fromMM*(x, y: float): Vector =
  (x: x.fromMM(), y: y.fromMM())

proc add*(elem: var Element, item: ElementItem) =
  elem.children.add item

proc add*(elem: var Element, pad: Pad) =
  elem.children.add ElementItem(kind: elementItemPad, pad: pad)

proc add*(elem: var Element, pin: Pin) =
  elem.children.add ElementItem(kind: elementItemPin, pin: pin)

proc add*(elem: var Element, line: Line) =
  elem.children.add ElementItem(kind: elementItemLine, line: line)

proc add*(elem: var Element, arc: Arc) =
  elem.children.add ElementItem(kind: elementItemArc, arc: arc)

proc quote(s: Rope): Rope =
  rope("\"") & s & rope("\"")

proc quote(s: string): Rope =
  quote(rope(s))

proc serialize*(flag: Flag): Rope =
  case flag
  of flagPin:      rope("pin")
  of flagVia:      rope("via")
  of flagHole:     rope("hole")
  of flagShowName: rope("showname")
  of flagOnSolder: rope("onsolder")
  of flagSquare:   rope("square")
  of flagOctagon:  rope("octagon")
  of flagEdge2:    rope("edge2")

proc serialize*(flags: set[Flag]): Rope =
  var first = true
  result = rope("")
  for flag in flags:
    if first:
      first = false
    else:
      result = result & rope(",")
    result = result & flag.serialize()
  result = result.quote()

proc serialize*(pad: Pad): Rope =
  result = &[
    rope("Pad["),
    rope(pad.pos1.x.int()),
    rope(" "),
    rope(pad.pos1.y.int()),
    rope(" "),
    rope(pad.pos2.x.int()),
    rope(" "),
    rope(pad.pos2.y.int()),
    rope(" "),
    rope(pad.metalThickness.int()),
    rope(" "),
    rope(pad.clearance.int()),
    rope(" "),
    rope(pad.maskThickness.int()),
    rope(" "),
    pad.name.quote(),
    rope(" "),
    pad.number.quote(),
    rope(" "),
    pad.flags.serialize(),
    rope("]"),
  ]

proc serialize*(pin: Pin): Rope =
  result = &[
    rope("Pin["),
    rope(pin.centerPos.x.int()),
    rope(" "),
    rope(pin.centerPos.y.int()),
    rope(" "),
    rope(pin.metalDiameter.int()),
    rope(" "),
    rope(pin.clearance.int()),
    rope(" "),
    rope(pin.maskDiameter.int()),
    rope(" "),
    rope(pin.drillDiameter.int()),
    rope(" "),
    pin.name.quote(),
    rope(" "),
    pin.number.quote(),
    rope(" "),
    pin.flags.serialize(),
    rope("]"),
  ]

proc serialize*(line: Line): Rope =
  result = &[
    rope("ElementLine["),
    rope(line.pos1.x.int()),
    rope(" "),
    rope(line.pos1.y.int()),
    rope(" "),
    rope(line.pos2.x.int()),
    rope(" "),
    rope(line.pos2.y.int()),
    rope(" "),
    rope(line.thickness.int()),
    rope("]"),
  ]

proc serialize*(arc: Arc): Rope =
  result = &[
    rope("ElementArc["),
    rope(arc.centerPos.x.int()),
    rope(" "),
    rope(arc.centerPos.y.int()),
    rope(" "),
    rope(arc.hozRadius.int()),
    rope(" "),
    rope(arc.vertRadius.int()),
    rope(" "),
    rope(arc.startAngle),
    rope(" "),
    rope(arc.sweepAngle),
    rope(" "),
    rope(arc.thickness.int()),
    rope("]"),
  ]

proc serialize*(item: ElementItem): Rope =
  case item.kind
  of elementItemPad:
    item.pad.serialize()
  of elementItemPin:
    item.pin.serialize()
  of elementItemLine:
    item.line.serialize()
  of elementItemArc:
    item.arc.serialize()

proc serialize*(elem: Element): Rope =
  result = &[
    rope("Element["),
    elem.flags.serialize(),
    rope(" "),
    elem.description.quote(),
    rope(" \"\" \"\" "),
    rope(elem.markPosition.x.int()),
    rope(" "),
    rope(elem.markPosition.y.int()),
    rope(" "),
    rope(elem.namePosition.x.int()),
    rope(" "),
    rope(elem.namePosition.y.int()),
    rope(" "),
    rope(elem.nameRotation),
    rope(" "),
    rope(elem.nameScale),
    rope(" "),
    elem.nameFlags.serialize(),
    rope("]\n(\n"),
  ]
  for child in elem.children:
    result = &[result, rope("    "), child.serialize(), rope("\n")]
  result = result & rope(")")

proc getOutputFile(): string =
  for kind, key, val in getopt():
    if kind == cmdArgument:
      return key
  return nil

proc dump*(elem: Element) =
  let outputFile = getOutputFile()
  if outputFile == nil:
    echo "error: not enough arguments (expected an output filename to be given)"
  else:
    writeFile(outputFile, $elem.serialize())
