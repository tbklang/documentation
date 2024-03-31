FROM ubuntu:latest

# Don't prompt during any installation
# when using apt
ARG DEBIAN_FRONTEND=noninteractive

# Update the system
RUN apt update
RUN apt upgrade -y

# Install dependencies
RUN apt install mkdocs pandoc git -y

RUN apt install texlive -y

RUN apt install python3-pip -y
RUn pip install pymdown-extensions mkdocs-bootswatch-classic 
# RUn pip install mkdocs-exclude-search
RUn pip install mkdocs-exclude
RUN pip install mkdocs-material
RUN pip install mkdocs-material-extensions

# RUN pip install mkdocs-material

# Install stuff to build pandoc-plot
# RUN apt install curl -y
# RUn /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# RUN brew install pandoc-plot
# WORKDIR /tmp
# RUN git clone https://github.com/LaurentRDC/pandoc-plot
# WORKDIR pandoc-plot
# RUN apt install cabal-install haskell-stack -y
# RUN cabal update
# RUN cabal install
# RUN stack install.
COPY pandoc-plot /bin/.

RUN groupadd tlang --gid 1000
RUN useradd tlang --uid 1000 --gid 1000


# TODO: Install mkdocs plugins
# TODO: install latex stuff

WORKDIR /home/tlang


# Just copy across the startup
# script and make it executable
COPY dockermake.sh .
RUN chown tlang:tlang dockermake.sh
RUN chmod +x dockermake.sh



# RUN apt install wget -y
# RUN wget https://github.com/LaurentRDC/pandoc-plot/releases/download/1.7.0/pandoc-plot-Linux-x86_64-static.zip
# RUN unzip -v *.zip

# Switch to the tlang user 
USER tlang

# Run enrtypoint
CMD ./dockermake.sh
