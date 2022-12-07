### Created by James Minock (jmm1018@physics.rutgers.edu)
### GENIE v3.0.4 uboone patch 3 with Reweight package
### Based on ToolAnalysis Dockerfile created by Dr. Benjamin Richards

### Download base image from cern repo on docker hub
FROM quay.io/centos/centos:stream8

### Run the following commands as super user (root):
USER root

### GCC environment
RUN dnf config-manager --set-enabled extras,powertools \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum install -y https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el8-release-latest.rpm \
    && yum install -y \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    python38 \
    python38-devel \
    wget \
    tar \
    cmake \
    binutils \
    libX11-devel \
    libXpm-devel \
    libXft-devel \
    libXext-devel \
    libxml2-devel \
    libpng \ 
    libpng-devel \
    libjpeg-devel \
    graphviz-devel \
    mesa-libGL-devel \
    mesa-libGLU-devel \
    make \
    file \
    git \
    patch \
    bzip2-devel \
    cvs \
    automake \
    svn  \ 
    libtool \
    libxml2 \ 
    which \
    gsl-devel \
    emacs \
    curl \
    curl-devel \
    osg-ca-certs \
    osg-wn-client \
    openssl-devel \
    fftw3 \
    fftw3-devel \
    libnsl2-devel \
	python3-devel \
	python2 \
	python2-devel \
	bzip2 \
    && yum clean all \
    && rm -rf /var/cache/yum \
	&& mkdir Genie \
	&& cd Genie \
	&& wget https://github.com/ANNIEsoft/GENIE-v3/archive/refs/heads/master.zip \
	&& unzip master.zip \
	&& rm -rf master.zip

### fsplit
RUN source /Genie/GENIE-v3-master/annie/Setup_GENIE.sh \
	&& cd Genie \
	&& mkdir fsplit && cd fsplit \
	&& wget https://gist.githubusercontent.com/marc1uk/c0e32d955dd1c06ef69d80ce643018ad/raw/10e592d42737ecc7dca677e774ae66dcb5a3859d/fsplit.c \
	&& gcc fsplit.c -o fsplit

### log4cpp
RUN source /Genie/GENIE-v3-master/annie/Setup_GENIE.sh \
	&& cd Genie \
	&& cvs -d :pserver:anonymous@log4cpp.cvs.sourceforge.net:/cvsroot/log4cpp -z3 co log4cpp \
	&& cd log4cpp/ \
	&& mkdir install \
	&& ./autogen.sh \
	&& ./configure --prefix=/Genie/log4cpp/install \
	&& make \
	&& make install

### Pythia6
### dummies must be removed for LHAPDF which is needed for Reweight package
RUN source /Genie/GENIE-v3-master/annie/Setup_GENIE.sh \
	&& cd Genie \
	&& git clone https://github.com/GENIE-MC-Community/Pythia6Support.git \
	&& cd Pythia6Support \
	&& ./build_pythia6.sh --dummies=remove

### ROOT
RUN source /Genie/GENIE-v3-master/annie/Setup_GENIE.sh \
	&& cd Genie \
	&& wget https://root.cern.ch/download/root_v6.24.06.source.tar.gz \
	&& tar zxf root_v6.24.06.source.tar.gz \
	&& rm -rf root_v6.24.06.source.tar.gz \
	&& cd root-6.24.06 \
	&& mkdir install  \
	&& cd install \
	&& cmake ../ -DCMAKE_CXX_STANDARD=14 \
	-Dgdml=ON -Dxml=ON -Dmt=ON -Dmathmore=ON -Dx11=ON \
	-Dimt=ON -Dtmva=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -Dpythia6=ON -Dfftw3=ON \
	&& make \
	&& make install \
	&& cd ../ \
	&& /bin/bash -O extglob -c 'rm -rf !(install)'

### LHAPDF
### Necessary for Reweight package
RUN source /Genie/GENIE-v3-master/annie/Setup_GENIE.sh \
	&& cd Genie \
	&& wget http://lhapdf.hepforge.org/downloads/LHAPDF-6.3.0.tar.gz \
	&& tar zxf LHAPDF-6.3.0.tar.gz \
	&& rm -rf LHAPDF-6.3.0.tar.gz \
	&& cd LHAPDF-6.3.0 \
	&& mkdir install \
	&& ./configure --prefix=/Genie/LHAPDF-6.3.0/install \
	&& make \
	&& make install \
	&& cd install/share/LHAPDF \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/CT10.LHgrid \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/cteq61.LHpdf \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/cteq61.LHgrid \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/GRV98lo.LHgrid \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/GRV98lo_patched.LHgrid \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/GRV98nlo.LHgrid \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/GRVG0.LHgrid \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/GRVG1.LHgrid \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/GRVPI0.LHgrid \
	&& wget http://lhapdf.hepforge.org/downloads/pdfsets/5.9.1/GRVPI1.LHgrid \
	&& cd /Genie/LHAPDF-6.3.0 \
	&& /bin/bash -O extglob -c 'rm -rf !(install)'

### GENIE
### env variables need to be set before configuration/installation
RUN source /Genie/GENIE-v3-master/annie/Setup_GENIE.sh \
	&& cd Genie/GENIE-v3-master/ \
	&& mkdir install \
	&& ./configure --prefix=/Genie/GENIE-v3-master/install/ \
	--with-pythia6-lib=/Genie/Pythia6Support/v6_424/lib/ \
	--with-log4cpp-inc=/Genie/log4cpp/install/include/ \
	--with-log4cpp-lib=/Genie/log4cpp/install/lib/ \
	--enable-fnal --enable-lhapdf6 --enable-rwght \
	&& make -j4 \
	&& make install \
	&& cd src/ \
	&& rm -rf Framework/ \
	&& rm -rf Physics/ \
	&& rm -rf Tools/

CMD ["/bin/bash"]
