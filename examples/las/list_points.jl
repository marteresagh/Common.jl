using FileManager
using Common
using Visualization

source = raw"D:\pointclouds\terreni\cava.laz"

PC = FileManager.las2localcoords(source)
PC2 = FileManager.las2pointcloud(source)

V = PC.coordinates .+ PC.offset

Visualization.VIEW([
        Visualization.points(PC.coordinates; color= Visualization.COLORS[4],  alpha = 0.2)
        Visualization.points(PC2.coordinates; color= Visualization.COLORS[2],   alpha = 0.2)
    ])


PC1 = FileManager.source2pc(raw"C:\Users\marte\Documents\GEOWEB\test\VECT_GLOBAL\VECT\POINTCLOUDS\PARTITIONS\fitted.las", 2)
PC2 = FileManager.source2pc(raw"C:\Users\marte\Documents\GEOWEB\test\VECT_GLOBAL\VECT\POINTCLOUDS\FULL\slice.las", 2)

Visualization.VIEW([
        Visualization.points(PC1.coordinates; color=Visualization.COLORS[1], alpha = 0.2)
        Visualization.points(PC2.coordinates; color=Visualization.COLORS[2], alpha = 0.2)
])
