using FileManager
using Common
using Visualization

source = raw"C:\Users\marte\Documents\potreeDirectory\pointclouds\STANZA_CASALETTO"

PC = FileManager.source2pc(source,0)
Visualization.VIEW([
        Visualization.points(PC.coordinates; color=Visualization.COLORS[1],alpha = 0.7)
        Visualization.points(PC.coordinates[:,1:200]; color=Visualization.COLORS[2],alpha = 1.)
    ])
