def text2bin(infile, outfile):
    outbuffer = ""
    with open(infile, "rb") as f:
        inbuffer = f.read()
        for i in range(len(inbuffer)):
            binstr = bin(ord(inbuffer[i]))
            binstr = binstr.split('b')[1] # get rid of 0b at the beginning
            outbuffer += ("0"*(8 - len(binstr)) + binstr) + "\n"
    with open(outfile, "wb") as fw:
        fw.write(outbuffer)
