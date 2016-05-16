import pcb.types
import pcb.stringify

proc createElement(): Element =
  const pinDrillDiameter = 28.mil()
  const pinMetalDiameter = pinDrillDiameter + 2 * 16.mil()
  const pinMaskDiameter = pinMetalDiameter + 2 * 3.mil()
  #const silkThickness = 10.mil()
  
  var element: Element
  element.init()
  element.desc = "BREAKOUT_PADS"
  element.markPos = (x: 400.mil(), y: 100.mil())
  element.textPos = (x: -350.mil(), y: -160.mil())
  element.textDir = leftToRight
  element.textScale = 100
  
  result = element
  
  for i in 0..7:
    let x = (i*2 - 7) * 50.mil()
    let number = $(i + 1)
    let name = "pin" & number
    
    var upperPin: Pin
    upperPin.init()
    upperPin.center = (x: x, y: 50.mil())
    upperPin.metalDiameter = pinMetalDiameter
    upperPin.clearance = 30.mil()
    upperPin.maskDiameter = pinMaskDiameter
    upperPin.drillDiameter = pinDrillDiameter
    upperPin.name = name
    upperPin.number = number
    element.pins.add(upperPin)
    
    var lowerPin: Pin
    lowerPin.init()
    lowerPin.center = (x: x, y: -50.mil())
    lowerPin.metalDiameter = pinMetalDiameter
    lowerPin.clearance = 30.mil()
    lowerPin.maskDiameter = pinMaskDiameter
    lowerPin.drillDiameter = pinDrillDiameter
    lowerPin.name = name
    lowerPin.number = number
    element.pins.add(lowerPin)
  
  result = element

const element = createElement()
echo $element
