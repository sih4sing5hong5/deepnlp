FROM tensorflow/tensorflow:1.5.0-py3
MAINTAINER sih4sing5hong5

RUN apt-get update
RUN apt-get install -y python3 virtualenv g++ python3-dev make

# Switch locale
RUN apt-get install -y locales
RUN locale-gen zh_TW.UTF-8
ENV LC_ALL zh_TW.UTF-8

RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip

RUN apt-get install -y git

WORKDIR /usr/local/
RUN git clone https://github.com/rockingdingo/deepnlp.git

WORKDIR /usr/local/deepnlp
RUN pip3 install deepnlp
RUN apt-get install -y curl

COPY CRF++-0.58.tar.gz CRF++-0.58.tar.gz
RUN tar xzvf CRF++-0.58.tar.gz
WORKDIR /usr/local/deepnlp/CRF++-0.58
RUN ./configure
RUN make
RUN make install

# install python interface
WORKDIR /usr/local/deepnlp/CRF++-0.58/python
RUN python3 setup.py build
RUN python3 setup.py install
RUN ln -s /usr/local/lib/libcrfpp.so.0 /usr/lib/

WORKDIR /usr/local/deepnlp
RUN python3 test/test_pos_zh.py
