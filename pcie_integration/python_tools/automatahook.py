# -*- coding: utf-8 -*-
"""

@author: bochunkun
"""

import sys
import math

report_count = int(sys.argv[1])filename = sys.argv[2]entityname = sys.argv[3]#VINH ADDED

linenumber_for_assing_gmem = -1#VINH ADDEDlinenumber_for_assign_tmp = -1#VINH ADDED
if report_count > 512: 
    if report_count%512==0:
        mem_bank_count = report_count/512
        #print mem_bank_count
    else:
        mem_bank_count = report_count/512 + 1
        #print mem_bank_count
    remainder = report_count%512
    if (remainder>0 and remainder<=2):
        lastbit = 1
    if (remainder>2 and remainder<=4):
        lastbit = 3
    if (remainder>4 and remainder<=8):
        lastbit = 7
    if (remainder>8 and remainder<=16):
        lastbit = 15
    if (remainder>16 and remainder<=32):
        lastbit = 31
    if (remainder>32 and remainder<=64):
        lastbit = 63
    if (remainder>64 and remainder<=128):
        lastbit = 127
    if (remainder>128 and remainder<=256):
        lastbit = 255
    if (remainder>256 and remainder<=511) or remainder==0:
        lastbit = 511
    #print lastbit

    i=0
    linenumber_for_I_WDATA = []

    with open(filename) as f:
        for line in f:
            if '.I_WDATA' in line and len(line)>20:
                #print line
                linenumber_for_I_WDATA.append(i)
            i=i+1
            if 'assign resultAB_fu' in line and len(line)>35:
                #print line
                linenumber_for_assign = i
            if 'assign tmp_3_fu' in line and len(line)>35:
                #print line
                linenumber_for_assign_tmp = i
            if '<= resultAB_fu' in line:
                #print line
                linenumber_for_always = i
            if 'loadAB_reg' in line and len(line)==28:
                #print line[23:26]
                loadAB_reg_number = int(line[23:26])
            if 'assign gmem' in line:
                #print line
                linenumber_for_assing_gmem = i

    numberoflines = i
    #print numberoflines
    #print linenumber_for_I_WDATA

    f=open(filename)
    lines = f.readlines()
    j=1
    for i in range(numberoflines):
        #for j in range(len(linenumber_for_I_WDATA)):
            #if i == linenumber_for_I_WDATA[j]:
                #print '//' + lines[i],
                #print '    .I_WDATA(gmem%d_WDATA),' %(j+1)

        if i in linenumber_for_I_WDATA:
            print '//' + lines[i],
            print '    .I_WDATA(gmem%d_WDATA),' %(j)
            j=j+1

        elif report_count%512!=0:
            if i == linenumber_for_always-3:
                print '//' + lines[i],
            elif i == linenumber_for_always-2:
                reg_num = int(lines[i][81:84])
                print '//' + lines[i],
            elif i == linenumber_for_always-1:
                print '//' + lines[i],
            elif i == linenumber_for_always:
                print '//' + lines[i],
            elif i == linenumber_for_always+1:
                print '//' + lines[i],
            
            elif i == linenumber_for_assing_gmem-1:
                print '//' + lines[i],

            elif i == linenumber_for_assign-1:
                print '//' + lines[i],
                print ''
                print 'wire [7:0]   automata_indata;'
                print 'wire [%d:0] automata_reports;'  %(report_count-1)
                print 'reg [%d:0] automata_reports_reg;' %(512*(mem_bank_count-1)+lastbit)
                for k in range(mem_bank_count-1):
                    print 'wire [511:0] gmem%d_WDATA;' %(k+1)
                if (linenumber_for_assing_gmem == -1):#VINH ADDED IF STATEMENT                    print 'wire [%d:0] gmem%d_WDATA;' %(lastbit,(k+2))#VINH UNCOMMENTED THIS

                print ''
                print 'assign automata_indata = loadAB_reg_%d;' %loadAB_reg_number
                print ''
                print '%s automata_U('  %(entityname)#VINH ADDED
                print '    .clock(ap_clk),'
                print '    .reset(1\'b0),'
                print '    .run(1\'b1),'
                print '    .data_in(automata_indata),'
                print '    .reports(automata_reports)'
                print ');'

                print ''
                print 'always @ (posedge ap_clk) begin'
                print '    if (((ap_block_pp0_stage0_11001 == 1\'b0) & (1\'d0 == ap_reg_pp0_iter1_tmp_reg_%d))) begin' %reg_num
                print '        automata_reports_reg[%d:0]    <= automata_reports;' %(report_count-1)
                if report_count%512 != 0 and (remainder!=128 and remainder!= 64 and remainder!= 32 and remainder!= 16 and remainder!= 8 and remainder!= 4 and remainder!= 2 and remainder!= 256): 
                    print '        automata_reports_reg[%d:%d]<= %d\'d0;' %(512*(mem_bank_count-1)+lastbit,report_count,512*(mem_bank_count-1)+lastbit-report_count+1)
                print '    end'
                print 'end'

            elif i == linenumber_for_assign_tmp-1:
                print '//' + lines[i]
                for k in range(mem_bank_count-1):
                    print 'assign gmem%d_WDATA = automata_reports_reg[%d:%d];' %(k+1, 512*(k+1)-1, 512*k)
                print 'assign gmem%d_WDATA = automata_reports_reg[%d:%d];' %(k+2, 512*(k+1)+lastbit, 512*(k+1))        

            else:
                
                print lines[i],

        else:
            if i == linenumber_for_always-3:
                print '//' + lines[i],
            elif i == linenumber_for_always-2:
                reg_num = int(lines[i][81:84])
                print '//' + lines[i],
            elif i == linenumber_for_always-1:
                print '//' + lines[i],
            elif i == linenumber_for_always:
                print '//' + lines[i],
            elif i == linenumber_for_always+1:
                print '//' + lines[i],

            elif i == linenumber_for_assign-1:
                print '//' + lines[i],
                print ''
                print 'wire [7:0]   automata_indata;'
                print 'wire [%d:0] automata_reports;'  %(report_count-1)
                print 'reg [%d:0] automata_reports_reg;' %(512*(mem_bank_count-1)+lastbit)
                for k in range(mem_bank_count-1):
                    print 'wire [511:0] gmem%d_WDATA;' %(k+1)
                print 'wire [%d:0] gmem%d_WDATA;' %(lastbit+1,(k+2))

                print ''
                print 'assign automata_indata = loadAB_reg_%d;' %loadAB_reg_number
                print ''
                print '%s automata_U('  %(entityname)#VINH ADDED
                print '    .clock(ap_clk),'
                print '    .reset(1\'b0),'
                print '    .run(1\'b1),'
                print '    .data_in(automata_indata),'
                print '    .reports(automata_reports)'
                print ');'

                print ''
                print 'always @ (posedge ap_clk) begin'
                print '    if (((ap_block_pp0_stage0_11001 == 1\'b0) & (1\'d0 == ap_reg_pp0_iter1_tmp_reg_%d))) begin' %reg_num
                print '        automata_reports_reg[%d:0]    <= automata_reports;' %(report_count-1)
                if report_count%512 != 0: 
                    print '        automata_reports_reg[%d:%d]<= %d\'d0;' %(512*(mem_bank_count-1)+lastbit,report_count,512*mem_bank_count-report_count)
                print '    end'
                print 'end'



            elif i == linenumber_for_assign_tmp-1:
                print '//' + lines[i]
                for k in range(mem_bank_count-1):
                    print 'assign gmem%d_WDATA = automata_reports_reg[%d:%d];' %(k+1, 512*(k+1)-1, 512*k)
                print 'assign gmem%d_WDATA = automata_reports_reg[%d:%d];' %(k+2, 512*(k+1)+lastbit, 512*(k+1))        

            else:
                print lines[i],

else:
    if (report_count>0 and report_count<=2):
        reg_size = 1
    if (report_count>2 and report_count<=4):
        reg_size = 3
    if (report_count>4 and report_count<=8):
        reg_size = 7
    if (report_count>8 and report_count<=16):
        reg_size = 15
    if (report_count>16 and report_count<=32):
        reg_size = 31
    if (report_count>32 and report_count<=64):
        reg_size = 63
    if (report_count>64 and report_count<=128):
        reg_size = 127
    if (report_count>128 and report_count<=256):
        reg_size = 255
    if (report_count>256 and report_count<=512):#VINH CHANGED to <=512 instead of <512
        reg_size = 511
    with open(filename) as f:
        i=0
        for line in f:
            if 'assign resultAB_fu' in line and len(line)>35:
                #print line
                linenumber_for_assign = i
            if 'assign tmp_3_fu' in line and len(line)>35:
                #print line
                linenumber_for_assign_tmp = i
            if '<= resultAB_fu' in line:
                #print line
                linenumber_for_always = i
            if 'loadAB_reg' in line and len(line)==28:
                #print line[23:26]
                loadAB_reg_number = int(line[23:26])
            if 'assign gmem' in line:
                #print line
                linenumber_for_assing_gmem = i
            i=i+1

    numberoflines = i

    f=open(filename)
    lines = f.readlines()
    for i in range(numberoflines):
        if i == linenumber_for_assing_gmem:
            print '//' + lines[i],

        elif i == linenumber_for_always-2:
            print '//' + lines[i],
        elif i == linenumber_for_always-1:
            reg_num = int(lines[i][81:84])
            print '//' + lines[i],
        elif i == linenumber_for_always:
            print '//' + lines[i],
        elif i == linenumber_for_always+1:
            print '//' + lines[i],
        elif i == linenumber_for_always+2:
            print '//' + lines[i],

        elif i == linenumber_for_assign:
            print '//' + lines[i],
            print 'wire [7:0]   automata_indata;'
            print 'wire [%d:0] automata_reports;'  %(report_count-1)
            print 'reg [%d:0] automata_reports_reg;' %reg_size
            print ''
            print 'assign automata_indata = loadAB_reg_%d;' %loadAB_reg_number

            print ''
            print '%s automata_U('  %(entityname)#VINH ADDED
            print '    .clock(ap_clk),'
            print '    .reset(1\'b0),'
            print '    .run(1\'b1),'
            print '    .data_in(automata_indata),'
            print '    .reports(automata_reports)'
            print ');'

            print ''
            print 'always @ (posedge ap_clk) begin'
            print '    if (((ap_block_pp0_stage0_11001 == 1\'b0) & (1\'d0 == ap_reg_pp0_iter1_tmp_reg_%d))) begin' %reg_num
            print '        automata_reports_reg[%d:0]    <= automata_reports;' %(report_count-1)
            if report_count!=(reg_size+1):
                print '        automata_reports_reg[%d:%d]<= %d\'d0;' %(reg_size,report_count,reg_size-report_count+1)
            print '    end'
            print 'end'

            print ''
            print 'assign gmem1_WDATA = automata_reports_reg;'

        else:
            print lines[i],


