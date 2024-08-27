from python.utils import * 

def drcconv(decoder, drc, out, base64="no"):
  if path_exists(decoder):
    if ".ply" in out:
      rp(decoder, "-i", drc, "-o", out)
    else:
      rp(decoder, base64, out)
  else:
    err("Decoder does not exist.")
    print("Please build before running this script.")
    exit(1)

if __name__ == "__main__":
  args = os.sys.argv[1:]

  if len(args) == 3:
    drcconv(args[0], args[1], args[2])
  elif len(args) == 4:
    drcconv(args[0], args[1], args[2], args[3])
  else:
    err("Usage: python3 draco.py decoder drc out (base64)")