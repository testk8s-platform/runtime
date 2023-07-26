build-all: build-metrics
push-all: push-metrics

build-%:
	test -d "$*"
	mkdir -p out
	kustomize build --enable-helm "$*" > "out/$*.yaml"

push-%:
	# Push manifests to GHCR using the branch as the OCI artifact tag
	flux push artifact "oci://ghcr.io/testk8s-platform/$*:$(shell git branch --show-current)" \
		--path="$*" \
		--source="$(shell git config --get remote.origin.url)" \
		--revision="$(shell git branch --show-current)@sha1:$(shell git rev-parse HEAD)"

update-observability:
	curl -sSL https://raw.githubusercontent.com/cilium/cilium/main/examples/kubernetes/addons/prometheus/monitoring-example.yaml > base/cilium-observability/manifest.gen.yaml

.PHONY: build-all push-all $(filter build-%,$(MAKECMDGOALS)) $(filter push-%,$(MAKECMDGOALS)) update-observability
