import argparse

from enum import Enum
from utils import *

class BazelProject(Enum):
  SCANKIT=("scankit", "ScanKit", env("SCANKIT_BZL"))
  PIPELINE=("pipeline", "Pipeline", env("PIPELINE_BZL"))
  NEURAL=("neural", "Neural", env("NEURAL_BZL"))
  INFINITAM=("infinitam", "InfiniTAM", env("INFINITAM_BZL"))
  MASSF=("massf", "mapping-framework", env("MASSF_BZL"))

  def __init__(self, short_name, full_name, path):
    self.short_name = short_name
    self.full_name = full_name
    self.path = path

  def get_project(short_name):
    name_map = {}
    for project in BazelProject:
      name_map[project.short_name] = project
    return name_map[short_name]
  
  def short_names():
    return [project.short_name for project in BazelProject]

  def full_names():
    return [project.full_name for project in BazelProject]

def build(short_name, cuda=False):
  proj = BazelProject.get_project(short_name)
  if (not in_monorepo()):
    err("Not in a buildable directory.")
    exit(1)

  if proj.short_name == "infinitam" or proj.short_name == "massf":
    cmd = "./bazel-build"
    if cuda:
      cmd += "-cuda"

    cd(proj.path)
    rp(cmd + ".sh")
    back()
  else:
    rp(f"bazel build -- //{proj.path}/...")

if __name__ == "__main__":
  arg_parser = argparse.ArgumentParser(description="Build a project in the monorepo.")
  arg_parser.add_argument(
      "--project",
      required=True,
      type=str,
      choices=BazelProject.short_names(),
      help="The project to build.")
  arg_parser.add_argument(
    "--cuda",
    action="store_true",
    help="Build with CUDA support.")

  args = arg_parser.parse_args()
  build(args.project, args.cuda)
