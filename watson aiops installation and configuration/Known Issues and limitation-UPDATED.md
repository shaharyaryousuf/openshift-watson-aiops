### unable to install from user watson
If you face any issue like unable to install from specific user

You may update deployment/statefulset of that pod
and instead of that specific user add runAsNonRoot: true
     securityContext:
        runAsNonRoot: true
### cp-data-operator image issues

1) The NFS export needed the no_root_squash option to remove the permission errors

2) there is a script tunnel_registry.sh that will make the internal registry available to the bastion

3) update a script prepare.sh if you have already installed NOI  purpose of this script populates the CPD images to the internal registry

4) you have to force the cpd operator to have a proxy, and then not have a proxy
execute after-install.sh
[root@localhost ~]# cat after-install.sh
kubectl replace --force -f ./ibm-cp-data-operator.yaml
sleep 600
kubectl replace --force -f ./ibm-cp-data-operator_noproxy.yaml

set up chrony on all of the nodes as cockroachdb needed them to be within 1 second of each other

### Optimize Openshift Peroformance by updating requests

you can scale down deployments by using scaledowndeployments.sh and scaledowndepwoinit.sh
and you can scale down statefulset by using scaledownstatefulset.sh