#!/usr/bin/python3

# this code generates a Sum Of Products equation in VHDL from a csv truth table organized like
# Q3,Q2,Q1,Q0
# 1,1,1,1
#
# default files: data.csv and equ.txt
# it can take input and output arguments, and has a -h help function

# SOP: 1's: ( * * * ) + ( * * * )


import sys, getopt, csv, os
def msop(argv):

    # hard-coded values for now 
    varNames = ["Q0","Q1","Q2","Q3"]
    varMaxIndex = 3

    #argument taking code
    inputfile = ''
    outputfile = ''
    try:
       opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
       print ('msop.py -i <inputfile> -o <outputfile>')
       #sys.exit(2)
    for opt, arg in opts:
       if opt == '-h':
          print ('msop.py -i <inputfile> -o <outputfile>')
          sys.exit()
       elif opt in ("-i", "--ifile"):
          inputfile = arg
       elif opt in ("-o", "--ofile"):
          outputfile = arg

    # check for filenames
    if inputfile != '':
        infn = inputfile
    else:
        infn = 'data.csv'
    if outputfile != '':
        outfn = outputfile
    else:
        outfn = 'equ.txt'
    
    outFile = open(outfn,'w')
    csv_file = open(infn)
    csv_reader = csv.reader(csv_file,delimiter=',')

    line_count = 0
    for row in csv_reader:
        if line_count == 0: #name row
            line_count += 1
        else:
            if line_count == 1: #no OR on first row, for syntax
                outFile.write("   (")
            else:
                outFile.write("OR (")
                
            for qNum in reversed(range(len(varNames))): #0, 1, 2, ..., varMaxIndex
                if (qNum == varMaxIndex): #Q3, start of line
                    if row[qNum] == '0': # not
                        outFile.write(" NOT " + varNames[qNum] )
                    if row[qNum] == '1': # empty space 
                        outFile.write("     " + varNames[qNum] )

                else: # all the rest of the row
                    if row[qNum] == '0': # and not
                        outFile.write(" AND NOT " + varNames[qNum] )
                    if row[qNum] == '1': # and
                        outFile.write(" AND     " + varNames[qNum] )

            outFile.write(" )\n")
            line_count += 1
        
    
    outFile.close()
    csv_file.close()


if __name__ == "__main__":
    msop(sys.argv[1:])
    print("done...")