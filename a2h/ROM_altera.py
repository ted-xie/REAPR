import os

class ROM_altera:
    def __init__(self, STE_vec):
        self.STE_vec = STE_vec
        self.w = 256
        self.h = len(STE_vec)
        
        if self.h > 65536:
            print "Error: Too many STEs (needs to be less than 65536)"
        
        self.Matrix = [''] * self.h
        self.PopulateMatrix()
        self.GenerateMif()
        
    def PopulateMatrix(self):
        for j in range(self.h):
            self.Matrix[j] = self.STE_vec[j].bitvector
                
    def GenerateMif(self):
        directory_delim = '/'
        if os.name == 'nt': # Windows directory delimieter is backslash
            directory_delim = '\\'
        filename = 'MemoryInitializationFiles' + directory_delim + \
                'ROM_init.mif'
        fd = open(filename, 'w')
        fd.truncate() # Erase current contents
        fd.write('WIDTH=' + str(self.w) + ';\n')
        fd.write('DEPTH=' + str(self.h) + ';\n')
        fd.write('\n')
        fd.write('ADDRESS_RADIX=UNS;\n')
        fd.write('DATA_RADIX=BIN;\n')
        fd.write('CONTENT BEGIN\n')
        
        for j in range(self.h):
            fd.write(str(j) + ' : ')
            fd.write(self.Matrix[j])
            fd.write('\n')

        if self.h < 65536:
            fd.write('[' + str(self.h) + '..65535] : 0\n')
        fd.write('END;\n')
        fd.close()
    
    def __str__(self):
        return str(self.Matrix)
