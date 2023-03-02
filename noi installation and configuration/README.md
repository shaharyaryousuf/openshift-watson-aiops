### NOI PRE REQ CONFIGURATIONS
Update the entitlement key in noi.sh script and execute


Obtain the entitlement key that is assigned to your IBM ID which will grant you access to the IBM Entitled Registry. Log into https://myibm.ibm.com/products-services/containerlibrary external link with the account (username and password) that has entitlement to IBM software. The key that is displayed is the key that will be used when accessing the Entitled Registry.

### INSTALLING NOI WITH THE OLM UI


### Create a Catalog source for Netcool Operations Insight

    From the Red Hat OpenShift OLM UI, navigate to Administration > Cluster Settings, and then from the Global Configuration tab select OperatorHub> Sources.
    Click the Create Catalog Source button under the Sources tab. Provide the Netcool Operations Insight catalog source name and the image URL, docker.io/ibmcom/ibm-operator-catalog:latest. Then select the Create button.
    Verify the Netcool Operations Insight Catalog Source.
    From the Red Hat OpenShift OLM UI, navigate to Administration > Cluster Settings, and then select the OperatorHub configuration resource under the Global Configuration tab. Verify that the ibm-noi-catalog catalog source is present and running.
    Edit the catalog source by adding the following lines to the spec:


      updateStrategy:
        registryPoll:
          interval: 45m

### Install the Netcool Operations Insight Operator

    Navigate to Operators > OperatorHub, and then search for and select the Netcool Operations Insight operator. Select the Install button.
    Select the namespace that you created in Preparing your cluster to install the operator into. Do not use namespaces that are owned by Kubernetes or OpenShift, such as kube-system or default.
    Click the Install button.
    Navigate to Operators > Installed Operators, and view the Netcool Operations Insight operator. It takes a few minutes to install. Ensure that the status of the installed Netcool Operations Insight operator is Succeeded before continuing.

### Create a Netcool Operations Insight instance

    From the Red Hat OpenShift OLM UI, navigate to Operators > Installed Operators, and select the Netcool Operations Insight operator. Under Provided APIs > Cloud Deployment select Create Instance.
    From the Red Hat OpenShift OLM UI, use the YAML view or the Form view to configure the properties for the Netcool Operations Insight deployment. For more information about configurable properties for a cloud only deployment, see Cloud operator properties.
    Select the Create button.
    Under the All Instances tab, a Netcool Operations Insight instance appears.
### obtain cluster domain information of your openshift environment

[root@localhost scripts]# oc get ingress.config cluster -o jsonpath="{.spec.domain}{'\n'}".
apps.ocp.jazz.int
