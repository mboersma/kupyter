FROM gcr.io/google_containers/ubuntu-slim:0.5

COPY requirements.txt /

RUN export DEBIAN_FRONTEND=noninteractive TINI_VERSION=v0.10.0 && \
    apt-get update && \
    apt-get install -yq python3-minimal python3-pip wget && \
    pip3 install -r /requirements.txt --disable-pip-version-check --no-cache-dir && \
    wget -q https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -O /usr/bin/tini && \
    chmod +x /usr/bin/tini && \
    apt-get purge -y --auto-remove python3-pip wget && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm /requirements.txt && \
    useradd -m -d /home/kupyter kupyter

WORKDIR /home/kupyter
VOLUME /kupyter/notebooks
EXPOSE 8888

COPY rootfs /
RUN chown -R kupyter:kupyter /home/kupyter
USER kupyter

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["jupyter", "notebook", "--no-browser", "--notebook-dir=/kupyter/notebooks", "--port=8888", "-y"]
