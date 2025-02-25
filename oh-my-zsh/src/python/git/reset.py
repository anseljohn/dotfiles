import argparse
import sys
import os

# Add parent directory to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from utils import *

def reset(hard):
  call = "git reset"
  if (hard):
    call += " --hard"
  execute(call)

def checkout(branch, file):
  execute(f"git checkout {branch} -- {file}")

if __name__ == "__main__":
  arg_parser = argparse.ArgumentParser(description="Git aliases.")
  arg_parser.add_argument(
    '-b', '--branch',
    type=str,
    required=False,
    help="The branch to reset to"
  )
  arg_parser.add_argument(
    '-f', '--file', 
    type=str, 
    required=False,
    help="Path to the file"
  )
  arg_parser.add_argument(
      '--hard',
      action="store_true",
      help="Hard reset"
  )

  args = arg_parser.parse_args()

  if args.file:
    checkout(args.branch, args.file)
  else:
    reset(args.hard)

