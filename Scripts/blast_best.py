#!usr/bin/python
# -- coding utf-8 --
# conda activate python3

import sys

def usage():
    print('Usage python blast_best.py [input_file] [outfile]')


def main():

    # global name
    inf = open(sys.argv[1], 'rt')
    ouf = open(sys.argv[2], 'wt')

    flag_list = []
    for line in inf:
        line = line.strip()
        name = line.split("\t")[0]
        #id = eval(line.split(t)[2])
        if name not in flag_list:
            ouf.write(line + '\n')
        else:
            continue
        flag_list.append(name)

    inf.close()
    ouf.close()

try:
    main()
except IndexError:
    usage()
    
