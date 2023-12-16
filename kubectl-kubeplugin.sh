#!/bin/bash
#
# plugin for kubectl to display resource (CPU/memory) usage
# make it executable and put it in your PATH
# e.g. cp kubectl-kubeplugin.sh /usr/local/bin/kubeplugin
# run as plugin: kubectl kubeplugin

[[ -n $DEBUG ]] && set -x

usage() {
    cat <<EOF
Display resource (CPU/memory) usage.
This plugin allows you to see the resource consumption for nodes or pods.

Usage:
   kubectl kubeplugin [RESOURCE_TYPE]
   kubectl kubeplugin [RESOURCE_TYPE] [NAMESPACE]

Available resource types:
   node          
   pod

EOF
}


PODS_REGEX="^(pod$|pods$)"
NODES_REGEX="^(node$|nodes$)"


main() {
    if [[ "$#" -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
        usage
        exit 1
    fi

    if [[  ! "$1" =~ $PODS_REGEX &&  ! "$1" =~ $NODES_REGEX ]]; then
        usage
        exit 1
    fi

    RESOURCE_TYPE=${1}
    NAMESPACE=${2}
    HEADER="Resource Namespace CPU Memory"

    
    if [[ $RESOURCE_TYPE =~ $PODS_REGEX && -z "$NAMESPACE" ]]; then
        kubectl top "$RESOURCE_TYPE" --all-namespaces | tail -n +2 | awk -v h="$HEADER" 'NR==1 {print h}  {print $2,$1,$3,$4}' | column -t
    else
        kubectl top "$RESOURCE_TYPE" -n "$NAMESPACE" | tail -n +2 | awk -v ns="$NAMESPACE" -v h="$HEADER" 'NR==1 {print h}  {print $1,ns,$2,$3}' | column -t
    fi

}

main "$@"
