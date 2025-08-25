argo cd command steps

# gets password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# opens port
kubectl port-forward svc/argocd-server 8080:80 -n argocd
