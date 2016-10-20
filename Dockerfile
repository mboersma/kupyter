FROM gcr.io/google_containers/ubuntu-slim:0.5

COPY requirements.txt /

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -yq python3-minimal python3-pip && \
    pip3 install -r /requirements.txt --disable-pip-version-check --no-cache-dir && \
    apt-get purge -y --auto-remove python3-pip && \
    apt-get autoremove -y && \
    apt-get clean -y

COPY rootfs /
VOLUME /notebooks
EXPOSE 8888
WORKDIR /root
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--notebook-dir=/notebooks", "--port=8888", "-y"]
