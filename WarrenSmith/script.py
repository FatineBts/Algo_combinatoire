#!/usr/bin/python

# Pour utiliser ce script donner un fichier sous la forme
# NbPoint
# NbDimension
# x1 x2 x3 ... xD //(ligne 1)
# .
# .
# x1 x2 x3 ... xD //(ligne N)

# Ce script ecrira toutes les topologies trouvees par l'algorithme de Smith
# Et dessinera la meilleure.
# Tous les fichiers se trouveront dans un dossier nommé archive + nom du fichier pris en archive

import sys
import os
from subprocess import PIPE, Popen

dessin = True
if len(sys.argv) !=2 :
	print("Error, entrez un fichier à traiter")
	sys.exit(0)
f_name = sys.argv[1]

f = open(f_name,'r')
infos = f.read().split('\n')
N = int(infos[0].replace('\t', '').replace(' ',''))
d = int(infos[1].replace('\t', '').replace(' ',''))
X = []
for i in range(N):
	temp = infos[i+2].split(' ')
	X.append([float(j) for j in temp if j!= '' and j!='\t'])


p = Popen(['./wds_smt_timing'], shell=True, stdin=PIPE, stdout=PIPE)


msg = bytes(str(N)+'\n', 'UTF-8')
p.stdin.write(msg)

msg = bytes(str(d)+'\n', 'utf-8')
p.stdin.write(msg)


for i in range(N):
	for j in range(d):
		p.stdin.write(bytes(str(X[i][j])+'\n', 'utf-8'))

(out, err) = p.communicate(bytes('\n','UTF-8'))
result = out.decode("utf-8")


topo = [] # peut contenir plusieurs topo optimales
# sera sous la forme (longueur, Steiner points, edges)


# On recupere notre distance
lines = result.split('\n')
i = 0
while(i<len(lines)):
	if lines[i][0:3] == 'new' : # recuperons la longueur
		longueur =float(lines[i][18:])
	if lines[i][0:3] == 'ste' : # recuperons les Steiner points
		S = []
		for point in range(N-2):
			S.append([float(coor) for coor in lines[i+point+1].split(' ') if coor!='' and coor!='\n'])
		i = i + N - 2
	if lines[i][0:3] == 'edg':
		E = []
		for edg in lines[i+1].split(';')[:-1]:
			pont = []
			for point in edg.split('-') :
				pont.append(int(point))
			E.append(pont)
		i+=1
		# On a fini une topologie ici
		topo.append((longueur, S, E))
	if lines[i][0:3] == 'Too':
		time = float(lines[i].split(' ')[4])
	i+=1


# Ecriture des topos
dossier = "archives_" + (f_name.split('/')[-1]).split('.')[0]
print(dossier)
try:
    os.mkdir(dossier)
except OSError:
    pass

for idx, i in enumerate(topo):
	
	fichier = open(dossier+"/" + str(idx) + ".topo", "w")
	fichier.write("topologie : " + str(idx) + '\n')
	fichier.write("longueur : " + str(i[0]) + '\n')
	fichier.write("Terminaux :\n")
	for x in X:
		for xi in x:
			fichier.write(str(xi) + ' ')
		fichier.write('\n')
	fichier.write("Points Steiner :\n")
	for x in i[1]:
		for xi in x:
			fichier.write(str(xi) + ' ')
		fichier.write('\n')
	fichier.write("Edges :\n")
	for x in i[2]:
		for xi in x:
			fichier.write(str(xi) + ' ')
		fichier.write('\n')
	fichier.close()

fichier = open(dossier+"/" + "tableau_longueur.txt", "w")
for idx, i in enumerate(topo):
	fichier.write('-'*30 + '\n')
	fichier.write('| topo ' + str(idx) + ': ' + str(i[0]) + ' |\n')
fichier.write('-'*30 +'\n')
fichier.close()

#Dessin de la meilleur topo
j = 0
for i in range(len(topo)):
	if topo[i][0]<topo[j][0]:
		j = i

os.system("python3 draw.py " + dossier + "/" + str(i) + ".topo "+ dossier) 
