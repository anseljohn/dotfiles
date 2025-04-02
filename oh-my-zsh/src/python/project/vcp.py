import argparse

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