# https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection

using LinearAlgebraicRepresentation
Lar = LinearAlgebraicRepresentation
using ViewerGL
GL = ViewerGL
using LinearAlgebra

V,(VV,EV,FV,CV) = Lar.cuboidGrid([1,1,1],true)
GL.VIEW( push!(GL.numbering(.5)((V,(VV,EV,FV,CV))), GL.GLFrame));

# segmento
la = [.5,.5,.5]
lb = [.5,.5,-.5]
lab = lb-la

v0,v1,v2 = FV[3][1:3]
p0,p1,p2 = V[:,v0], V[:,v1], V[:,v2]
p01 = p1 - p0
p02 = p2 - p0
GL.VIEW( [GL.GLGrid(hcat(la,lb),[[1,2]],GL.COLORS[2]), GL.GLGrid(hcat(p0,p1,p2),[[1,2,3]],GL.COLORS[1],0.3)]);

n = Lar.cross(p01,p02)
t = (Lar.dot(n,(lab-p0)))/(Lar.dot(-lab,n))
la + lab*t


# segment = (la,lb)
# plane = (p0,p1,p2)
function intersection(la,lb,p0,p1,p2)
    lab = lb-la
    p01 = p1 - p0
    p02 = p2 - p0


    n = Lar.cross(p01,p02)
    det = Lar.dot(-lab,n)
    if det != 0.
        t = (Lar.dot(n,la-p0))/det
        u = Lar.dot(Lar.cross(p02,-lab),la-p0)/det
        v = Lar.dot(Lar.cross(-lab,p01),la-p0)/det
        ##
        if (t>0 && t<1)
            println("punto di intersezione è sul segmento tra i punti $la,$lb")
        else
            println("punto di intersezione NON è sul segmento tra i punti $la,$lb")
        end
        if (u>0 && u<1) && (v>0 && v<1)
            println("punto di intersezione è nel parallelogramma formato dai punti $p0,$p1,$p2")
        else
            println("punto di intersezione NON è nel parallelogramma formato dai punti $p0,$p1,$p2")
        end
        ##
        return la+lab*t
    else
        println("segmento e piano paralleli: infite soluzioni o nessuna soluzione")
        return nothing
    end
end

p = intersection(la,lb,p0,p1,p2)
if !isnothing(p)
    GL.VIEW( [GL.GLPoints(reshape(p,1,3),GL.COLORS[7]), GL.GLGrid(hcat(la,lb),[[1,2]],GL.COLORS[2]), GL.GLGrid(hcat(p0,p1,p2),[[1,2,3]],GL.COLORS[1],0.3), GL.GLFrame]);
end
