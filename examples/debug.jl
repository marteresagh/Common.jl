using Common
using Visualization

p = [0.842021 0.234399 0.0792557;
			0.566337 0.851245 0.716292;
			0.538555 0.428459 0.0912485]

plane = Plane(p)

aabb = AABB(1,0,1,0,1,0)
model = Common.getmodel(aabb)
V,EV,FV = Common.DrawPlanes(plane,aabb)
Visualization.VIEW([Visualization.GLGrid(V,FV),Visualization.GLGrid(model[1],model[2]), Visualization.axis_helper()...])

p = [0. 1. 1. 0.;
	0. 0. 1. 1.]
Common.getArea(p)
