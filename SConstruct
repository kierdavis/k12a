import os.path

def gsch2pcb_emitter(target, source, env):
    base = os.path.splitext(str(source[0]))[0]
    target = [base + ".pcb", base + ".net", base + ".cmd"]
    return target, source

env = Environment()
env.Append(
    IVERILOG = "iverilog",
    IVERILOGFLAGS = [],
    NIM = "nim",
    NIMFLAGS = [],
    NIMCFLAGS = ["--verbosity:0", "--path:%s" % Dir("#tools").abspath],
    PCB = "pcb",
    GSCH2PCB = "gsch2pcb",
    GSCH2PCBFLAGS = ["--elements-dir", Dir("#eda/footprints").abspath],
    BUILDERS = {
        "IVerilog": Builder(action = "$IVERILOG $IVERILOGFLAGS -o$TARGET $SOURCES", suffix = ".vvp"),
        "Nim": Builder(action = "$NIM $NIMFLAGS compile --out:${TARGET.file} $NIMCFLAGS ${SOURCES.file}", suffix = ".generate", chdir = True),
        "GenerateFootprint": Builder(action = "$SOURCE $TARGET", suffix = ".fp"),
        "RenderFootprintEPS": Builder(action = "$PCB -x eps --eps-file $TARGET $SOURCE", suffix = ".eps"),
        "Gsch2pcb": Builder(action = "$GSCH2PCB $GSCH2PCBFLAGS $SOURCE", emitter = gsch2pcb_emitter),
    },
)

Export("env")

SConscript("rtl/SConscript")
SConscript("eda/footprints/SConscript")
SConscript("eda/mboard/SConscript")
