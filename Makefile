install-flux:
	# helm repo list | grep -q weaveworks || helm repo add weaveworks https://weaveworks.github.io/flux
	helm upgrade --install flux weaveworks/flux \
	  --namespace flux \
		--set rbac.create=true \
		--set git.path=flux \
		--set helmOperator.create=true \
    --set registry.rps=5 \
    --set registry.burst=20 \
		--set git.url=git@github.com:white-hat/flux-test.git \
		--set helmOperator.git.chartsPath=charts
	@sleep 20
	@export FLUX_POD=$$(kubectl get pods --namespace flux -l "app=flux,release=flux" -o jsonpath="{.items[0].metadata.name}")
	@echo '----------'
	@echo 'please add the following key to github.com/anchorfree/k8s-satellite deploy keys add grant it write access'
	@kubectl -n flux logs $$FLUX_POD | grep identity.pub | cut -d '"' -f2
