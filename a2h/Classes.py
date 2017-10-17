import os

class STE:
    def __init__(self, id, symbol_set, start, report, activates, target, num_id, resource, bramnum=0, bramidx = 0, symbol_set2='[]'):
        self.id = id
        self.start = start # all-input or start-of-data
        self.report = report # Index of the ReportVector that this STE maps to
        self.activates = activates # List of elements this STE activates
        self.num_id = num_id # Renamed ID (an integer)
        self.resource = resource
        self.bramnum = bramnum
        self.bramidx = bramidx
        # If there are reset or enable controls for counters, fix that here
        for i in range(0, len(self.activates)):
            word = self.activates[i]
            if ':' in word:
                self.activates[i] = self.activates[i][:-4] + '_' + self.activates[i][-3:]
        
        self.symbol_set_string = symbol_set
        self.symbol_set_string2 = symbol_set2
        # Parse symbol set
        self.bitvector = self.GenerateBitvector(symbol_set)
        self.bitvector2 = self.GenerateBitvector(symbol_set2)
        self.target = target

    def GenerateBitvector(self, symbol_set):
        temp_symbol_set = [0]*256 #Initialized to all 0
        bitvector = ''
        if symbol_set == '[]':
            bitvector = '0'*256
            return
        if symbol_set.startswith('[') and symbol_set.endswith(']'): #Regex
            regex = symbol_set[1:-1] # get rid of brackets
            if len(regex) == 0: return
            negate = regex[0]=='^'
            if negate: regex = regex[1:]
            last_resolved_index = 0
            fill_in_range = False
            skip_num = 0
            for idx, c in enumerate(regex):
                if skip_num:
                    skip_num-=1
                    continue
                if c == '\\': # Escaped character
                    escaped_char = regex[idx+1]
                    if escaped_char == 'x': # hex digit
                        num = regex[idx+2:idx+4]
                        num_val = int(num, 16) # parse as hex digit
                        if fill_in_range:
                            for x in range(last_resolved_index, num_val+1):
                                temp_symbol_set[x] = 1
                            fill_in_range = False
                        temp_symbol_set[num_val] = 1
                        last_resolved_index = num_val
                        skip_num = 3
                    elif escaped_char == 'd': # all decimal digits
                        for i in range(10):
                            temp_symbol_set[i] = 1
                        skip_num = 1
                    elif escaped_char == 's': # whitespace
                        temp_symbol_set[ord(' ')] = 1
                        skip_num = 1
                    elif escaped_char == 'w': # alphanumeric and underscore
                        for x in range(256):
                            if x >= ord('0') and x <= ord('9'):
                                temp_symbol_set[x] = 1
                            if x >= ord('A') and x <= ord('Z'):
                                temp_symbol_set[x] = 1
                            if x >= ord('a') and x <= ord('z'):
                                temp_symbol_set[x] = 1
                            if x == ord('_'):
                                temp_symbol_set[x] = 1
                        skip_num = 1
                    elif escaped_char == ".":
                        temp_symbol_set[ord('.')] = 1
                        skip_num = 1
                elif c == '.':
                    for x in range(256):
                        if chr(x) != '\n':
                            temp_symbol_set[x] = 1
                elif c == '*':
                    for x in range(256):
                        temp_symbol_set[x] = 1
                elif c == '-': # Range of indexes
                        fill_in_range = True
                else:
                    temp_symbol_set[ord(c)] = 1
                    if fill_in_range:
                        for x in range(last_resolved_index, ord(c)+1):
                            temp_symbol_set[x] = 1
                        fill_in_range = False
                    last_resolved_index = ord(c)
            if negate:
                for x in range(256):
                    temp_symbol_set[x] = not temp_symbol_set[x]
        elif symbol_set.startswith('{') and symbol_set.endswith('}'):
            # Doesn't appear in Brill Tagging, so ignore for now
            pass
        else: # Single character or *
            if symbol_set == '*':
                for x in range(256):
                    temp_symbol_set[x] = 1
            else:
                index = 0
                if (symbol_set.startswith('\\x')): # hex
                    index = int(symbol_set[2:], 16)
                else: # ascii
                    index = ord(symbol_set)
                temp_symbol_set[index] = 1

        bitvector = ''.join(str(int(e)) for e in temp_symbol_set)
        bitvector = bitvector[::-1]
        return bitvector

    # Generate a MIF file for Quartus if the target is Altera
    # Programs symbol set information into each RAM block for the hardware STEs
    def GenerateMif(self):
        if self.target != 'altera':
            return
        directory_delim = '/'
        if os.name == 'nt': # Windows directory delimieter is backslash
            directory_delim = '\\'
        filename = 'MemoryInitializationFiles' + directory_delim + \
                'ste' + self.id + '.mif'
        fd = open(filename, 'w')
        fd.truncate() # Erase current contents
        fd.write('--')
        fd.write(self.symbol_set_string)
        fd.write('\n')
        fd.write('WIDTH=1;\n')
        fd.write('DEPTH=256;\n')
        fd.write('\n')
        fd.write('ADDRESS_RADIX=UNS;\n')
        fd.write('DATA_RADIX=UNS;\n')
        fd.write('CONTENT BEGIN\n')
        
        for index, bit in enumerate(self.symbol_set):
            entry = str(index) + '  :  '
            if bit:
                entry += '1'
            else:
                entry += '0'
            entry += ';\n'
            fd.write(entry)
    
        fd.write('END;\n')
        fd.close()
        
    def __str__(self):
        retval = 'STE ' + self.id + '\n'
        if self.start:
            retval += '\tStarts on: ' + self.start + '\n'
        if self.report:
            retval += '\tReports to: ' + self.report + '\n'
        if self.activates:
            retval += '\tActivates: ' + '\n'
            for x in self.activates:
                retval += '\t\t'+x+'\n'
        return retval

class OR:
    def __init__(self, id, report):
        self.id = id
        self.report = report

class Counter:
    def __init__(self, id, report, target, at_target):
        self.id = id
        self.report = report
        self.target = str(target)
        if not at_target:
            self.at_target = '0' # Pulse
        else:
            if at_target == 'pulse':
                self.at_target = '0' # Pulse
            elif at_target == 'latch':
                self.at_target = '1' # Latch
            elif at_target == 'roll':
                self.at_target = '2' # Roll
