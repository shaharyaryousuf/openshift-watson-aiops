
# Introduction
This project documents how you can setup a complete Red Hat OpenShift 4.2 cluster on a single VMware ESXi host machine with Terrraform.  
  
The configuration files and scripts used for the installation are also maintained by this project.  

Please find all the configuration of dhcp,dns,httpd and haproxy in the above directories.
installed tftp and matchbox services
Added matchbox configuration for baremetal
# Context and History
This project was created because we wanted to install Red Hat OpenShift on an existing lab machine 
At the time of writing, the OpenShift installation was only supported out of the box on:
- AWS
- Azure
- GCP
- bare metal
- OpenStack
- vSphere
  
For more details check https://docs.openshift.com/container-platform/4.2/welcome/index.html.  
  
We preferred to install a free base O.S. on our labo server to replace Windows Server 2008. The options we considered were:
- Linux
- VMWare ESXi (free version)  
  
At first sight the installation instructions for vSphere seem to correspond with our use case, but this setup requires VMware vSphere vCenter, managing your VMware vSphere machines. Our goal is to install Red Hat OpenShift on a single VMware ESXi machine, because this allows us to use the free VMware ESXi license, without a central vCenter server. Therefore the standard vSphere installation instructions can not be used.  
  
Another alternative we considered was [Red Hat CodeReady Containers](https://developers.redhat.com/products/codeready-containers/overview). This alternative needs further evaluation but was put on hold because:
- testing on a personal Windows laptop required Hyper-V, which would conflict with VirtualBox, our preferred hypervisor  
- a Linux server with matching requirements was not (yet) available  
- CodeReady does not contain all OpenShift features  
  
A similar existing VMWare ESXi environment was already available, which allowed us to design and validate the setup for the lab machine we wanted to migrate.  
  
# References
A quick search on the internet quickly returned a number of resources that provided the basis for our solution:
- [OpenShift Blog: Deploying a UPI environment for OpenShift 4.1 on VMs and Bare Metal](https://blog.openshift.com/deploying-a-upi-environment-for-openshift-4-1-on-vms-and-bare-metal/)  
- [OpenShift Documentation: Installing a cluster on bare metal](https://docs.openshift.com/container-platform/4.2/installing/installing_bare_metal/installing-bare-metal.html)  
  
# Pre-requisites

  
## VMWare ESXi
The installation was tested on VMware ESXi 6.5.0
  
# Solution Overview
The conceptual architecture of our single machine OpenShift cluster is depicted below:
  
![Conceptual Architecture](./doc/images/conceptualarchitecture.svg)
  

The following table summarizes the VMs that we use to deploy OpenShift:  
  
| VM name | Hostname | Role | CPU | RAM | Storage | IP Address |  
| --- | ---  | --- | --- | --- | --- | --- |  
| bastion | bastion  | bastion | 16 | 16 | 500GB | 192.168.40.190 |  
 bootstrap | bootstrap  | OpenShift Bootstrap | 4 | 8 | 200GB | 192.168.40.191 |  
| master-0 | master-0  | OpenShift Control Plane/Control Plane | 30 | 45 | 200GB | 192.168.40.192 |  
| master-1 | master-1  | OpenShift Control Plane/ Control Plane | 30 | 45 | 200GB | 192.168.40.193 |  
| master-2 | master-2  | OpenShift Control Plane/ Control Plane | 16 | 45 | 200GB | 192.168.40.194 |  
| worker-1 | worker1  | OpenShift Compute Node | 15 | 45 | 200GB | 192.168.40.195 |   
  
The bastion server is a CentOS 7.9 VM.  
- Hostname: bastion.ocp.perceptionit.int
- IP address: 192.168.40.190
- Netmask: 255.255.255.0
- DNS server: 192.168.40.190 
  
It hosts the DNS server, DHCP server and load balancer for a 192.168.40.0 subnet It also hosts the TFTP and Matchbox servers to provision the OpenShift VMs. It also serves as gateway and router to the internet for the 192.168.40.0 subnet.  
  
To apply this solution to your environment, just replace all occurences of the hostname of our VMware lab server _perceptionit.int_ to the name of your VMware lab server.  
  
# Configuration and Installation
  
## Bastion VM
This machine will be provided with internet by Jazz

#### Install network services and installation tools
  
Install git, clone this project in the home folder of the root user and execute the installation script:  
```bash
dnf install -y git
cd ~
git clone https://github.com/Perception-IT/openshift-jazz.git
cd openshift-install-4
./install.sh
```
  


  
we will be automatically assigning IP address via DHCP, but make sure you change DNS server so that is points to the DNS server on the bastion server. You also risk that the bastion server receives another IP address when it would be restarted, which is not desirable for a server.  
#### Verify and Update DHCP ,named-dns and haproxy if you have changed the internal-ip or hostnames
Files are:
```sh
/etc/dhcp/dhcpd.conf
/etc/haproxy/haproxy.cfg
/etc/named.conf
/var/named/67.168.192.in-addr.arpa.zone 
/named/ocp67.perceptionit.int.zone 
```
#### Verify configuration
Reboot the bastion machine and verify that the services created by the [installBastion.sh](installBastion.sh) script are started successfully.  
  
The following services should be reported as active:  
```sh
systemctl status named-chroot.service
systemctl status dhcpd.service
systemctl status matchbox.service
systemctl status haproxy.service
```
The following service will be reported as inactive, but that is expected behavior:  
```sh
systemctl status tftp.service
```
  
### Openshift configuration
Edit the file `/root/ocp67/install-config.yaml`:
1) Update the sshKey value with the key that was generated by the [installBastion.sh](installBastion.sh) script and written to the file `/root/.ssh/id_rsa.pub`  
2) Update the pull secret with your pull secret that you obtained from the Pull Secret page on the [Red Hat OpenShift Cluster Manager site](https://cloud.redhat.com/openshift/create/local)
  
  
### Openshift installation
Prepare the installation files on the bastion machine:
```sh
cd ~/openshift-install-4/prepare.sh
``` 


```

### Wait for the installation to complete
Execute the following command to check if the installation has completed:  
```sh
openshift-install wait-for bootstrap-complete --log-level debug
# You should get output similar to this after waiting for a while
DEBUG OpenShift Installer v4.2.8
DEBUG Built from commit 425e4ff0037487e32571258640b39f56d5ee5572
INFO Waiting up to 30m0s for the Kubernetes API at https://api.ocp67.perceptionit.int:6443...
INFO API v1.14.6+dea7fb9 up
INFO Waiting up to 30m0s for bootstrapping to complete...
DEBUG Bootstrap status: complete
INFO It is now safe to remove the bootstrap resources
```
  
Once you see the above message you can remove the bootstrap VM.  
  
### Configure oc cli tool
From the bastion command line as root:  
  
```sh
# you can also add the following line to the ~/.bashrc file
export KUBECONFIG=~/ocp67/auth/kubeconfig
oc whoami
```
### Before configuring persistent storage for pvc please follow nfs-provisioning document
### Configuring storage for the image registry in production clusters
You must configure storage for the image registry Operator. Because this is production cluster, we set the image registry to persistent volume claim.   
  
```sh
execute add_persistent_volume_to_imageregistry.sh from openshift-image-configuration directory to create persistent volume claim and set that pvc in openshift image operator configuration.
```
  
# Next Steps
## hosts file
Edit your local hosts file (on windows = C:\Windows\System32\drivers\etc\hosts) to make the OpenShift environment accessible from your laptop. Add the following entry:  
```sh  
<ip address of the external connection on the bastion VM> console-openshift-console.apps.ocp67.perceptionit.int oauth-openshift.apps.ocp67.perceptionit.int grafana-openshift-monitoring.apps.ocp67.perceptionit.int
```
  
## Open the OpenShift web console
The OpenShift Web Console is accessible at https://console-openshift-console.apps.ocp67.perceptionit.int  
Login with the user `kubeadmin`. The password can be found on the bastion server in the file  `/root/ocp67/auth/kubeadmin-password`.

For more details check https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html-single/web_console/index
  

# Troubleshooting
The most tricky part of the installation is getting the networking setup correct on the bastion server. Make sure DHCP, DNS and HAProxy servers are running and accessible from the cluster nodes. The bastion server also needs to route the traffic from the cluster nodes to the internet. The following commands can als be useful for troubleshooting:  
  
On the bastion server:
```sh
# Check 
systemctl status named-chroot
systemctl status tftp
systemctl status dhcpd
systemctl status matchbox
systemctl status haproxy
```

Login to cluster node CoreOS machines:  
```sh
ssh -i .ssh/id_rsa core@bootstrap.ocp67.perceptionit.int
```
  
From the cluster node cli:
```sh
sudo su -
# Check if there is route from the cluster node to the internet
ping google.be
# Can the cluster nodes find the DNS server on the bastion server
nslookup google.be
# Check if the containers are running
crictl ps -a
```






## Resources
Check the following useful resources for tips on how to troubhleshoot the installation:
- https://github.com/openshift/installer/blob/master/docs/user/troubleshooting.md
- Use tcpdump to check communication between bastion and nodes: https://www.tcpdump.org/manpages/tcpdump.1.html
- Debugging Kubernetes nodes with crictl: https://kubernetes.io/docs/tasks/debug-application-cluster/crictl/
## Speacial Thanks to :(At first I used this Article to perform Installation without Terraform)
- https://github.com/I8C/installing-openshift-on-single-vmware-esxi-host


All the configuration and ideas has been taken by this git

https://github.com/I8C/installing-openshift-on-single-vmware-esxi-host



