#!/bin/bash

# pachctl config list context

# echo '{"pachd_address": "grpcs://grpc-hub-c0-702w4d9r4z.clusters.pachyderm.io:31400", "source": 2}' | pachctl config set context test1-nnpeyxj9oc

# pachctl config list context

# pachctl config set active-context test1-nnpeyxj9oc

# pachctl config list context

# pachctl list repo

# pachctl auth login --one-time-password

# pachctl create repo pachyderm-demo-images

# pachctl list repo

# pachctl put file pachyderm-demo-images@master:liberty.png -f http://imgur.com/46Q8nDz.png

# pachctl list repo

# pachctl list commit pachyderm-demo-images

# pachctl list file pachyderm-demo-images@master

##################################################
# The following command 'creates' a Pachyderm pipeline. 
# Note that in Pachyderm, a pipeline isn't just 'launched'
# and it executes, and it stops after execution.
# Once 'created', a pipeline continues to 'exist'.
# It continues to monitor its input repos, and changes
# are detected there, the pipeline will execute accordingly.

# pachctl create pipeline -f pachyderm-demo-edges.json

##################################################
# pachctl get file pachyderm-demo-images@master:liberty.png > pachyderm-demo-images-liberty.png
# pachctl get file pachyderm-demo-edges@master:liberty.png  > pachyderm-demo-edges-liberty.png

##################################################
# pachctl put file pachyderm-demo-images@master:AT-AT.png  -f http://imgur.com/8MN9Kg0.png
# pachctl put file pachyderm-demo-images@master:kitten.png -f http://imgur.com/g2QnNqa.png

##################################################
# pachctl get file pachyderm-demo-images@master:AT-AT.png  > pachyderm-demo-images-AT-AT.png
# pachctl get file pachyderm-demo-images@master:kitten.png > pachyderm-demo-images-kitten.png

# pachctl get file pachyderm-demo-edges@master:AT-AT.png  > pachyderm-demo-edges-AT-AT.png
# pachctl get file pachyderm-demo-edges@master:kitten.png > pachyderm-demo-edges-kitten.png

##################################################
# pachctl create pipeline -f pachyderm-demo-montage.json

##################################################
# pachctl get file pachyderm-demo-montage@master:montage.png > pachyderm-demo-montage-montage.png

