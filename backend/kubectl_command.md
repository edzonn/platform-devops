## Auto completion commands for kubectl
```bash
- source <(kubectl completion bash) && \
echo "source <(kubectl completion bash)" >> ~/.bashrc
```

## Restart the shell or run
```bash
- source ~/.bashrc
- bash ~/.bashrc
```

## Working with PODs in Kubernetes
```bash
- kubectl get pods
- kubectl get pods --all-namespaces
- kubectl get pods -n <namespace>
- kubectl describe pod <pod-name> -n <namespace>
- kubectl logs <pod-name> -n <namespace>
- kubectl exec -it <pod-name> -n <namespace> -- /bin/bash
- kubectl delete pod <pod-name> -n <namespace>
```

## Working with Services in Kubernetes
```bash
- kubectl get services
- kubectl get services --all-namespaces
- kubectl get services -n <namespace>
- kubectl describe service <service-name> -n <namespace> 
```   

## Working with Deployments in Kubernetes
```bash
- kubectl get deployments
- kubectl get deployments --all-namespaces
- kubectl get deployments -n <namespace>
- kubectl describe deployment <deployment-name> -n <namespace>
- kubectl scale deployment <deployment-name> --replicas=<number-of-replicas>
- kubectl rollout status deployment/<deployment-name> -n <namespace>
- kubectl rollout history deployment/<deployment-name> -n <namespace>
- kubectl rollout undo deployment/<deployment-name> -n <namespace>  
- kubectl delete deployment <deployment-name> -n <namespace>
```

## Working with Namespaces in Kubernetes
```bash
- kubectl get namespaces
- kubectl create namespace <namespace-name>
- kubectl delete namespace <namespace-name>
- kubectl config set-context --current --namespace=<namespace-name>
- kubectl config view | grep namespace:
- kubectl config get-contexts
- kubectl config use-context <context-name>
```

## Working with ConfigMaps in Kubernetes
```bash
- kubectl get configmaps
- kubectl get configmaps -n <namespace>
- kubectl describe configmap <configmap-name> -n <namespace>
- kubectl create configmap <configmap-name> --from-literal=<key>=<value> -n <namespace>
- kubectl create configmap <configmap-name> --from-file=<file-path> -n <namespace>
- kubectl delete configmap <configmap-name> -n <namespace>
```
## Working with Secrets in Kubernetes
```bash
- kubectl get secrets
- kubectl get secrets -n <namespace>
- kubectl describe secret <secret-name> -n <namespace>
- kubectl create secret generic <secret-name> --from-literal=<key>=<value> -n <namespace>
- kubectl create secret generic <secret-name> --from-file=< file-path> -n <namespace>
- kubectl delete secret <secret-name> -n <namespace>
```

## Working with Nodes in Kubernetes
```bash
- kubectl get nodes
- kubectl describe node <node-name>
- kubectl cordon <node-name>
- kubectl uncordon <node-name>
- kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
- kubectl delete node <node-name>
```       

## Working with Persistent Volumes and Persistent Volume Claims in Kubernetes
```bash
- kubectl get pv
- kubectl get pvc
- kubectl get pvc -n <namespace>        
- kubectl describe pv <pv-name>
- kubectl describe pvc <pvc-name> -n <namespace>
- kubectl delete pv <pv-name>
- kubectl delete pvc <pvc-name> -n <namespace>
- kubectl apply -f <pvc-definition-file>.yaml
- kubectl apply -f <pv-definition-file>.yaml
```        

## Working with Ingress in Kubernetes
```bash
- kubectl get ingress
- kubectl get ingress -n <namespace>
- kubectl describe ingress <ingress-name> -n <namespace>            
- kubectl delete ingress <ingress-name> -n <namespace>
- kubectl apply -f <ingress-definition-file>.yaml
```

# Kubernetes Cheat Sheet
A quick reference guide for common **kubectl** commands.

---

## Usage
```bash
kubectl <command> [options]
```

## Examples
```bash
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl exec -it <pod-name> -- /bin/bash
kubectl apply -f <file>.yaml
kubectl delete pod <pod-name>
```

---

For more information, visit:  
🔗 [Kubernetes Documentation](https://kubernetes.io/docs/reference/kubectl/)



