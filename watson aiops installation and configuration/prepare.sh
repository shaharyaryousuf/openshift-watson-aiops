kubectl create ns aiops
kubectl create secret docker-registry 'cp.icr.io'      --docker-server='cp.icr.io'                        --docker-username='cp'                            --docker-password='eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJQk0gTWFya2V0cGxhY2UiLCJpYXQiOjE2MTMzOTYwNjQsImp0aSI6IjJlYWFlNjMzNzk1NTRkYmZhZGJkNmIwNzRiOWIxNzRmIn0.5e9Qut9DF1a6J42L721x_S1rE-OgQYgn0O2_KnotnGg'    --namespace='aiops'
./cpd-cli preload-images --repo repo.yaml --assembly lite --action download
./cpd-cli preload-images --assembly lite --action push --load-from cpd-cli-workspace --transfer-image-to image-registry.openshift-image-registry.svc:5000/aiops --insecure-skip-tls-verify
./push-images.sh images
