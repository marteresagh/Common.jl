"""
remove_double_verts(A::AbstractArray{T,2}, dim::Int)

Remove double vertces and return list of indices.
"""
@generated function remove_double_verts(A::AbstractArray{T,2}, dim::Int) where T
	quote
        1 <= dim <= 2 || return copy(A)

		hashes = zeros(UInt, axes(A, dim))

        # Compute hash for each row
        k = 0
        @nloops 2 i A d->(if d == dim; k = i_d; end) begin
            @inbounds hashes[k] = hash(hashes[k], hash((@nref 2 A i)))
        end

        # Collect index of first row for each hash
        uniquerow = similar(Array{Int}, axes(A, dim))
        firstrow = Dict{Prehashed,Int}()
        for k = axes(A, dim)
            uniquerow[k] = get!(firstrow, Prehashed(hashes[k]), k)
        end
        uniquerows = collect(values(firstrow))

        # Check for collisions
        collided = falses(axes(A, dim))
        @inbounds begin
            @nloops 2 i A d->(if d == dim
                k = i_d
                j_d = uniquerow[k]
            else
                j_d = i_d
            end) begin
                if (@nref 2 A j) != (@nref 2 A i)
                    collided[k] = true
                end
            end
        end

        if any(collided)
            nowcollided = similar(BitArray, axes(A, dim))
            while any(collided)
                # Collect index of first row for each collided hash
                empty!(firstrow)
                for j = axes(A, dim)
                    collided[j] || continue
                    uniquerow[j] = get!(firstrow, Prehashed(hashes[j]), j)
                end
                for v in values(firstrow)
                    push!(uniquerows, v)
                end

                # Check for collisions
                fill!(nowcollided, false)
                @nloops 2 i A d->begin
                    if d == dim
                        k = i_d
                        j_d = uniquerow[k]
                        (!collided[k] || j_d == k) && continue
                    else
                        j_d = i_d
                    end
                end begin
                    if (@nref 2 A j) != (@nref 2 A i)
                        nowcollided[k] = true
                    end
                end
                (collided, nowcollided) = (nowcollided, collided)
            end
        end
        (@nref 2 A d->d == dim ? sort!(uniquerows) : (axes(A, d))) , uniquerows
	end
end



#
# a=[1 1 2 3 4;2 2 3 4 5]
# new_verts,idx = remove_double_verts(a,2)

# duplicated(x) = foldl(
#   (d,y)->(x[y,:] in d[1] ? (d[1],push!(d[2],y)) : (push!(d[1],x[y,:]),d[2])),
#   (Set(Any[]), Vector{Int}());
#   init = 1:size(x,1))
#
# x = rand(1:2,5,2)
# duplicated(x)
