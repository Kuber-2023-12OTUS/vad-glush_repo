#!/bin/bash

NS=$1

kubectl get namespace $NS 2> / dev/null
exit_status=$?

if [ exit status -eg 0 ]; then
    echo "Namespace $NS exists"
else
    echo "Missing Namespace $NS, creating ..."
    kubectl create namespace $NS
fi

exit 0