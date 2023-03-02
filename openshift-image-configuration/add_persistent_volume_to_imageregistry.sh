oc create -n openshift-image-registry -f cluster/claim_registry_volume.yaml
oc get pvc -n openshift-image-registry
oc edit configs.imageregistry.operator.openshift.io

storage:
  pvc:
    claim: ibm-aiops-pvc