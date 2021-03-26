using Common
using Visualization
using LightGraphs

V = [1. 6. 12. 12. 1. 8. 5. 4. 9. 10. 10. 9.; 1. 1. 1. 8. 8. 3. 5. 3. 6. 6. 7. 7.]
EV = [[1,2],[2,3],[3,4],[4,5],[5,1],[2,6],[6,7],[7,8],[8,2],[9,10],[10,11],[11,12],[12,9]]

GL.VIEW([
	GL.GLGrid(V,EV)
]);

g = Common.model2graph(V,EV)

gs = LightGraphs.biconnected_components(g)

comps = Common.biconnected_comps(g)
