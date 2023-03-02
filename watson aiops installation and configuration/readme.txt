The NFS export needed the no_root_squash option to remove the permission errors

there is a script tunnel_registry.sh that will make the internal registry available to the bastion

a script prepare.sh that populates the CPD images to the internal registry

and you have to force the cpd operator to have a proxy, and then not have a proxy

[root@localhost ~]# cat after-install.sh
kubectl replace --force -f ./ibm-cp-data-operator.yaml
sleep 600
kubectl replace --force -f ./ibm-cp-data-operator_noproxy.yaml

and I had to set up chrony on all of the nodes as cockroachdb needed them to be within 1 second of each other