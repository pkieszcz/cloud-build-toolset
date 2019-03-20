FROM google/cloud-sdk:alpine

LABEL maintainer="Piotr Kieszczyński <piotr.kieszczynski@gmail.com>"

ARG HELM_VERSION=2.13.0
ARG HELM_SRC=https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz
ARG HELM_DEST=/usr/local/bin/helm

ARG SKAFFOLD_VERSION=v0.25.0
ARG SKAFFOLD_SRC=https://storage.googleapis.com/skaffold/releases/$SKAFFOLD_VERSION/skaffold-linux-amd64
ARG SKAFFOLD_DEST=/usr/local/bin/skaffold

# Install *nix dependencies
RUN apk --no-cache add git curl jq docker ca-certificates && \
	apk --no-cache del wget 

# Update & install gcloud dependencies
RUN gcloud components update --quiet && \
	gcloud auth configure-docker && \

	# Kubectl
	gcloud components install kubectl --quiet && \

	# Helm
    curl -#SL $HELM_SRC | tar zxvf - && \
	mv linux-amd64/helm $HELM_DEST && rm -rf linux-amd64 && \
	chmod +x $HELM_DEST && \
	mkdir -p ~/.kube && \
	helm init -c && \

	# Skaffold
    curl -#SLo $SKAFFOLD_DEST $SKAFFOLD_SRC && \
	chmod +x $SKAFFOLD_DEST
