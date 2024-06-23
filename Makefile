deploy:
	@helm package helm-common
	@mv ./helm-common-*.tgz docs
	@helm repo index docs --url https://vtarmo.github.io/helm-common