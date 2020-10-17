"""
	volumemodelfromjson(path::String)

Return LAR model of Potree volume tools.
"""
function volume2LARmodel(volume::Volume)
	V,(VV,EV,FV,CV) = Lar.apply(Lar.t(-0.5,-0.5,-0.5),Lar.cuboid([1,1,1],true))
	mybox = (V,CV,FV,EV)
	scalematrix = Lar.s(volume.scale...)
	rx = Lar.r(2*pi+volume.rotation[1],0,0)
	ry = Lar.r(0,2*pi+volume.rotation[2],0)
	rz = Lar.r(0,0,2*pi+volume.rotation[3])
	rot = rx * ry * rz
	trasl = Lar.t(volume.position...)
	model = Lar.Struct([trasl,rot,scalematrix,mybox])
	return Lar.struct2lar(model) #V,CV,FV,EV
end
