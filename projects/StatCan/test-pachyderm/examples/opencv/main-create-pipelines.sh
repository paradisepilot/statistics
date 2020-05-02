#!/bin/bash

# echo '{"pachd_address": "grpcs://grpc-hub-c0-be9jiqri9p.clusters.pachyderm.io:31400", "source": 2}' | pachctl config set context pachyderm-demo-cluster-x01kmpjlpz && pachctl config set active-context pachyderm-demo-cluster-x01kmpjlpz

# pachctl auth login --one-time-password

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
pachctl create repo pachyderm-demo-images

pachctl put file pachyderm-demo-images@master:liberty.png -f http://imgur.com/46Q8nDz.png
pachctl put file pachyderm-demo-images@master:AT-AT.png   -f http://imgur.com/8MN9Kg0.png
pachctl put file pachyderm-demo-images@master:kitten.png  -f http://imgur.com/g2QnNqa.png

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
pachctl create pipeline -f pachyderm-demo-edges.json
pachctl create pipeline -f pachyderm-demo-montage.json

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#pachctl get file pachyderm-demo-images@master:liberty.png  > pachyderm-demo-images-liberty.png
#pachctl get file pachyderm-demo-images@master:AT-AT.png    > pachyderm-demo-images-AT-AT.png
#pachctl get file pachyderm-demo-images@master:kitten.png   > pachyderm-demo-images-kitten.png

#pachctl get file pachyderm-demo-edges@master:liberty.png   > pachyderm-demo-edges-liberty.png
#pachctl get file pachyderm-demo-edges@master:AT-AT.png     > pachyderm-demo-edges-AT-AT.png
#pachctl get file pachyderm-demo-edges@master:kitten.png    > pachyderm-demo-edges-kitten.png
#pachctl get file pachyderm-demo-montage@master:montage.png > pachyderm-demo-montage-montage.png

