FROM debian:stretch
MAINTAINER j.camilo.garcia@hotmail.com

# Install Dependences
# More info https://cran.r-project.org/bin/linux/debian/
RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
		apt-utils \		
		wget \		
dirmngr \
		gnupg \		
	&& echo "deb http://cloud.r-project.org/bin/linux/debian stretch-cran34/" >> /etc/apt/sources.list \
	&& apt-key adv --keyserver hkp://keys.gnupg.net:80 --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' \
	&& apt-get update \ 
	&& apt-get install -y --no-install-recommends \	
		r-base \
		r-base-dev \
	&& apt-get install -y cmake \
	&& apt-get install -y git \
	&& mkdir -p /root/dapadfs/workspace_cluster_12/AVISA/data_for_dssat_eaf/dssat_input/Uganda \
	&& mkdir -p /root/dapadfs/workspace_cluster_12/AVISA/data_for_dssat_eaf/cc_raw/scripts \
	&& mkdir -p /root/dapadfs/workspace_cluster_12/AVISA/dssat_test1/uganda_input/dssat-csm-original/Data \
	&& mkdir /root/project \ 
	&& mkdir /root/project/dependencies \
	&& mkdir /root/project/script-R \
	&& cd /root/project \
	&& git clone https://github.com/DSSAT/dssat-csm-os.git
	
# Directories needs for run R script

# ADD input and output files for R script
COPY ./co2.csv /root/dapadfs/workspace_cluster_12/AVISA/data_for_dssat_eaf/cc_raw/scripts
COPY ./test.RDS /root/dapadfs/workspace_cluster_12/AVISA/data_for_dssat_eaf/dssat_input/Uganda

ADD functions /root/dapadfs/workspace_cluster_12/AVISA/data_for_dssat_eaf/cc_raw/scripts/functions
ADD original_files /root/dapadfs/workspace_cluster_12/AVISA/data_for_dssat_eaf/cc_raw/scripts/original_files
	
COPY ./dependencies.R /root/project/dependencies
COPY ./entrypoint.sh /root/project/dependencies
COPY ./DSSAT_ug_mod1.R /root/project/script-R
COPY ./proces_ID.csv /root/project/script-R

RUN cd /root/project/dependencies \
	&& sh entrypoint.sh

# Add volume	
VOLUME [ "/root/project" ]

# docker image build .\debian\3.4.4 --tag stevensotelo/r_docker:debian_3.4.4
# docker container run -it --name r_base stevensotelo/r_docker:debian_3.4.4
