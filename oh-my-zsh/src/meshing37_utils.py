import os
import re
import shutil
import subprocess

global splat_dir, meshing37_dir, out_dir, out_gt_dir, out_seq_dir

render_args = [
  "--renderDepthBins",
  "--cameraPath",
  "--useCameras",
  "--datasetType recorder_v2"
]

def between(start, s, end, keep_delims=False, keep_start=False, keep_end=False):
  btwn = re.search(start+'(.*)'+end, s).group(1)
  if keep_start or keep_delims:
    btwn = start + btwn
  if keep_end or keep_delims:
    btwn = btwn + end

  return btwn

def get_meshing37_filename(full_filename):
  if ".tgz" in full_filename:
    return between("", full_filename, ".tgz", keep_end=True)
  else:
    return None
  
def validate_sequence(sequence):
  # If sequence exists both in meshing37 sequences and gt meshes then return true, else false
  for filename in os.listdir(meshing37_dir + "/gtMeshes/"):
    if sequence in filename:
      for seq in os.listdir(meshing37_dir + "/sequences/"):
        if sequence in seq:
          return True
  return False

def makedirs(path):
  os.makedirs(path, exist_ok=True)

def setup_meshing_dataset_from_splats():
  if not os.path.exists(out_dir):
    makedirs(out_dir)
    makedirs(out_gt_dir)
    makedirs(out_seq_dir)
  else:
    print("DIRECTORY " + out_dir + " ALREADY EXISTS")
    print("Please remove it before running this script")

  # Copy sequence text files from meshing37
  shutil.copy(meshing37_dir + "/sequences/" + "/sequences.txt", out_seq_dir + "/")
  shutil.copy(meshing37_dir + "/sequences/" + "/sequenceEval.txt", out_seq_dir + "/")

  all_sequences = []
  for filename in os.listdir(splat_dir):
    m37name = get_meshing37_filename(filename)
    if m37name is not None and validate_sequence(m37name):
      # Add sequence to list of all sequences
      all_sequences.append(m37name)
      
      # Copy the gtMeshes from meshing37
      shutil.copytree(meshing37_dir + "/gtMeshes/" + m37name + "/", out_gt_dir + m37name + "/")

      # Make the sequences directory
      makedirs(out_seq_dir + m37name + "/")


  # all_sequences.extend(["*all", "*good", "*middle", "*bad"])
  # with open(out_seq_dir + "sequences.txt", "r+") as seq:#, open (out_seq_dir + "sequenceEval.txt", "w") as eval:
  #   for seqline in seq:
  #     seqline = seqline.rstrip()

  #     if ".tgz" in seqline:
  #       currseq = between("202", seqline, ".tgz", keep_delims=True)
  #       if not validateSequence(currseq):
  #         print ("INVALID")
  #     else:
  #       print("Not a tgz")

def mass_render_splats(filetype="spz", inner_sequence_id="step04200"):
  render_root = "/var/tmp/mass_render_splats/"
  if os.path.exists(render_root):
    shutil.rmtree(render_root)
  makedirs(render_root)
  
  for filename in os.listdir(splat_dir):
    m37_name = get_meshing37_filename(filename)
    if m37_name is not None:
      makedirs(render_root + m37_name + "/")

      splat = splat_dir + "/" + filename + "/" + inner_sequence_id + "/model." + filetype

      cmd = "bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:RenderSplats " \
            + splat + " " + " ".join(render_args) \
            + " --rootPath " + meshing37_dir + "/sequences/" + m37_name + "/" \
            + " --output " + render_root + m37_name + "/"
      subprocess.run(cmd, shell=True, executable="/bin/zsh") 

if __name__ == "__main__":
  args = os.sys.argv[1:]

  if len(args) < 1:
    print("Usage: python3 meshing37_utils.py setup splat_dir meshing37_dir (out_dir)")
    print("Usage: python3 meshing37_utils.py render splat_dir meshing37_dir")
    exit(1)

  # setup_meshing_dataset_from_splats()
  match args[0]:
    case "setup":
      if len(args) < 3:
        print("Usage: python3 meshing37_utils.py render splat_dir meshing37_dir (out_dir)")
        exit(1)

      splat_dir = args[1]
      meshing37_dir = args[2]

      out_dir = "/Users/johnanselmo/dev/data/meshing_from_splats/"
      if len(args) == 4:
        out_dir = args[3]
      out_gt_dir = out_dir + "gtMeshes/"
      out_seq_dir = out_dir + "sequences/"

      setup_meshing_dataset_from_splats()
    case "render":
      if len(args) < 2:
        print("Usage: python3 meshing37_utils.py render splat_dir meshing37_dir")

      splat_dir = args[1]
      meshing37_dir = args[2]

      mass_render_splats()
    case _:
      print("Invalid command")
      exit(1)
