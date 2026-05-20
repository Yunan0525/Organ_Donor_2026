import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

df = pd.read_table('plot.data.txt', sep="\t", header=0)
pco1 = df.loc[:,"PCo1"]
pco2 = df.loc[:,"PCo2"]
pco3 = df.loc[:,"PCo3"]
color = df.loc[:,"Color"]

fig = plt.figure(figsize = (8,8))
ax = plt.axes(projection='3d')
ax.grid()

ax.scatter(pco1, pco2, pco3, c=color, s=200)
ax.set_title('Principal Coordinate Analysis of Species Correlation')

ax.set_xlabel('PCo1 (16.65%)', labelpad=20)
ax.set_ylabel('PCo2 (15.07%)', labelpad=20)
ax.set_zlabel('PCo3 (12.04%)', labelpad=20)

plt.savefig('plot-3D.pdf')
