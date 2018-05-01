import sys
import math

def blast_alignment(sequence1, sequence2):
    S1 = {}
    S2 = {}

    count = 0
    for i in range(0, len(sequence1)-8, 1):
        subseq1 = sequence1[i:i+9]
        S1[subseq1] = i

    for j in range(0, len(sequence2)-8, 1):
        subseq2 = sequence2[j:j+9]
        S2[subseq2] = j

    S1keys = list(S1.keys())
    for i in range(0, len(S1keys), 1):
        key = S1keys[i]
        if(S2.get(key) != None):
            count = count + 1

    return count
##MAIN##
sequences = []
with open("genome_database.fasta", "r") as f:
          lines =f.readlines()
          for i in range(1, len(lines), 2):
              sequences.append(lines[i])
          
d = []
for i in range(len(sequences)):
          d.append([])
          for j in range (len(sequences)):
              d[i].append(0)
                  
          
for i in range(len(sequences)):
          d[i][i]=0
          for j in range(i+1, len(sequences)):
              ck = blast_alignment(sequences[i], sequences[j])
              d[i][j]=(-(math.log(ck/min(len(sequences[i]), len(sequences[j])))))
              d[j][i] = d[i][j]

for i in range(len(d)):
          for j in range(len(d[i])):
              sys.stdout.write(str(d[i][j]) + " ")
              print()

    

          
