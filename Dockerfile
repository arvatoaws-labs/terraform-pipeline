FROM mikefarah/yq AS yq
FROM hashicorp/terraform AS terraform
FROM fedora

COPY --from=yq /usr/bin/yq /usr/bin/
COPY --from=terraform /bin/terraform /usr/bin
RUN dnf upgrade -y && dnf install -y awscli wget kubernetes-client git sed hub openssh-clients jq zip && dnf clean all
RUN rm -rf ~/.ssh/known_hosts && \
mkdir ~/.ssh && \
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts