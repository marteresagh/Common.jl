# Script Usage

## section2plane.jl

#### Input parameters description:
 - source: Potree project of slice or .las file
 - lod: level of detail of Potree
 - output: output folder
#### Output:
 - `planeCoeff.csv`: a,b,c,d parameters of plane (`ax+by+cz=d`)


#### Options:
```
$ julia section2plane.jl -h
usage: section2plane.jl -o OUTPUT [--lod LOD] [-h] source

positional arguments:
  source               Potree project or .las file

optional arguments:
  -o, --output OUTPUT  Output folder
  --lod LOD            Level of detail. If -1, all points are taken
                       (type: Int64, default: -1)
  -h, --help           show this help message and exit
```

#### Examples:

    # fitting plane
    julia section2plane.jl "C:/POTREE_PROJECT" -o "C:/MY_PLANE"
    julia section2plane.jl "C:/file.las" -o "C:/MY_PLANE"

## points2plane.jl

#### Input parameters description:
 - source: a text file with points list
 - output: output folder

#### Output:
 - `planeCoeff.csv`: a,b,c,d parameters of plane (`ax+by+cz=d`)

#### Options:
```
$ julia points2plane.jl -h
usage: points2plane.jl -o OUTPUT [-h] source

positional arguments:
  source               A text file with points list

optional arguments:
  -o, --output OUTPUT  Output folder
  -h, --help           show this help message and exit
```

#### Examples:

    # fitting plane
    julia points2plane.jl "C:/points.txt" -o "C:/MY_PLANE"
