# dntracer steps

1. deploy config.gatekeeper.yml
1. deploy dntracer.pod.yaml
1. determine target container id
1. perform rest of steps inside dntracer pod via kubectl exec
1. determine real path of tmp
```
REALTMP=/host$(/app/bin/ctr --address /host/run/k3s/containerd/containerd.sock -n k8s.io c info $CID | jq -r '.Spec.mounts[] | select(."destination" | contains("tmp")).source')
```
1. symlink real path of tmp to /app/tmp `echo $REALTMP | xargs ln -s`
1. set TMPDIR env var
```export TMPDIR=/app/tmp```
1. execute `/app/dotnet-trace collect -p 1`

# With kubectl-flame

1. deploy config.gatekeeper.yml
1. Checkout and build modified kubectl-flame
```
git clone https://github.com/mgugino-uipath/kubectl-flame.git
cd kubectl-flame
git checkout dotnet-testing
go build -o flame ./cli/
```

1. Build and push the container image in https://github.com/mgugino-uipath/kubectl-flame/tree/dotnet-testing/agent/docker/dotnet or use the one I created below.
1. Ensure KUBECONFIG is part of your env
1. Execute the command with the following parameters, be sure to set/replace PODNAME and CONTAINERNAME as appropriate

```
./flame -n default --target-namespace uipath --lang dotnet $PODNAME $CONTAINERNAME --image quay.io/michaelgugino/dntracer:v0.104
```
1. This will generate a file named flamegraph.svg, however it's not a valid SVG, it's a speedscope file.  You can upload this to speedscope to checkout your trace.

## TODO
Lots of cleanup needed.

1. Only supports tracing if dotnet process is PID 1 of the target container
1. Are dotnet-trace versions backwards compatible with older SDK versions, or do we need to build an image for each SDK version?
1. Support formats other than speedscope?
1. Send PR upstream?