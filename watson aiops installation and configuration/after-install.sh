kubectl replace --force -f ./ibm-cp-data-operator.yaml
sleep 600
kubectl replace --force -f ./ibm-cp-data-operator_noproxy.yaml


