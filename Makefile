helm:
	helm package charts/hello-1 -d packages && \
	helm package charts/hello-2 -d packages && \
	helm package charts/hello-3 -d packages && \
	helm repo index --url https://github.com/nicholasSUSE/helm-charts-test .