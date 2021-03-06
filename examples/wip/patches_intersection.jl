# using Common
# using Visualization
#
# p = Plane([0,0,1.],4*rand(3))
# q = Plane([1,0,0.],2*rand(3))
# r = Plane([0,1,0.],3*rand(3))
# s = Plane([0,0,1.],-rand(3))
# t = Plane(rand(3),2*rand(3))
# u = Plane([0,1,0.],-2*rand(3))
# v = Plane(rand(3),-4*rand(3))
# z = Plane([1,0,0.],6*rand(3))
# aabb = AABB(10,-10,10,-10,10,-10)
#
# planes = [p,q,r,s,t,u,v,z]
#
# aabbs = fill(aabb,length(planes))
#
# rV,rEV,rFV = Common.DrawPatches(planes, aabbs)
# V,FVs = Common.models_intersection(rV,rEV,rFV)
#
# GL.VIEW( GL.GLExplode(V,FVs,1.5,1.5,1.5,99,1) );
# GL.VIEW( [Visualization.points(V),GL.GLGrid(V,union(FVs...)) ]);
#
# #
# # V = [1 6  6 1 1 6. 6 4 1; 1 1 6 6 3 3 3 3 3 ;0 0 0 0 -2 -2 6 8 6]
# # FV = [[1,3,2,4],[8,7,6,5,9]]
# # EV =  [[1,2],[2,3],[3,4],[4,1],[5,6],[7,6],[7,8],[8,9],[5,9]]
# #
# # GL.VIEW([
# # 	GL.GLGrid(V,FV,GL.COLORS[1],1.0)
# # ])
# #
# # copEV = Lar.coboundary_0(EV::Lar.Cells);
# # copFE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells);
# # W = convert(Lar.Points, V');
# #
# # rV, rcopEV, rcopFE = Lar.Arrangement.spatial_arrangement_1( W,copEV,copFE,false)
# #
# # #
# # triangulated_faces = Lar.triangulate(rV, [rcopEV, rcopFE]);
# # FVs = convert(Array{Lar.Cells}, triangulated_faces);
# # V = convert(Lar.Points, rV');
# # GL.VIEW( GL.GLExplode(V,FVs,1.5,1.5,1.5,99,1) );
# # #
# # #
# # GL.VIEW( [GL.GLPoints(convert(Lar.Points,V')),GL.GLGrid(V,union(FVs...)) ]);
