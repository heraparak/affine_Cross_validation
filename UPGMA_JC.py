import math
Import py

### Functions ###
def newick(root, newick_tree, L, R):
        
        l = L[root]
        r = R[root]

        if(l == -1 and r == -1):
                name = data[2*root]
                name = name.partition(' ')[2]
                name = name.partition(',')[0]
                newick_tree += name
                return newick_tree
        else:
                newick_tree += "("
                newick_tree = newick(l, newick_tree, L, R)
                newick_tree += ","
                newick_tree = newick(r, newick_tree, L, R)
                newick_tree += ")"
                return newick_tree
                
def get_min_pair(d):
        min = 1000000
        min_i = -1
        min_j = -1
        for i in range(0, len(d), 1):
                for j in range(0, len(d[i]), 1):
                        if(i != j and d[i][j] != "X" and d[i][j] < min):
                                min = d[i][j]
                                min_i = i
                                min_j = j
        return [min_i, min_j]

def add_new_node(P, L, R, best_i, best_j, new_node_id, leaves):
        L[new_node_id] = best_i
        R[new_node_id] = best_j
        P[best_i] = new_node_id
        P[best_j] = new_node_id
        leaves[new_node_id] = leaves[best_i] + " " + leaves[best_j]     

def distance(a, b, leaves, D):
        l_a = leaves[a].split()
        l_b = leaves[b].split()
        sum = 0
        for i in range(len(l_a)):
                for j in range(len(l_b)):               
                        sum += D[int(l_a[i])][int(l_b[j])]
 
        average = (sum)/(len(l_a) * len(l_b))
        return average

def update_matrix(best_i, best_j, new_node_id, d, D, leaves):
        for i in range(0, len(d), 1):
                d[best_i][i] = 'X'
                d[best_j][i] = 'X'
                d[i][best_i] = 'X'
                d[i][best_j] = 'X'

        for i in range(0, new_node_id, 1):
                if(P[i] == -1):
                        d[new_node_id][i] = distance(new_node_id, i, leaves, D)
                        d[i][new_node_id] = d[new_node_id][i]

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

### Main ###
#Read matrix from file and initialize distance matrices
data = open("genome_database.fasta").readlines()

sequences = []
with open("genome_database.fasta", "r") as f:
          lines =f.readlines()
          for i in range(1, len(lines), 2):
              sequences.append(lines[i])
          
D = []
for i in range(len(sequences)):
          D.append([])
          for j in range (len(sequences)):
              D[i].append(0)
                  
          
for i in range(len(sequences)):
          D[i][i]=0
          for j in range(i+1, len(sequences)):
              ck = blast_alignment(sequences[i], sequences[j])
              D[i][j]=(-(math.log(ck/min(len(sequences[i]), len(sequences[j])))))
              D[j][i] = D[i][j]

n_leaves = int(len(data)/2)
n_nodes = 2*n_leaves - 1

d = []
for i in range(0, n_nodes, 1):
        l = []
        for j in range(0, n_nodes, 1):
                l.append('X')
        d.append(l)

for i in range(0, n_leaves, 1):
        for j in range(0, n_leaves, 1):
                d[i][j] = D[i][j]

#Initialize our tree
P = []
L = []
R = []
leaves = []
for i in range(0, n_nodes, 1):
        P.append(-1)
        L.append(-1)
        R.append(-1)
        leaves.append('')

for i in range(0, n_leaves, 1):
        leaves[i] = str(i)

nodes_todo = n_leaves
new_node_id = n_leaves

while(nodes_todo > 1):

        [best_i, best_j] = get_min_pair(d)

#       print(best_i, best_j)

        add_new_node(P, L, R, best_i, best_j, new_node_id, leaves)

#       print(P, L, R, leaves)

        update_matrix(best_i, best_j, new_node_id, d, D, leaves)
        
#       for i in range(0, len(d), 1):
#               print(d[i])

        nodes_todo = nodes_todo - 1
        new_node_id = new_node_id + 1

newick_tree = ""
newick_tree = newick(new_node_id - 1, newick_tree, L, R)
print(newick_tree)


