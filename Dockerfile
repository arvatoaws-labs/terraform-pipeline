FROM mikefarah/yq AS yq
FROM hashicorp/terraform AS terraform
FROM fedora

ARG SDMS_PROVIDER_URL=https://storage.googleapis.com/terraform-provider-temp/terraform-provider-sdms
ARG SDMS_PROVIDER_VERSION=0.0.1

COPY --from=yq /usr/bin/yq /usr/bin/
COPY --from=terraform /bin/terraform /usr/bin
RUN dnf upgrade -y && \
dnf install -y awscli wget kubernetes-client git sed hub openssh-clients jq zip && \
dnf clean all
RUN rm -rf ~/.ssh/known_hosts && \
mkdir ~/.ssh && \
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts && \
mkdir -p ~/.terraform.d/plugins/arvato-systems.de/arvato/sdms/${SDMS_PROVIDER_VERSION}/linux_amd64/ && \
wget ${SDMS_PROVIDER_URL} -O ~/.terraform.d/plugins/arvato-systems.de/arvato/sdms/${SDMS_PROVIDER_VERSION}/linux_amd64/terraform-provider-sdms