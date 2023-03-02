### Universal prerequisites
Before installing either the Watson AIOps or the AI Manager operator, you must install the following tools in the cluster:

   - Red Hat® OpenShift® 4.5 or 4.6: For more information, see Getting started with Red Hat OpenShift Container Platform
   - Tiller 2.9.1  or later and Helm V3


    1) Download your desired version from https://github.com/helm/helm/releases
    2) Unpack it (tar -zxvf helm-v2.0.0-linux-amd64.tgz)
    3) Find the helm binary in the unpacked directory, and move it to its desired destination (mv linux-amd64/helm /usr/local/bin/helm)
    4) helm init ( to install tiller)
Detail documentation:
https://v2.helm.sh/docs/install/
  

   - Strimzi 0.19

 Install the Strimzi 0.19 operator

    1) Log in to your Red Hat OpenShift console.
    2) Click Operators > Operator Hub.
    3) Filter by Strimzi, click the Strimzi tile, then click Install.
    4) Select strimzi-0.19.x as the Update Channel
    5) Select All namespaces on the cluster (default). Leave other default options unchanged.
    6) Click Install.

   - Create the entitled registry secrets

 (You can use the we used for NOI or create a new one)

Complete the following steps to create a secret with the entitled registry key value:

   - Obtain the entitlement key that is assigned to your ID.
  a) Log in to MyIBM Container Software Library Opens in a new tab by using the IBMid and password that are associated with the entitled software.
   https://myibm.ibm.com/products-services/containerlibrary
  b) In the Entitlement keys section, select Copy key to copy the entitlement key to the clipboard.

    Log in to your Red Hat® OpenShift® Container Platform cluster by using the oc login command.

    Create the following image pull secrets to pull operand images by entering the following commands. Ensure that you create both of the following secrets. cp.stg.icr.io is required for AI Manager and cp.icr.io is required for Watson AIOps. Do not change either the secret value of cp.stg.icr.io or cp.icr.io in either command:

    kubectl create secret docker-registry 'cp.icr.io'  \
        --docker-server='cp.icr.io'                    \
        --docker-username='cp'                         \
        --docker-password='<token>'                    \
        --docker-email='<user>'                        \
        --namespace='<target namespace>'

kubectl create secret docker-registry 'cp.stg.icr.io'  \
    --docker-server='cp.icr.io'                        \
    --docker-username='cp'                             \
    --docker-password='<token>'                        \
    --docker-email='<user>'                            \
    --namespace='<target namespace>'



