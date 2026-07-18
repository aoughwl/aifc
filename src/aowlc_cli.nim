## aowlc_cli — nimony port: transpile a post-hexer `.c.nif` to C on stdout.
## Mirrors aifjs_cli.nim (sibling aowljs port); reads `.c.nif`, emits C.
when defined(nimony): {.feature: "lenientnils".}
import std/[syncio, os]
import nifcursors, nifstreams, programs
import emitc

proc stripCNif(fname: string): string =
  result = fname
  let n = result.len
  if n > 6 and result[n-6 .. n-1] == ".c.nif":
    result = result[0 .. n-7]

proc emitFile(path: string): string =
  var buf = parseFromFile(path)
  var root = beginRead(buf)
  result = emitModuleBody(root)
  endRead buf

proc main =
  var path = ""
  let params = commandLineParams()
  for p in params:
    if p.len > 0 and p[0] != '-' and path.len == 0: path = p
  if path.len == 0:
    write stderr, "aowlc: usage: aowlc <module.c.nif>\n"; quit 2
  if not fileExists(path):
    write stderr, "aowlc: cannot read file\n"; quit 1
  let dir = parentDir(path)
  let mainKey = stripCNif(extractFilename(path))
  setupProgramForTesting(dir, mainKey, ".c.nif")
  var outp = CPrelude
  outp.add "\n"
  outp.add emitFile(path)
  write stdout, outp

main()
