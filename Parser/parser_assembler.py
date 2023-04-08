"""
_______FORMAT_______ 
Opcode Rd, Rs1, Rs2
Opcode Rd, Rs1, const
Opcode Rd, const
Opcode const
Label: Opcode ______
NOP for no operation
"""

from helper_parser import *

inp_file = open('input.txt', "r")
op_file = open('op.txt', "w+")

assembly_codes = inp_file.readline()
i = 1
while assembly_codes:
  assembly_codes.replace("\n", "")
  code_breakup = assembly_codes.replace(", ", " ").split(" ")
  op_file.writelines(code_gen(code_breakup, i) + "\n")
  i = i + 1
  assembly_codes = inp_file.readline()

inp_file.close()
op_file.close()

op_file = open(
  'op.txt', "r+")

instr_data = op_file.readlines()
for line_num, code in Flagged_lines.items():
  code_breakup = code[:-1].replace(", ", " ").split(" ")
  instr_data[line_num - 1] = code_gen(code_breakup, line_num) + "\n"

op_file.close()

with open('op.txt', "w") as op_file:
  op_file.writelines(instr_data)