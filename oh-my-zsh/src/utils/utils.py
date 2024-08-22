import os
import subprocess

  

def path_exists(path):
  return os.path.exists(path)

def makedirs(path):
  os.makedirs(path, exist_ok=True)

def execute(cmd, output=False):
  return subprocess.run(cmd, shell=True, executable="/bin/zsh", capture_output=output, text=output)

def env(var):
  return execute("source ~/.oh-my-john/oh-my-zsh/src/utils/dirs.zsh && echo -n $" + var, True).stdout.strip()

def cmdify(args):
  return " ".join([str(arg) for arg in args])

def rp(*args):
  cmd = cmdify(list(args))
  print("Running " + cmd)
  execute(cmd)

def err(txt):
  print(bcolors.FAIL + "ERROR: " + bcolors.ENDC + txt)

def succ(txt):
  print(bcolors.OKGREEN + "SUCCESS: " + bcolors.ENDC + txt)

def warn(txt):
  print(bcolors.WARNING + "WARNING: " + bcolors.ENDC + txt)

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'