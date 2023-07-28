build-all: build-metrics
push-all: push-metrics

build-%:
	test -d "$*"
	mkdir -p out
	kustomize build --enable-helm "config/$*" > "out/$*.yaml"

push-%:
	# Push manifests to GHCR using the branch as the OCI artifact tag
	flux push artifact "oci://ghcr.io/testk8s-platform/runtime:$(shell git branch --show-current)" \
		--path=config \
		--source="$(shell git config --get remote.origin.url)" \
		--revision="$(shell git branch --show-current)@sha1:$(shell git rev-parse HEAD)"

update-observability:
	curl -sSL https://raw.githubusercontent.com/cilium/cilium/main/examples/kubernetes/addons/prometheus/monitoring-example.yaml > config/base/cilium-observability/manifest.gen.yaml

.PHONY: build-all push-all $(filter build-%,$(MAKECMDGOALS)) $(filter push-%,$(MAKECMDGOALS)) update-observability
