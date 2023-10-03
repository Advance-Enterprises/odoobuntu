FROM ghcr.io/ajoeofalltrades/odoo-on-ubuntu:latest
SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

ENV XDG_DATA_HOME=/srv/odoo/filestore
ENV ODOO_RC=/srv/odoo/.odoorc

# Expose the default ports for browser and web traffic.
EXPOSE 80 443 8069 8071 8072

# Create a persistent volume for storing the odoo source.
# Create a persistent volume for storing cached and/or user uploaded files.
VOLUME /srv/odoo/src /srv/odoo/filestore

USER root

RUN apt-get update && \
# Install the new packages
xargs apt-get install -y --no-install-recommends nginx  && \
# Clean up after ourselves.
apt-get clean && \
rm -rf /var/lib/apt/lists/

# Copy any temp files needed into the image.
# You can add files you need to ./sources/
# The directory will be deleted from the image later, so move the files you need to persist somewhere else on the image.
COPY sources/odoo.conf /etc/nginx/sites-enabled/odoo.conf


# Moving forward our default user is going to be Odoo.
USER odoo

COPY sources/.odoorc /srv/odoo/.odoorc


# Set the working directory to the future location of the Odoo source code.
WORKDIR /srv/odoo

ENTRYPOINT src/odoo-bin