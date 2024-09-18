import argparse

from utils import *

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
      "command",
      type=str,
      choices=["push", "branches"],
      help="The command to run.")
  arg_parser.add_argument(
      "--force", "-f",
      action="store_const",
      const="--force",
      default="",
      help="Force push."
  )
  arg_parser.add_argument(
      "--all", "-a",
      action="store_true",
      help="Show all branches."
  )
  arg_parser.add_argument(
      "--self", "-s",
      action="store_true",
      help="Show branches related to the current user."
  )

  args = arg_parser.parse_args()

  match args.command:
    case "push":
      push(args.force)  
    case "branches":
      branches(args)
    case _:
      err(f"Unknown command: {args.command}")