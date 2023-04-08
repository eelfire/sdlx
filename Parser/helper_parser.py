opcode_directory = {
  # R type triadic
  "ADD" : "000001",
  "SUB" : "000010",
  "AND" : "000011",
  "ORR" : "000100",
  "XOR" : "000101",
  "SLL" : "000110",
  "SRL" : "000111",
  "SRA" : "001000",
  "ROL" : "001001",
  "ROR" : "001010",
  "SLT" : "001011",
  "SGT" : "001100",
  "SLE" : "001101",
  "SGE" : "001110",
  "UGT" : "001111",
  "ULT" : "010000",
  "UGE" : "010001",
  "ULE" : "010010",
  "DMX" : "010011",
  "AD4" : "100000",

  # R - I type triadic
  "ADDI" : "000001",
  "SUBI" : "000010",
  "ANDI" : "000011",
  "ORRI" : "000100",
  "XORI" : "000101",
  "SLLI" : "000110",
  "SRLI" : "000111",
  "SRAI" : "001000",
  "ROLI" : "001001",
  "RORI" : "001010",
  "SLTI" : "001011",
  "SGTI" : "001100",
  "SLEI" : "001101",
  "SGEI" : "001110",
  "UGTI" : "001111",
  "ULTI" : "010000",
  "UGEI" : "010001",
  "ULEI" : "010010",
  "LHI"  : "010011",

  "SB"  : "010100",
  "SH"  : "010101",
  "SW"  : "010110",
  "LBU" : "011000",
  "LHU" : "011001",
  "LB"  : "011100",
  "LH"  : "011101",
  "LW"  : "011110",

  # R type diadic
  "BEQZ" : "100000",
  "BNEZ" : "100001",
  "JR"   : "100010",
  "JALR" : "100011",

  # J type Diadic
  "J"    : "110000",
  "JAL"  : "110001",
  "HLT"  : "111111"

}

Label_directory = {}
Flagged_lines = {}


def to_bin(y, num):
  if isinstance(y, int):  #this is used only when 
    # When y is integer and negative
    if y < 0: 
      return bin((1<<num) + y).replace("0b", "")  
    else:
      y = str(y)

  if y[:2].isdigit() == True:
    return bin(int(y)).replace("0b", "").zfill(num)
  elif y[:2] == "0b":
    return y[2:].zfill(num)
  elif y[:2] == "0x":
    return "{0:08b}".format(int(y[-1][2:], 16)).zfill(num)
  else: 
    return bin(int(y)).replace("0b", "").zfill(num)
    


def code_gen(x, line_num):
  if len(x) == 1:
    if x[0].upper() == "NOP":
      return "0"*31 + "1"
    elif x[0].upper() == "HLT":
      return opcode_directory[x[0]] + "0"*26
  
  if x[0][-1] == ':':
    x[0].replace(":", "")
    Label_directory[x[0][:-1]] = line_num
    x.pop(0)

  # If we use lower case opcodes
  x[0] = x[0].upper()
  if (len(x) > 3):
    # R type triadic
    if (x[3][0] == '$'):
      return "0"*6 + bin(int(x[2][2:])).replace("0b", "").zfill(5) + bin(int(x[3][2:])).replace("0b", "").zfill(5) + bin(int(x[1][2:])).replace("0b", "").zfill(5) + "0"*5 + opcode_directory[x[0]]

      # R-I type triadic
    else:
      # to check whether the const is in form of label or nu
      if x[-1][0].isdigit() == False:
        if Label_directory.get(x[-1]) == None:
          Flagged_lines[line_num] = " ".join(x)
          return "0"*32

        else:
          return opcode_directory[x[0]] + bin(int(x[2][2:])).replace("0b", "").zfill(5) + bin(int(x[1][2:])).replace("0b", "").zfill(5) + to_bin(Label_directory[x[-1]] - line_num - 1, 16)
      else:
        return opcode_directory[x[0]] + bin(int(x[2][2:])).replace("0b", "").zfill(5) + bin(int(x[1][2:])).replace("0b", "").zfill(5) + to_bin(x[-1], 16)

  else:
    # R type diadic
    if (len(x) == 3):
      if x[-1][0].isdigit() == False:
        if Label_directory.get(x[-1]) == None:
          Flagged_lines[line_num] = " ".join(x)
          return "0"*32

        else:
          return opcode_directory[x[0]] + bin(int(x[1][2:])).replace("0b", "").zfill(5) + "0"*5 + to_bin(Label_directory[x[-1]] - line_num - 1, 16)
      else:
          return opcode_directory[x[0]] + bin(int(x[1][2:])).replace("0b", "").zfill(5) + "0"*5 + to_bin(x[-1], 16)

    # J type
    else:
      if x[-1][0].isdigit() == False:
        if Label_directory.get(x[-1]) == None:
          Flagged_lines[line_num] = " ".join(x)
          return "0"*32

        else:
          return opcode_directory[x[0]] + to_bin(Label_directory[x[-1]] - line_num - 1, 26)
      else:
        return opcode_directory[x[0]] + to_bin(x[-1], 26)