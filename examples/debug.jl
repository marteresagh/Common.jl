using Visualization
using Common

function helper_axis(affine_matrix = Matrix{Float64}(Lar.I,4,4)::Matrix)
	T = [0 1. 0 0; 0 0 1 0; 0 0 0 1]
	V = Common.apply_matrix(affine_matrix,T)
	return [GL.GLGrid(V,[[1,2]],GL.COLORS[2],1.),GL.GLGrid(V,[[1,3]],GL.COLORS[3],1.),GL.GLGrid(V,[[1,4]],GL.COLORS[4],1.)]
end

V = [0 1;2. 0; 2 0]
aabb = AABB(2,-1,2,-1,2,-1)
axis_y = [1.,0.,0]
thickness = 0.02
p1 = V[:,1]
p2 = V[:,2]

volume = Common.plane2model(p1,p2,axis_y,thickness,aabb)
model = getmodel(aabb)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,V'),GL.COLORS[6])
	GL.GLGrid(volume[1],volume[2])
	GL.GLGrid(model[1],model[2])
	GL.GLFrame
]);
