using Common
using Visualization

points = rand(2,100000)

FV = Common.delaunay_triangulation(points)

EV = Common.get_boundary_edges(points,FV)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[1])
	#GL.GLGrid(points,FV,GL.COLORS[2],1.0)
	GL.GLGrid(points,EV,GL.COLORS[12],1.0)
	#GL.GLFrame2
]);


################# DEBUG Delaunay
using AlphaStructures

points = rand(3,100000)

npoints = 10000
x = rand(npoints)
y = zeros(npoints)
z = rand(npoints)

wall_XZ = convert(Lar.Points, hcat(x,y,z)')

x = zeros(npoints)
y = rand(npoints)
z = rand(npoints)

wall_YZ = convert(Lar.Points, hcat(x,y,z)')

points = hcat(wall_XZ,wall_YZ)

using Detection
source = "C:/Users/marte/Documents/potreeDirectory/pointclouds/MURI"
INPUT_PC = Detection.source2pc(source,1)

points = Common.apply_matrix(Lar.t(-Common.centroid(INPUT_PC.coordinates)...),INPUT_PC.coordinates)

DT = delaunayTriangulation(points)

FV = Common.delaunay_triangulation(points)

GL.VIEW([
    GL.GLPoints(convert(Lar.Points,points'),GL.COLORS[1])
	#GL.GLGrid(points,FV,GL.COLORS[2],1.0)
	GL.GLGrid(points,FV,GL.COLORS[12],1.0)
	#GL.GLFrame2
]);


#### VOLUME
function getmodel0(volume::Volume)::Lar.LAR
	V,(VV,EV,FV,CV) = Lar.apply(Lar.t(-0.5,-0.5,-0.5),Lar.cuboid([1,1,1],true))
	scalematrix = Lar.s(volume.scale...)
	rot = Common.matrix4(Common.euler2matrix(volume.euler_angles...))
	trasl = Lar.t(volume.position...)
	affine = trasl*rot*scalematrix
	T = Common.apply_matrix(affine,V)
	return T,EV,FV
end

vol = Volume([36.681, 35.501, 41.960],[295486.644, 4781263.248, 296.334],[-0.144, 0.224, -0.588])
V,EV,FV = getmodel0(vol)

bbin = "C:/Users/marte/Documents/GEOWEB/wrapper_file/JSON/volume_COLOMBELLA.json"
V1,EV1,FV1 = FileManager.getmodel(bbin)
GL.VIEW([
	GL.GLGrid(Common.apply_matrix(Lar.t(-Common.centroid(V)...),V),EV,GL.COLORS[12],1.0)
	GL.GLGrid(Common.apply_matrix(Lar.t(-Common.centroid(V)...),V1),EV1,GL.COLORS[2],1.0)
	GL.GLFrame
]);



angles = [-0.144, 0.224, -0.588]
Common.euler2matrix(angles...)




RotXYZ(angles...)
