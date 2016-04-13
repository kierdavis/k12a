env = Environment()
env.Append(
    IVERILOG = "iverilog",
    IVERILOGFLAGS = [],
    BUILDERS = {
        "IVerilog": Builder(action = "$IVERILOG $IVERILOGFLAGS -o$TARGET $SOURCES", suffix = ".vvp"),
    },
)

SConscript("rtl/SConscript", exports="env")
