import pcb.parse
import pcb.stringify
import pcb.types

var pcb = parseStdin()

# Set metadata
pcb.name = "mboard"

# Set board dimensions
pcb.width = 10.cm()
pcb.height = 10.cm()

echo $pcb
