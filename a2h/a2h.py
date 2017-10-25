import argparse
import xml.etree.ElementTree as ET
import os
from jinja2 import Environment, FileSystemLoader
from Classes import STE, OR, Counter
from copy import copy
from copy import deepcopy
#from ROM import ROM
from ROM_xilinx import *
from fa_cluster import *
from text2bin import text2bin

directory_delim = '/'
if os.name == 'nt': # Windows directory delimiter is a backslash
    directory_delim = '\\'

context = {} # Context for Jinja2 template creation

parser = argparse.ArgumentParser(description='Translate Micron ANML code to VHDL.')
parser.add_argument('-a', '--anml', required=True, help='Input ANML filename.')
parser.add_argument('-o', '--out', required=True, help='Output filename.')
parser.add_argument('-e', '--entity', required=True, help='The name of your entity.')
parser.add_argument('-t', '--target', required=False, help='Choose a target \
                    for code generation: altera, xilinx, or logic.')
parser.add_argument('-l', '--language', required=False, help='Choose an output language: VHDL (vhd), Verilog (v), or C (c)')
parser.add_argument('-r', '--rightmin', required=False, help='Implement right-minimization, t or f')
parser.add_argument('-v', '--vote', required=False, help='On-chip voting for right-minimized automata.')
parser.add_argument('-b', '--bramlimit', required=False, help='Upper limit of BRAM STE states')
parser.add_argument('-d', '--double', required=False, help='Read 2 symbols per cycle')
parser.add_argument("-s", "--stimulus", required=False, help="If target==tb, use this file as the stimulus for the device under test.")

args = parser.parse_args() # Parse the input arguments

anml_path = args.anml
out_path = ''
target = 'logic' # Default target is for simulation

LIMIT = 72

if args.out: 
    out_path=args.out 
else: out_path = anml_path.split('.anml')[0]+'.vhd'

if 'OutputFiles' not in out_path:
    out_path = 'OutputFiles' + directory_delim + out_path

if not os.path.isfile(anml_path):
    print('Error: ANML file does not exist!')
    exit(1)

if args.target:
    target = args.target

# testbench generation
stimulus_file = ""
if target == "tb":
    if not args.stimulus:
        print("Error: Testbench mode required a stimulus (-s) input!")
        exit(1)
    else:
        stimulus_file = os.path.basename(args.stimulus) + ".bin"

    # Generate stimulus file
    text2bin(args.stimulus, stimulus_file)

language = ''    
if not args.language:
    language = 'VHDL'
else:
    if args.language == 'vhd':
        language = 'VHDL'
    elif args.language == 'v':
        language = 'Verilog'
    elif args.language == 'c':
        language = 'C'
        target = 'xilinx'
    else:
        print('Error: Language must be VHDL (--language vhd), \
                Verilog (--language v), or \
                C (--language c)')
        exit(1)

# Testbench mode only supports VHDL
if target == "tb":
    language = "VHDL"

rightmin = False        
if args.rightmin:
    rightmin = True 

vote = False
if args.vote:
    vote = rightmin and args.vote

bramlimit = 1080
if args.bramlimit:
    bramlimit = int(args.bramlimit)

double = False
if args.double:
    double = True

context['entity'] = args.entity
    
# Parse ANML
tree = ET.parse(anml_path)
root = tree.getroot()

STE_vec = []
STE_table = { }
OR_vec = []
AND_vec = []
Counter_vec = []
Report_Addresses = { }
RightMinMap = { }
connections = { } # Maps from input port to targets
                  # e.g. A activates B, C, D
                  # connections[A] = [B, C, D]

number_of_reports = 0                  
num_id = 0
# Populate an array of STEs from the ANML file
for child in root.iter('state-transition-element'):
    curr_id = child.get('id')
    curr_sym_set = child.get('symbol-set')
    curr_start = child.get('start') or ''
    curr_report = ''
    curr_activates = []

    if target == 'logic':
        curr_resource = 'logic'
    else:
        curr_resource = 'bram'

    for child2 in child:
        if child2.tag == 'report-on-match':
            if child2.get('reportcode'):
                curr_report = child2.get('reportcode')
            else:
                curr_report = '0'
            Report_Addresses[curr_id] = number_of_reports
            if rightmin:
                if curr_report in RightMinMap:
                    RightMinMap[curr_report].append(curr_id)
                else:
                    RightMinMap[curr_report] = [curr_id]
            number_of_reports += 1
        if child2.tag == 'activate-on-match':
            curr_activates.append(child2.get('element'))
    ste_i = STE(id=curr_id,
                symbol_set = curr_sym_set,
                start = curr_start,
                report = curr_report,
                activates = curr_activates,
                target = target,
                num_id = num_id,
                resource = curr_resource)        
    STE_vec.append(ste_i)
    STE_table[ste_i.id] = ste_i
    # Append this STE's activations to the connections map
    connections[curr_id] = curr_activates
    num_id += 1

STE_vec_2x = []
connections_2x = {}
STE_table_2x = {}

if double: # read 2 symbols per cycle
    num_id = 0
    start_idx = 0
    report_idx = 0
    number_of_reports = 0
    Report_Addresses = {}
    temp_buf = []
    # prepend new start states
    print('Prepending new start states...')
    for ste in STE_vec:
        if ste.start:
            STE_new = STE(id='start_2x'+ste.id,
                    symbol_set = '[.]',
                    start = 'all-input',
                    report = ste.report,
                    activates = [ste.id],
                    num_id = num_id,
                    resource = 'logic',
                    target = ste.target)
            temp_buf.append(STE_new)
            STE_table[STE_new.id] = STE_new
            connections[STE_new.id] = STE_new.activates
            num_id += 1
    # append new report states
    print('Appending new report states...')
    RightMinMap = {}
    new_reports = 0
    for ste in STE_vec:
        if ste.report:
            STE_new = STE(id='report_2x'+ste.id,
                    symbol_set = '[.]',
                    start = ste.start,
                    report = ste.report,
                    activates = [],
                    num_id = num_id,
                    resource = 'logic',
                    target = ste.target)
            ste.activates.append(STE_new.id)
            temp_buf.append(STE_new)
            STE_table[STE_new.id] = STE_new
            num_id += 1
            connections[STE_new.id] = STE_new.activates    
            new_reports += 1
    print(new_reports, 'new reporting states added')
    for ste in temp_buf:
        STE_vec.append(ste)
    # merge states
    print('Merging...')
    prefix_table = {}
    for ste in STE_vec:
        for name1 in ste.activates:
            ste_next = STE_table[name1]
            STE_new = STE(id=ste.id+'MERGED'+name1,
                    symbol_set = ste.symbol_set_string,
                    symbol_set2 = ste_next.symbol_set_string,
                    start = ste.start,
                    report = ste_next.report,
                    num_id = num_id,
                    resource = 'logic',
                    target = ste.target,
                    activates = [])
            num_id += 1
            if STE_new.start:
                start_idx += 1
            if STE_new.report:
                report_idx += 1
                Report_Addresses[STE_new.id] = number_of_reports
                number_of_reports += 1
                if rightmin:
                    if STE_new.report in RightMinMap:
                        RightMinMap[STE_new.report].append(STE_new.id)
                    else:
                        RightMinMap[STE_new.report] = [STE_new.id]
            prefix = STE_new.id.split('MERGED')[0]
            if prefix not in prefix_table:
                prefix_table[prefix] = [STE_new]
            else:
                prefix_table[prefix].append(STE_new)
            STE_vec_2x.append(STE_new)
    # new connections
    print('Connecting states...')
    for ste in STE_vec_2x:
        # connect the suffix of this STE to its entry in connections table
        suffix = ste.id.split('MERGED')[1]
        original_sinks = connections[suffix]
        for sink in original_sinks:
            if sink not in prefix_table: continue
            new_sinks = prefix_table[sink]
            for new_sink in new_sinks:
                if ste.id not in connections_2x:
                    connections_2x[ste.id] = [new_sink.id]
                else:
                    connections_2x[ste.id].append(new_sink.id)
    connections = connections_2x
    STE_vec = STE_vec_2x
    print('Graph transformation complete!')
    
# Extract all OR gates
for child in root.iter('or'):
    curr_id = child.get('id')
    curr_report = ''
    curr_activates = []
    for child2 in child:
        if child2.tag == 'report-on-high':
            curr_report = child2.get('reportcode')
            Report_Addresses[curr_id] = number_of_reports
            number_of_reports += 1
        if child2.tag == 'activate-on-high':
            curr_activates.append(child2.get('element'))
    or_i = OR(id = curr_id,
                report = curr_report)
    OR_vec.append(or_i)
    connections[curr_id] = curr_activates

# Extract all AND gates
for child in root.iter('and'):
    curr_id = child.get('id')
    curr_report = ''
    curr_activates = []
    for child2 in child:
        if child2.tag == 'report-on-high':
            curr_report = child2.get('reportcode')
            Report_Addresses[curr_id] = number_of_reports
            number_of_reports += 1
        if child2.tag == 'activate-on-high':
            curr_activates.append(child2.get('element'))
    and_i = AND(id = curr_id,
                report = curr_report)
    AND_vec.append(or_i)
    connections[curr_id] = curr_activates
    
# Extract all counters
for child in root.iter('counter'):
    curr_id = child.get('id')
    curr_target = child.get('target')
    curr_at_target = child.get('at-target')
    curr_report = ''
    curr_activates = []
    for child2 in child:
        if child2.tag == 'report-on-target':
            curr_report = child2.get('reportcode')
            Report_Addresses[curr_id] = number_of_reports
            number_of_reports += 1
        if child2.tag == 'activate-on-target':
            curr_activates.append(child2.get('element'))
    counter_i = Counter(id = curr_id,
                        report = curr_report,
                        target = curr_target,
                        at_target = curr_at_target)
    Counter_vec.append(counter_i)
    connections[curr_id] = curr_activates    
    

# Inverse connections map
inverse_connections = { }
for k, v in list(connections.items()):
    for item in v:
        if item in inverse_connections:
            inverse_connections[item].append(k)
        else:
            inverse_connections[item] = [k]
        
context['report_length'] = number_of_reports
context['STE_vec'] = STE_vec
context['OR_vec'] = OR_vec
context['AND_vec'] = AND_vec
context['Counter_vec'] = Counter_vec
context['connections'] = connections
context['inverse_connections'] = inverse_connections
context['Report_Addresses'] = Report_Addresses
context['rightmin'] = rightmin
context['RightMinMap'] = RightMinMap
context['rightmin_len'] = len(RightMinMap)
context['target'] = target
context['bramlimit'] = bramlimit
context['vote'] = vote
context['double'] = double

lenmax = 0
for id in RightMinMap:
    if len(RightMinMap[id]) > lenmax:
        lenmax = len(RightMinMap[id])
context['DATA_LENGTH'] = lenmax
context["tb_infile"] = stimulus_file

env = Environment(loader=FileSystemLoader('./Templates'), trim_blocks=True, lstrip_blocks=True)
template = env.get_template(language + '_' + target + '.template')

# Render the template for the output file.
rendered_file = template.render(context=context)


# Write output file
with open(out_path, 'w') as outFile:
    outFile.write(rendered_file)
    
if language == 'C':
    env = Environment(loader=FileSystemLoader('./Templates'), trim_blocks=True, lstrip_blocks=True)
    template = env.get_template('C_params.template')

    # Render the template for the output file.
    rendered_file = template.render(context=context)

    # Write output file
    with open('OutputFiles' + directory_delim + 'Params.h', 'w') as outFile:
        outFile.write(rendered_file)
    
## Render template for component declaration file.
#template = env.get_template('COMPONENT.template')
#rendered_file = template.render(context=context)
#
## Write output for component declaration file
#with open(out_path+'.cmp', 'w') as outFile:
#    outFile.write(rendered_file)
#    
## Write STE id => report vector mappings to ReportMapping.txt
#mapping_filename = 'OutputFiles' + directory_delim + args.entity + '_ReportMapping.txt'
#fd = open(mapping_filename, 'w')
#fd.truncate()

# Generate initialization ROM for STE bit vectors
# if (target == 'altera'):
    # ROM(STE_vec)
    
if (target == 'xilinx'):
    num_bram = len(STE_vec) // LIMIT + 1
    if num_bram > bramlimit:
        num_bram = bramlimit
    for i in range(num_bram):
        name_i = 'bram' + str(i)
        start = LIMIT*i
        stop = LIMIT*i+LIMIT

        if stop > len(STE_vec):
            stop = len(STE_vec)

        idx = slice(start, stop)
        ROM_xilinx(STE_vec[idx], name_i, LIMIT)

#for ste in STE_vec:
#    if ste.report:
#        line = str(context['Report_Addresses'][ste.id]) + '|' + ste.id + '\n'
#        fd.write(line)
#for ORgate in OR_vec:
#    if ORgate.report:
#        line = str(context['Report_Addresses'][ORgate.id]) + '|' + ORgate.id + '\n'
#        fd.write(line)    
    
#fd.close()

# Computer clustering coefficient
cc = clustering_coefficient(connections)

print("Number of states:", len(STE_vec))
print("Reporting elements:", number_of_reports)
if rightmin: 
    print("Elements after right-minimization:", len(RightMinMap))
print("Clustering coefficient:", cc)

