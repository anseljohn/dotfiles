import os
import subprocess

  
def path_exists(path):
  return os.path.exists(path)

def makedirs(path):
  os.makedirs(path, exist_ok=True)

def execute(cmd, output=False):
  return subprocess.run(cmd, shell=True, executable="/bin/zsh", capture_output=output, text=output)

def output(cmd):
  return execute(cmd, True).stdout.strip()

def env(var):
  return execute("echo -n $" + var, True).stdout.strip()

def cd(path):
  global currdir
  currdir = os.getcwd()
  os.chdir(path)

def pwd():
  ret = os.getcwd()
  print(ret)
  return ret

def in_dir(path):
  return path in os.getcwd()

def in_monorepo():
  return in_dir(env("MONOREPO")) or in_dir(env("SPATIAL"))

def back():
  os.chdir(currdir)

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

def info(txt):
  print(bcolors.OKCYAN + "INFO: " + bcolors.ENDC + txt)

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