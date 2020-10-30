using Common
using Visualization
using FileManager

source = "C:\\Users\\marte\\Documents\\GEOWEB\\FilePotree\\orthoCONTEA\\Sezione_z650.las"
source = "examples\\muriAngolo.las"
PC = FileManager.las2pointcloud(source)
PC2D = PointCloud(PC.coordinates[1:2,:])
k = 10
outliers = Common.outliers(PC2D, [1:PC2D.n_points...], k)
tofit = setdiff([1:PC2D.n_points...],outliers)
GL.VIEW([
			GL.GLPoints(convert(Lar.Points,PC2D.coordinates[:,tofit]'),GL.COLORS[12]),
			GL.GLPoints(convert(Lar.Points,PC2D.coordinates[:,outliers]'),GL.COLORS[2]),

])


a=[1 1 2 3 4;2 2 3 4 5]
new_verts,idx = remove_double_verts(a,2)

duplicated(x) = foldl(
  (d,y)->(x[y,:] in d[1] ? (d[1],push!(d[2],y)) : (push!(d[1],x[y,:]),d[2])),
  (Set(Any[]), Vector{Int}()); 
  init = 1:size(x,1))

x = rand(1:10,1000,4)
unique2($x, 1);


x = rand(1:2,5,2)
duplicated(x)

nonunique()
