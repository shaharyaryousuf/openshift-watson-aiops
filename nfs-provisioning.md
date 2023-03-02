Important Services

The following are the important NFS services, included in nfs-utils packages.

rpcbind: The rpcbind server converts RPC program numbers into universal addresses.

nfs-server: It enables clients to access NFS shares.

nfs-lock / rpc-statd: NFS file locking. Implement file lock recovery when an NFS server crashes and reboots.

nfs-idmap: It translates user and group ids into names, and to translate user and group names
into ids
Important Configuration Files

You would be working mainly on below configuration files to setup NFS server and Clients.

/etc/exports: It is the main configuration file, controls which file systems are exported to remote hosts and specifies options.

/etc/fstab: This file is used to control what file systems including NFS directories are mounted when the system boots.

/etc/sysconfig/nfs: This file is used to control which ports the required RPC services run on.

/etc/hosts.allow and /etc/hosts.deny: These files are called TCP wrappers, controls the access to the NFS server. It is used by NFS to decide whether or not to accept a connection coming in from another IP address.


Configure NFS Server
Install NFS Server

Install the below package for NFS server using the yum command.

yum install -y nfs-utils

Once the packages are installed, enable and start NFS services.

systemctl start nfs-server rpcbind
systemctl enable nfs-server rpcbind

Create NFS Share

Now, let’s create a directory to share with the NFS client. Here I will be creating a new directory named nfsfileshare in the / partition.

You can also share your existing directory with NFS.

mkdir /nfs

Allow NFS client to read and write to the created directory.

chmod 777 /nfs

We have to modify /etc/exports file to make an entry of directory /nfsfileshare that you want to share.

vi /etc/exports

Create a NFS share something like below.

/noi 10.200.40.0/24(rw,no_root_squash)

/nfs: shared directory

10.200.40.0/24: Subnet covers all of client machine. We can also use the hostname instead of an IP address/subnet. It is also possible to define the range of clients with subnet like 192.168.1.0/24.

rw: Writable permission to shared folder


no_root_squash: By default, any file request made by user root on the client machine is treated as by user nobody on the server. (Exactly which UID the request is mapped to depends on the UID of user “nobody” on the server, not the client.) If no_root_squash is selected, then root on the client machine will have the same level of access to the files on the system as root on the server.



Export the shared directories using the following command.

exportfs -r


Configure Firewall

We need to configure the firewall on the NFS server to allow NFS client to access the NFS share. To do that, run the following commands on the NFS server.

firewall-cmd --permanent --add-service mountd
firewall-cmd --permanent --add-service rpc-bind
firewall-cmd --permanent --add-service nfs
firewall-cmd --reload


Dynamic NFS provisioning

A way to solve this is to have an NFS client that will automatically do it for us. Requesting a persistence volume claim will automatically trigger the creation of a persistence volume. For this to happen an NFS client must be installed in the kubernetes cluster, and access must be given to the client using a service account.

1. Verify NFS server using a desired directory
[root@netcool nfs-provisioning]# showmount -e
Export list for netcool.exnoi.apps.ocp.jazz.int:
/noi 10.200.40.0/24
[root@netcool nfs-provisioning]#
2 . Service account must be set using a rbac.yamlfile, it will create role, role binding, and various roles within the kubernetes cluster. If you need to understand what are service accounts
Yaml file can be retrieved from nfs directory

$ kubectl apply -f rbac.yaml
serviceaccount/nfs-pod-provisioner created
clusterrole.rbac.authorization.k8s.io/nfs-provisioner-clusterRole created
clusterrolebinding.rbac.authorization.k8s.io/nfs-provisioner-rolebinding created
role.rbac.authorization.k8s.io/nfs-pod-provisioner-otherRoles created
rolebinding.rbac.authorization.k8s.io/nfs-pod-provisioner-otherRoles created

$ kubectl get clusterrole,role 

3. Creating a storage class class.yaml and deploying it. If you need to understand storage classes
 
$ kubectl create -f class.yaml
$ kubectl get storageclass
[root@netcool nfs-provisioning]# kubectl get storageclass
NAME                  PROVISIONER       RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
managed-nfs-storage   example.com/nfs   Delete          Immediate           false                  151d


4. The NFS client provisioner will be set as a pod
Please update sufficient below values in yaml file
NFS_SERVER,NFS_PATH under env:
server , under volumes > nfs
Deploying the NFS client pod:


$ kubectl apply -f deployment.yaml

kubectl describe pod nfs-client-provisioner-5585d7c589-qpq7j

nfs-provisioner-v:
    Type:      NFS (an NFS mount that lasts the lifetime of a pod)
    Server:    192.168.40.190
    Path:      /noi
     Mounts:
      /persistentvolumes from nfs-provisioner-v (rw)
      
      
      

Reference Link:

https://medium.com/@myte/kubernetes-nfs-and-dynamic-nfs-provisioning-97e2afb8b4a9

