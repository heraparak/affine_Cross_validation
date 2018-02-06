#!/usr/bin/python
# -*- coding: utf-8 -*-
import random
# We assume here that all nodes have sequences asigned
def getparsimonyscore(T, root, score):
    L = T[1]
    R = T[2]
    S = T[3]
    P = T[0]
    
    # if leave node do nothing
    if L[root] == -1 and R[root] == -1:
        return score

    # else compare assignment at root to left child
    # and right child and update the score

    if S[root] != S[L[root]]:
        score += 1
    if S[root] != S[R[root]]:
        score += 1

    score = getparsimonyscore(T, L[root], score)
    score = getparsimonyscore(T, R[root], score)

    return score

def assignsequences(T, root):

    S = T[3]
    L = T[1]
    R = T[2]
    P = T[0]

    l = L[root]
    r = R[root]
    p = P[root]

    # assign sequence at root

    if l == -1 and r == -1:
        return

    # assign to current node

    if p == -1:
        S[root] = random.choice(list(S[root]))
    elif S[p] in S[root]:

   # else if parent ssignment exists in current node

        S[root] = S[p]
    else:

        S[root] = random.choice(list(S[root]))

    assignsequences(T, L[root])
    assignsequences(T, R[root])

    # assign to left child child
    # assign child to right child
    #smallparsimony.py

def assignsets(T, root):
    S = T[3]
    L = T[1]
    R = T[2]

    if L[root] != -1:

       # postorder(P, L, R, L[root]

        assignsets(T, L[root])
    if R[root] != -1:

        # postorder(P, L, R, R[root]

        assignsets(T, R[root])

    # use the set the set function to check the intersection of the assignment to the left and right

    l = L[root]
    r = R[root]
    if l != -1 and r != -1:
        intersection = set(S[l]).intersection(set(S[r]))
        union = set(S[l]).union(set(S[r]))
        if len(intersection) != 0:
            S[root] = intersection
        else:
            S[root] = union

    print(S)
    
##MAIN

#P = [4,4,5,5,6,6,-1]
#L = [-1,-1,-1,-1,0,2,4]
#R = [-1,-1,-1,-1,1,3,5]
#S = ['A','A','C','A','','','' ]
#T = [P, L, R, S]

P = [8, 7, 6, 6, 9, 9, 7, 8, 10, 10, -1]
L = [-1,-1,-1,-1,-1,-1,2,1,0,4,8]
R = [-1,-1,-1,-1,-1,-1,3,6,7,5,9]
S = ['A', 'A', 'C', 'G', 'C', 'A', '', '', '', '', '']
T = [P, L, R, S]

assignsets(T,10)
assignsequences(T,10)
s = getparsimonyscore(T, 10, 0)
print("the node assigned information")
print(S)
print('score')
print(s)
