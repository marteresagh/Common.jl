using Visualization
using Common

aabb = AABB(2,0,2,0,2,0)
axis_y = rand(3)
thickness = 0.02
p2 = 2*rand(3)
p1 = 2*rand(3)
octree = Common.getmodel(aabb)

plane = Plane(p1,p2,axis_y)
p_model = Common.getmodel(p1,p2,axis_y,thickness,aabb)
p_model2 = Common.getmodel(plane, thickness, aabb)

Visualization.VIEW([
	Visualization.points(p1; color = Visualization.COLORS[2])
	Visualization.points(p2;color = Visualization.COLORS[2])
	Visualization.GLGrid(p_model[1],p_model[2])
	Visualization.GLGrid(p_model2[1],p_model2[2],Visualization.COLORS[2])
	Visualization.GLGrid(octree[1],octree[2])
	Visualization.axis_helper(Common.inv(plane.matrix))...
	Visualization.GLFrame
]);

volume = Volume([1,1,0.1],rand(3),2*pi*rand(3))
plane = Plane(volume)
p_model = Common.getmodel(volume)

Visualization.VIEW([
	Visualization.GLGrid(p_model[1],p_model[2])
	Visualization.axis_helper(Common.inv(plane.matrix))...
	Visualization.GLFrame
]);

normal = Common.normalize(rand(3))
centroid = 2*rand(3)

plane = Plane(normal,centroid)
plane2 = Plane(normal[1],normal[2],normal[3], Common.dot(normal, centroid) )

Visualization.VIEW([
	Visualization.points(centroid;color = Visualization.COLORS[2])
	Visualization.GLGrid(hcat([0,0,0.],normal),[[1,2]],Visualization.COLORS[1])
	Visualization.axis_helper(Common.inv(plane.matrix))...
	Visualization.axis_helper(Common.inv(plane2.matrix))...
	Visualization.GLFrame
]);


normal = rand(3)
centroid = rand(3)

vol = Volume([5,5,5.],[0,0,0.],[pi/3,0,pi/6])
V_int = Common.box_intersects_plane(vol, normal, centroid)
V,EV,FV = Common.getmodel(vol)

V_p, EV_p, FV_p = Common.getmodel(Plane(normal,centroid), vol)

Visualization.VIEW([
	Visualization.points(V_int)
	Visualization.GLGrid(V,EV)
	Visualization.GLGrid(V_p, FV_p)
])
