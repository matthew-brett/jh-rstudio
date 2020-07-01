# Thanks to
# Min RK: https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues/990#issuecomment-432269851
# Michael Pilosov: https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues/990#issuecomment-562979055
FROM jupyter/datascience-notebook

# install jupyter-rsession-proxy extension
RUN python3 -m pip install jupyter-rsession-proxy
RUN cd /tmp/ && \
    git clone --depth 1 https://github.com/jupyterhub/jupyter-server-proxy && \
    cd jupyter-server-proxy/jupyterlab-server-proxy && \
    npm install && npm run build && jupyter labextension link . && \
    npm run build && jupyter lab build

# install rstudio-server
USER root
RUN apt-get update && \
    curl --silent -L --fail https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.3.959-amd64.deb > /tmp/rstudio.deb && \
    echo '4deee7e17700cf1d64a106b707f1c6d8 /tmp/rstudio.deb' | md5sum -c - && \
    apt-get install -y /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean
ENV PATH=$PATH:/usr/lib/rstudio-server/bin
USER $NB_USER
