class Command:
  def __init__(self, alias, description, function, args):
    self.alias = alias
    self.description = description
    self.function = function
    self.args = args

  def execute(self, args):
    self.function(args)
  
  def __str__(self):
    hlp = f"{self.alias} - {self.description}\n"
    for arg in self.args:
      hlp += f"\t{arg}\t: {self.args[arg]}\n"