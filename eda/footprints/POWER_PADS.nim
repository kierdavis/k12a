import pcb.types
import pcb.stringify

proc createElement(): Element =
  const pinOffset = 75.mil()

  const pinDrillDiameter = 28.mil()
  const pinMetalDiameter = pinDrillDiameter + 2 * 16.mil()
  const pinMaskDiameter = pinMetalDiameter + 2 * 3.mil()
  const silkThickness = 10.mil()

  var element: Element
  element.init()
  element.desc = "POWER_PADS"
  element.markPos = (x: 200.mil(), y: 200.mil())
  element.textPos = (x: -pinOffset, y: 50.mil())
  element.textDir = leftToRight
  element.textScale = 100
  
  var vccPin: Pin
  vccPin.init()
  vccPin.center = (x: -pinOffset, y: 0.mil())
  vccPin.metalDiameter = pinMetalDiameter
  vccPin.clearance = 30.mil()
  vccPin.maskDiameter = pinMaskDiameter
  vccPin.drillDiameter = pinDrillDiameter
  vccPin.name = "VCC"
  vccPin.number = "1"
  element.pins.add(vccPin)
  
  var gndPin: Pin
  gndPin.init()
  gndPin.center = (x: pinOffset, y: 0.mil())
  gndPin.metalDiameter = pinMetalDiameter
  gndPin.clearance = 30.mil()
  gndPin.maskDiameter = pinMaskDiameter
  gndPin.drillDiameter = pinDrillDiameter
  gndPin.name = "GND"
  gndPin.number = "2"
  element.pins.add(gndPin)
  
  var line1: ElementLine
  line1.point1 = (x: pinOffset - 20.mil(), y: -pinOffset)
  line1.point2 = (x: pinOffset + 20.mil(), y: -pinOffset)
  line1.thickness = silkThickness
  element.lines.add(line1)
  
  var line2: ElementLine
  line2.point1 = (x: -pinOffset - 20.mil(), y: -pinOffset)
  line2.point2 = (x: -pinOffset + 20.mil(), y: -pinOffset)
  line2.thickness = silkThickness
  element.lines.add(line2)
  
  var line3: ElementLine
  line3.point1 = (x: -pinOffset, y: -pinOffset - 20.mil())
  line3.point2 = (x: -pinOffset, y: -pinOffset + 20.mil())
  line3.thickness = silkThickness
  element.lines.add(line3)
  
  result = element

const element = createElement()
echo $element
