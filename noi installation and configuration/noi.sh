oc create namespace aiops
oc create serviceaccount noi-service-account -n aiops
oc adm policy add-scc-to-user SCC system:serviceaccount:noi:noi-service-account
oc create secret docker-registry noi-registry-secret --docker-username=cp --docker-password=eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2MDg3NjY5NzgsImp0aSI6IjFmNWFlYWY1YTEwMDRhYzZiZjMyOWYyY2Q3YTZiZmMzIn0.f6-J1-fV8klmFYMAfXJjqi3r0b0Nhz4-XgZUvI5mYhk --docker-server=cp.icr.io --namespace=aiops
oc patch serviceaccount noi-service-account -p '{"imagePullSecrets": [{"name": "noi-registry-secret"}]}' -n aiops