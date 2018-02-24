#!/usr/bin/python
# -*- coding: utf-8 -*-

import random


# We assume here that all nodes have sequences assigned

def getparsimonyscore(T, root, score):
    L = T[1]
    R = T[2]
    S = T[3]
    P = T[0]
    l = L[root]
    r = R[root]
    p = P[root]

    # if leave node do nothing

    if l == -1 and r == -1:
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

    if P[root] == -1:
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

##smallparsimony.py

def assignsets(T, root):

    S = T[3]
    L = T[1]
    R = T[2]
    P = T[0]

    if L[root] != -1:
        assignsets(T, L[root])
    if R[root] != -1:
        assignsets(T, R[root])

    # use the set the set function to check the intersection
    # of the assignment to the left and right

    l = L[root]
    r = R[root]
    if l != -1 and r != -1:
        intersection = set(S[l]).intersection(set(S[r]))  # add index S[l][index]
        union = set(S[l]).union(set(S[r]))
        if len(intersection) != 0:
            S[root] = intersection
        else:

            S[root] = union

 #   print (S)


def smallparsimony(T):

    P = T[0]
    L = T[1]
    R = T[2]
    S = T[3]
    score = 0
    root = -1
    for i in range(0, len(P), 1):
        if P[i] == -1:
            root = i
    if root == -1:
        print ('No root!\n')
        exit()

    nleaves = int((len(P) + 1) / 2)
    nnodes = len(P)
#    print ('nleaves', nleaves)
#    print ('nnodes', nnodes)
    for column in range(0, len(S[0]), 1):

        W = []
        for i in range(0, nleaves, 1):
            W.append(S[i][column])
#            print ('sequnce ', S[i][column])

        for i in range(nleaves, nnodes, 1):
            W.append('')

        T = [P, L, R, W]
        assignsets(T, root)
        assignsequences(T, root)

                # update S

        for i in range(nleaves, nnodes):
            S[i] += W[i]

    T = [P, L, R, S]
    
    score = getparsimonyscore(T, root, score)
    return score

P = [4, 4, 5, 5, 6, 6, -1 ]
L = [ -1, -1, -1, -1, 0, 2, 4 ]
R = [-1, -1, -1, -1, 1, 3, 5]
S = [ 'ACCA', 'ACGC', 'TCCG', 'TGGA', '', '', '']

T = [P, L, R, S]
pscore = smallparsimony(T)
print (pscore)
print (T)
