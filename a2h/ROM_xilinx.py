import os
import random

class ROM_xilinx:
    def __init__(self, STE_vec, name, LIMIT=72):
        self.STE_vec = STE_vec
        self.name = name
        self.h = 256
        self.w = LIMIT
        self.Matrix = [['0'] * self.w]*self.h

        self.PopulateMatrix()
        self.Generate()

    def PopulateMatrix(self):
        temp_matrix = [['0'] * 256] * self.w
        for row in range(len(self.STE_vec)):
            temp_matrix[row] = self.STE_vec[row].bitvector[::-1]

        # Rotate by 90 degrees clockwise
        self.Matrix = list(zip(*temp_matrix[::-1]))

    def Generate(self):
        directory_delim = '/'
        if os.name == 'nt':
            directory_delim = '\\'
        filename = 'MemoryFiles' + directory_delim + self.name + '.mem'
        fd = open(filename, 'w')
        fd.truncate()
        fd.write('@0000\n')
        matrix = ''
        for row in range(self.h):
            temp = ''.join(self.Matrix[row])
            temp_hex = hex(int(temp, 2))[2:]
            if len(temp_hex) < self.w/4:
                diff = self.w/4 - len(temp_hex)
                temp_hex = '0'*diff + temp_hex
            matrix += temp_hex + '\n'
        fd.write(matrix+'\n')
        fd.close()

