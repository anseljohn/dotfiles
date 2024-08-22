import os
from pathlib import Path
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

def execute(cmd):
  subprocess.run(cmd, shell=True, executable="/bin/zsh")

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
    print("Creating output directories...", end="\r")
    makedirs(out_dir)
    makedirs(out_gt_dir)
    makedirs(out_seq_dir)
    makedirs(out_dir + "/output")
    makedirs(out_dir + "/output/recon")
    makedirs(out_dir + "/output/results")
    print("Creating output directories... DONE")
  else:
    print("DIRECTORY " + out_dir + " ALREADY EXISTS")
    print("Please remove it before running this script")
    exit(1)

  print("Copying sequence text files from meshing37...", end="\r")
  # Copy sequence text files from meshing37
  shutil.copy(meshing37_dir + "/sequences/" + "/sequences.txt", out_seq_dir + "/")
  shutil.copy(meshing37_dir + "/sequences/" + "/sequenceEval.txt", out_seq_dir + "/")
  print("Copying sequence text files from meshing37... DONE")

  all_sequences = []
  for filename in os.listdir(splat_dir):
    m37name = get_meshing37_filename(filename)
    if m37name is not None and validate_sequence(m37name):
      all_sequences.append(m37name)


  seq_cnt = len(all_sequences)
  for i in range(seq_cnt):
    seq = all_sequences[i]
    print("Copying sequence + gt mesh pair " + str(i+1) + " of " + str(seq_cnt) + "...", end="\r")
    # Copy the gtMeshes from meshing37
    shutil.copytree(meshing37_dir + "/gtMeshes/" + seq + "/", out_gt_dir + seq + "/")

    # Copy the sequences from meshing37
    shutil.copytree(meshing37_dir + "/sequences/" + seq + "/", out_seq_dir + seq + "/")
      
  print("Copying sequence + gt mesh pairs... DONE")
  create_config()
  print("Setup complete.")
  print("New meshing37 dataset is located at " + out_dir)

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
      execute(cmd)

def mass_copy_depths(render_root, seq_root, massf_root):
  for filename in os.listdir(render_root):
    m37_name = get_meshing37_filename(filename)
    if m37_name is not None:
      cmd = "python3 " + massf_root + "/tools/scripts/meshing_tools/copy_splat_depths_to_v2.py " \
            + render_root + "/" + m37_name \
            + " " + seq_root + "/sequences/" + m37_name + " nerr"
      execute(cmd)

def create_config():
  print("Creating config...", end="\r")
  config = open(out_dir + "/config.txt", "w")
  config_txt = "{\n"\
                  +"  \"inputFilePath\": \"" + out_seq_dir + "sequences.txt\",\n"\
                  +"  \"MultiDepthPath\": \"/Users/johnanselmo/dev/niantic/bazel-bin/argeo/infinitam/multidepth_console\",\n"\
                  +"\n"\
                  +"  \"ComparerPath\": \"/Users/johnanselmo/dev/niantic/bazel-bin/argeo/infinitam/mesh_comparer\",\n"\
                  +"  \"networksPath\": \"/Users/johnanselmo/dev/niantic/argeo/infinitam/Files/Nets/\",\n"\
                  +"\n"\
                  +"  \"sequencesPath\": \"" + out_seq_dir + "\",\n"\
                  +"  \"gtPath\": \"" + out_gt_dir + "\",\n"\
                  +"\n"\
                  +"  \"reconstructionPath\": \"" + out_dir + "/recon/\",\n"\
                  +"  \"resultPath\": \"" + out_dir + "/results/\",\n"\
                  +"\n"\
                  +"  \"gtMeshName\": \"lidar_highres_color_mesh_0.drc\",\n"\
                  +"  \"compareMeshName\": \"nn_highres_color_mesh_0.drc\"\n"\
                +"}\n"
  config.write(config_txt)
  print("Creating config... DONE")

def create_mesh(inf, input, output="", nets="", auto_convert=True):
  multidepth = inf + "/multidepth_console"
  if not os.path.exists(inf):
    print("Infinitam build directory does not exist.")
    print("Please build Infinitam before running this script.")
    exit(1)
  if not os.path.exists(multidepth):
    print("Multidepth executable does not exist.")
    print("Please build Infinitam before running this script.")
    exit(1)

  if ".txt" in input:
    execute("python3 " + inf + "/scripts/MeshEval/mesh_create.py --config_file_path " + input)
  elif ".tgz" in input:
    parent_out_dir = str(Path(output).parent.absolute()) + "/dracotmp/"
    makedirs(parent_out_dir)
    execute("echo " + multidepth + " " + nets + " " + input + " " + parent_out_dir)

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
      out_gt_dir = out_dir + "/gtMeshes/"
      out_seq_dir = out_dir + "/sequences/"

      setup_meshing_dataset_from_splats()
    case "config":
      out_dir = "/Users/johnanselmo/dev/data/meshing_from_splats/"
      if len(args) == 2:
        out_dir = args[1]
      out_gt_dir = out_dir + "/gtMeshes/"
      out_seq_dir = out_dir + "/sequences/"

      create_config()
    case "render":
      if len(args) < 3:
        print("Usage: python3 meshing37_utils.py render splat_dir meshing37_dir")
        exit(1)

      splat_dir = args[1]
      meshing37_dir = args[2]

      mass_render_splats()
    case "copyDepths":
      if len(args) < 4:
        print("Usage: python3 meshing37_utils.py copyDepths render_root seq_root, massf_root")
        exit(1)
      
      mass_copy_depths(args[1], args[2], args[3])

    case "create":
      if len(args) != 3 and len(args) != 5:
        print("Usage: python3 meshing37_utils.py create infinitam_bazel_bin config.txt")
        print("Usage: python3 meshing37_utils.py create infinitam_bazel_bin mesh_dir.tgz out_mesh.ply folder/to/Nets")
        exit(1)
      elif len(args) == 3:
        create_mesh(args[1], args[2])
      else:
        create_mesh(args[1], args[2], args[3], args[4])

    case _:
      print("Invalid command")
      exit(1)
