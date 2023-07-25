all: build-metrics

build-metrics:

build-%:
	test -d "$*"
	mkdir -p out
	kustomize build --enable-helm "$*" > "out/$*.yaml"

update-observability:
	curl -sSL https://raw.githubusercontent.com/cilium/cilium/main/examples/kubernetes/addons/prometheus/monitoring-example.yaml > base/cilium-observability/manifest.gen.yaml
