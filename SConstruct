env = Environment()
env.Append(
    IVERILOG = "iverilog",
    IVERILOGFLAGS = [],
    NIM = "nim",
    NIMFLAGS = [],
    NIMCFLAGS = ["--verbosity:0", "--path:%s" % Dir("#tools").abspath],
    PCB = "pcb",
    BUILDERS = {
        "IVerilog": Builder(action = "$IVERILOG $IVERILOGFLAGS -o$TARGET $SOURCES", suffix = ".vvp"),
        "Nim": Builder(action = "$NIM $NIMFLAGS compile --out:${TARGET.file} $NIMCFLAGS ${SOURCES.file}", suffix = ".generate", chdir = True),
        "GenerateFootprint": Builder(action = "$SOURCE $TARGET", suffix = ".fp"),
        "RenderFootprintEPS": Builder(action = "$PCB -x eps --eps-file $TARGET $SOURCE", suffix = ".eps"),
    },
)

SConscript("rtl/SConscript", exports="env")
SConscript("eda/footprints/SConscript", exports="env")
