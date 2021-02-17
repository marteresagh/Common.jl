using Common
using Visualization
using FileManager

# filename= "C:/Users/marte/Documents/GEOWEB/pointcloud_XZ_PLANE_SLICE_AT_QUOTE_15.4525_WITH_THICKNESS_0.05.las"
filename = "C:/Users/marte/Documents/GEOWEB/wrapper_file/sezioni/sezione_AMPHI_z39_5cm.las"
INPUT_PC = FileManager.source2pc(filename,1)

# GL.VIEW([
# 	GL.GLPoints(convert(Lar.Points,INPUT_PC.coordinates'),GL.COLORS[2]),
# ])

points = INPUT_PC.coordinates

normal,centroid = Common.LinearFit(points)
plane = Plane(normal,centroid)
plane2 = Plane(points)
GL.VIEW([
	GL.GLPoints(convert(Lar.Points,Common.apply_matrix(plane.matrix,points)[1:2,:]'),GL.COLORS[2]),
	GL.GLPoints(convert(Lar.Points,Common.apply_matrix(plane2.matrix,points)[1:2,:]'),GL.COLORS[3]),
	GL.GLFrame2
])



function Test_rotazione(a,b,c,d,points)
	plane = Plane(a,b,c,d)
	plane_pca = Plane(Common.apply_matrix(plane.matrix,points))
	centroid = Common.centroid(points)

	w = plane.basis[:,3]
	x_ref = plane_pca.basis[:,1]
	v = Lar.cross(x_ref,w)
	u = Lar.cross(v,w)

	u /= Lar.norm(u)
	v /= Lar.norm(v)
	w /= Lar.norm(w)
	basis_finale = hcat(u,v,w) # by column
	if Lar.det(basis_finale)<0
		basis_finale[:,3] = -basis_finale[:,3]
	end
	R = Common.matrix4(Lar.inv(basis_finale))
	R[1:3,4] = -Common.apply_matrix(Common.matrix4(Lar.inv(basis_finale)),centroid)
	return R
end

a,b,c,d = (0,0,1,39.50)
R = Test_rotazione(a,b,c,d,points)

GL.VIEW([
	GL.GLPoints(convert(Lar.Points,Common.apply_matrix(R,points)[1:2,:]'),GL.COLORS[2]),
	GL.GLFrame2
])
