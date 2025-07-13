FROM jupyter/scipy-notebook:latest
WORKDIR /home/jovyan/work
COPY environment.yml .
RUN conda env update -n base -f environment.yml && conda clean --all -f -y
COPY . .
EXPOSE 8888
