from utils import *

def update_image():
  print("peepeepoopoo")

def run(input_file, environment="stg"):
  print(f"{env('MAP_UTILS')}/mapping_utilities generate-config -x ray --input-list-file={input_file} -e {environment} -s {environment}")
        

if __name__ == "__main__":
  args = os.sys.argv[1:]

  if len(args) < 1:
    print("Usage: p3 generate_config.py input_file")
    print("Usage: p3 generate_config.py input_file env")
    exit(1)

  run(args[0], args[1])