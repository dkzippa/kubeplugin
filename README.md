# Kubernetes plugin for kubectl to display resource (CPU/memory) usage

#### Usage
- make it executable `chmod +x scripts/kubeplugin`
- put it in your PATH, e.g. `cp scripts/kubeplugin /usr/local/bin/kubectl-kubeplugin`
- run as plugin:
```
kubectl kubeplugin [RESOURCE_TYPE]
kubectl kubeplugin [RESOURCE_TYPE] [NAMESPACE]
```


#### Output format
```
Resource  Namespace Name  CPU Memory
```