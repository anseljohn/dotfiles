import glob
import os
import re
import shutil

def between(start, s, end, keep_start=False, keep_end=False):
  btwn = re.search(start+'(.*)'+end, s).group(1)
  if keep_start:
    btwn = start + btwn
  if keep_end:
    btwn = btwn + end

  return btwn

def getMeshing37Filename(full_filename):
  if ".tgz" in full_filename:
    return between("", full_filename, ".tgz", keep_end=True)
  else:
    return None

def makedirs(path):
  os.makedirs(path, exist_ok=True)

def setupMeshingDatasetFromSplats(splat_dir, meshing37_dir, out_dir):
  gtMeshes = out_dir + "gtMeshes/"
  sequences = out_dir + "sequences/"
  if not os.path.exists(out_dir):
    makedirs(out_dir)
    # makedirs(gtMeshes)
    makedirs(sequences)
  else:
    print("DIRECTORY " + out_dir + " ALREADY EXISTS")
    print("Please remove it before running this script")

  all_sequences = []
  for filename in os.listdir(splat_dir):
    m37name = getMeshing37Filename(filename)
    if m37name is not None:
      all_sequences.append(m37name)
      
      # Copy the gtMeshes from meshing37
      shutil.copytree(meshing37_dir + "/gtMeshes/" + m37name + "/", gtMeshes + m37name + "/")

      # Make the sequences directory
      makedirs(sequences + m37name + "/")

  all_sequences.extend(["*all", "*good", "*middle", "*bad"])
  with open(sequences + "sequences.txt", "w") as seq, open (sequences + "sequenceEval.txt", "w") as eval:
    for seqline, evalline in zip(seq, eval):
      seqline = seqline.rstrip()

      if ".tgz" in seqline:
        seqline = between("-", seqline, ".tgz", keep_end=True)
        print(seqline)
      else:
        print("Not a tgz")


if __name__ == "__main__":
  args = os.sys.argv[1:]

  out_dir = "/Users/johnanselmo/dev/data/meshing_from_splats/"
  if len(args) == 3:
    out_dir = args[2]

  setupMeshingDatasetFromSplats(args[0], args[1], out_dir)