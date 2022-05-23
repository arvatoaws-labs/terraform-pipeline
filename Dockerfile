FROM ghcr.io/arvatoaws-labs/yq AS yq
FROM ghcr.io/arvatoaws-labs/terraform:1.2.0 AS terraform
FROM ghcr.io/arvatoaws-labs/fedora:36

VOLUME /var/lib/docker

ADD kubernetes.repo /etc/yum.repos.d/

# ARG SDMS_PROVIDER_URL=https://storage.googleapis.com/terraform-provider-temp/terraform-provider-sdms
# ARG SDMS_PROVIDER_VERSION=0.0.1

COPY --from=yq /usr/bin/yq /usr/bin/
COPY --from=terraform /bin/terraform /usr/bin
RUN dnf upgrade -y && \
dnf install -y awscli wget kubectl git sed hub openssh-clients jq zip && \
dnf clean all
RUN rm -rf ~/.ssh/known_hosts && \
mkdir ~/.ssh && \
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# RUN mkdir -p ~/.terraform.d/plugins/arvato-systems.de/arvato/sdms/${SDMS_PROVIDER_VERSION}/linux_amd64/ && \
# wget ${SDMS_PROVIDER_URL} -O ~/.terraform.d/plugins/arvato-systems.de/arvato/sdms/${SDMS_PROVIDER_VERSION}/linux_amd64/terraform-provider-sdms && \
# chmod 755 ~/.terraform.d/plugins/arvato-systems.de/arvato/sdms/${SDMS_PROVIDER_VERSION}/linux_amd64/terraform-provider-sdms