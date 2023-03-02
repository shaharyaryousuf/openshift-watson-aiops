for image in `cat $1.lst`;do
  docker pull cp.icr.io/cp/ibm-watson-ai-manager/$image
  docker tag cp.icr.io/cp/ibm-watson-ai-manager/$image image-registry.openshift-image-registry.svc:5000/aiops/$image
  docker push image-registry.openshift-image-registry.svc:5000/aiops/$image
done
