### Installing the Watson AIOps operator (OLM UI)

### 1. Add the catalog source

    Log in to your Red Hat OpenShift Container Platform cluster console.

    Click Administration > Cluster Settings, then select the OperatorHub configuration resource under the Global Configurations tab.

    Click Sources > Create Catalog Source. Provide the Watson™ AIOps catalog source name ibm-watson-aiops-catalog and the image URL docker.io/ibmcom/ibm-operator-catalog:latest, then click Create.

    The IBM Watson AIOps catalog source appears. Refresh the screen after a few minutes, and ensure that the # of operators count is 1 or greater.

    Click the IBM Watson AIOps source, then click YAML. If the spec object in your catalog source YAML contains updateStrategy, continue with installing Event Manager. If the spec object does not include updateStrategy, add the following code to your catalog source YAML, then click Save:

    updateStrategy:
        registryPoll:
          interval: 45m

### 2. Install the operator

    Click Operators > OperatorHub, and search for the Watson AI Ops operator. Click Install.

    Select the namespace that you created when you prepared for your Watson AIOps installation to install the operator. Do not use namespaces that are owned by Kubernetes or OpenShift, such as kube-system or default.

    Click Install.

    Click Operators > Installed Operators, and view the Watson AIOps operator. It takes a few minutes to install. Ensure that the status of the installed Watson AIOps operator is Succeeded.

    Ensure that the corresponding Netcool Operations Insight operator is set to the latest update channel:
        Click the Netcool Operations Insight operator, then click Subscription.
        Click the name in the Channel field in the Subscription Details table, then select the latest stable channel.
        Click Save.

    Ensure that the corresponding AI Manager operator is set to the latest update channel:
        Click the IBM Watson AIOps AI Manager operator, then click Subscription.
        Click the name in the Channel field in the Subscription Details table, then select the latest stable channel.
        Click Save.

Note: When upgrading the Watson AIOps operator from AIOps 1.0.0 (2.0) to 1.1.0 (2.1) on a Red Hat OpenShift 4.5 cluster, you must install the AI Manager operator before installing the AIOps operator. This is not required in OCP 4.6.

During installation of the Watson AIOps operator, you can verify that installation is proceeding by observing pod behavior. To verify installation, see Monitoring cloud installation progress.

Now that the operator is installed, you must create your AI Manager and Event Manager instances in the OLM UI. For more information, see the following tasks:

    Create an AI Manager instance
    Create an Event Manager instance
