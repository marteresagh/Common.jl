using Common
using Visualization
using FileManager

file = raw"C:\Users\marte\Documents\potreeDirectory\pointclouds\sezione_castel_ferretti"
PC = FileManager.source2pc(file,3)
cloudmeta = FileManager.CloudMetadata(file)
aabb = cloudmeta.tightBoundingBox
# aabb = AABB(1,0,1,0,1,0)
model = Common.getmodel(aabb)
# V,EV,FV = Common.DrawPlanes(plane,aabb)

plane = Plane(-6.071124758473978e-6, -2.2152814291501165e-5, 0.9999999997361972, 1.9996707189980685)
Visualization.VIEW([Visualization.points(Common.apply_matrix(plane.matrix,PC.coordinates)[1:2,:],PC.rgbs)])

matrix = [0.7596351695707346 0.6503494512871695 1.90189105094e-5 0.0; -0.6503494515369278 0.759635169485807 1.28797041854e-5 0.0; -6.0711247585e-6 -2.21528142915e-5 0.999999999736197 -1.9996707189980685; 0.0 0.0 0.0 1.0]
Visualization.VIEW([Visualization.points(Common.apply_matrix(matrix,PC.coordinates)[1:2,:],PC.rgbs)])
