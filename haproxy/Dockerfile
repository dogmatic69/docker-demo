FROM haproxy:1.6

ENV CONSUL_TEMPLATE_VERSION 0.15.0
ENV CONSUL_SHA256 b7561158d2074c3c68ff62ae6fc1eafe8db250894043382fb31f0c78150c513a

ENV TINI_VERSION v0.10.0

RUN apt-get update \
    && apt-get install -y curl ca-certificates unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -SL "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" -o consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
	&& echo "${CONSUL_SHA256} consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" | sha256sum -c \
    && unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
    && mv consul-template /usr/local/bin/consul-template \
	&& rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
	&& mkdir -p /haproxy /consul-template/config.d /consul-template/template.d \
	&& curl -SL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" -o /usr/local/bin/tini \
    && chmod +x /usr/local/bin/tini \
	&& apt-get purge -y --auto-remove curl unzip

COPY start.sh /start.sh
COPY config/ /consul-template/config.d/
COPY template.d/ /consul-template/template.d/

CMD ["/start.sh"]