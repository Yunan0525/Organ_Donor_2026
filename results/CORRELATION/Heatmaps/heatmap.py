import seaborn as sns
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

#sns.set(rc={'figure.figsize':(44,34)})

df = pd.read_csv("LARGE.heatmap.txt", sep='\t', header=0)

df_wide = df.pivot_table(index='Species1', columns='Species2', values='Values')
heatmap = sns.clustermap(df_wide, metric="euclidean", standard_scale=1,
                         method="complete", yticklabels=True, xticklabels=True)
#print(heatmap.ax_heatmap.get_xticklabels())
[x, y] = heatmap.ax_heatmap.get_position().p1
h = heatmap.ax_heatmap.get_position().height
heatmap.ax_cbar.set_position([0.8, 1-x, 0.025, h])
#heatmap = sns.heatmap(df_wide)
fig = heatmap.figure
fig.set(figheight=35, figwidth=35)
fig.savefig("LARGE+Dendro.png",dpi=300) 

