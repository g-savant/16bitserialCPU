def main():
  ###read in file name from arguments
  import sys
  if len(sys.argv) != 2:
    print("Usage: compiler.py <filename>")
    return
  filename = sys.argv[1]
  ###read in file
  with open(filename, 'r') as file:
    lines = file.readlines()
  ###parse file
  all_instructions = []
  print(lines)
  for line in lines:
    print(line)
    op = line.split()[0]
    ###if word before first space in line is ADD, some number is 1
    instruction = [] ##binary array
    if op == "ADD" or op == "SUB":
      instruction[0:3] = [0, 0, 0]
      rd = int(line.split()[1][-2])
      reg1 = int(line.split()[2][-2])
      reg2 = int(line.split()[3][-2])
      instruction[3:6] = bin(reg1)[2:].zfill(3)
      instruction[6:9] = bin(reg1)[2:].zfill(3)
      instruction[9:12] = bin(rd)[2:].zfill(3)
      if op == "ADD":
        instruction[12:16] = bin(0)[2:].zfill(4)
      elif op == "SUB":
        instruction[12:16] = bin(1)[2:].zfill(4)
      elif op == "OR":
        instruction[12:16] = bin(2)[2:].zfill(4)
        
      print(instruction)
    else:
      print("Invalid instruction")
      return
      # Rest of your code for handling ADD instruction
    ###generate code
    all_instructions.append(int("".join(map(str, instruction)), 2))
  
  print(all_instructions)


if(__name__ == "__main__"):
  main()