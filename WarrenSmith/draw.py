#!/usr/bin/python

# Ce script prends un fichier cree par le script principal et dessine la topologie.
# Un deuxieme argument facultatif dans ce script donnera le chemin ou effectuer le dessin.
# Le dessin sera dans un fichier "draw_topo_i.png"

import sys
import os
from subprocess import PIPE, Popen
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

dessin = True
if len(sys.argv) <2 :
	print("Error, entrez un fichier a traiter")
	sys.exit(0)
f_name = sys.argv[1]

if(os.path.exists(f_name)!=True):
	print("Error, entrez un fichier existant a traiter")
	sys.exit(0)

sortie = "draw_" + f_name.split('/')[-1].split('.')[0]+'.png'
if len(sys.argv) == 3 :
	if sys.argv[2][-1] == '/':
		sortie = sys.argv[2] + sortie
	else:
		sortie = sys.argv[2] + '/' + sortie


f = open(f_name, "r")
lignes  = f.readlines()
f.close()

terminaux, steiner, edge = False, False, False
topo = [[],[], []] # notre topologie Terminaux, Steiner, Edges
for ligne in lignes:
	l = ligne.replace('\n','').replace('\t','')
	if ligne[0:3]=='Ter':
		terminaux = True
		steiner, edge = False, False
		continue
	elif ligne[0:3]=='Poi':
		steiner = True
		terminaux, edge = False, False
		continue
	elif ligne[0:3]=='Edg':
		edge = True
		terminaux, steiner = False, False
		continue

	
	if terminaux:
		topo[0].append([float(i) for i in l.split(' ') if i!=''])
	elif steiner:
		topo[1].append([float(i) for i in l.split(' ') if i!=''])
	elif edge:
		topo[2].append([int(i) for i in l.split(' ') if i!=''])

(X, S, E) = topo
N = len(X)
d = len(X[0])

P = X + S
minX = min([x[0] for x in P])
minY = min([x[1] for x in P])
maxX = max([x[0] for x in P])
maxY = max([x[1] for x in P])
minX = minX - 0.1* (maxX-minX)
maxX = maxX + 0.1* (maxX-minX)
minY = minY - 0.1* (maxY-minY)
maxY = maxY + 0.1* (maxY-minY)

fig = plt.figure()
if dessin == True and d==2:
	plt.plot([x[0] for x in X], [x[1] for x in X], 'ro')
	plt.plot([s[0] for s in S], [s[1] for s in S], 'go')
	for edg in E:
		plt.plot([P[edg[0]-1][0], P[edg[1]-1][0]], [P[edg[0]-1][1], P[edg[1]-1][1]], 'b')
	plt.axis([minX, maxX, minY, maxY])

elif dessin == True and d==3:
	
	ax = fig.add_subplot(111, projection='3d')
	ax.scatter([x[0] for x in X], [x[1] for x in X], [x[2] for x in X], c='r', marker='o')
	ax.scatter([s[0] for s in S], [s[1] for s in S], [s[2] for s in S], c='g', marker = 'o')
	for edg in E:
		ax.plot([P[edg[0]-1][0], P[edg[1]-1][0]], [P[edg[0]-1][1], P[edg[1]-1][1]], [P[edg[0]-1][2], P[edg[1]-1][2]], 'b')
	plt.axis([minX, maxX, minY, maxY])
fig.savefig(sortie)

