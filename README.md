# dntracer steps

1. deploy config.gatekeeper.yml
1. deploy dntracer.pod.yaml
1. determine container id
1. determine real path of tmp
```
REALTMP=$/host(/app/bin/ctr --address /host/run/k3s/containerd/containerd.sock -n k8s.io c info $CID | jq '.Spec.mounts[] | select(."destination" | contains("tmp")).source')
```
1. symlink real path of tmp to /app/tmp `echo $REALTMP | xargs ln -s`
1. set TMPDIR env var
```export TMPDIR=/app/tmp```
1. execute `/app/dotnet-trace collect -p 1`