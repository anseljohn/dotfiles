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

def branch():
  return output("git rev-parse --abbrev-ref HEAD 2>/dev/null")

def push(opt):
  match opt:
    case "":
      attempt = execute("git push", True)
      # if "fatal" in attempt:
      #   info("No upstream branch set. Creating one...")
      #   execute(f"git push --set-upstream origin {branch()}")
      # else:
      print(attempt)
      print("??")

    case "--force":
      execute(f"git push origin HEAD:{branch()} --force", True)


def branches(args):
  call = ""
  if args.all:
    call = "git branch -a"
  else:
    call = "git branch"

  if args.self:
    call += " | grep johna"

  execute(call)


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

