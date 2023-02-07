#FROM public.ecr.aws/lambda/provided:al2
FROM public.ecr.aws/amazonlinux/amazonlinux:2022

RUN yum update -y && yum install jq unzip binutils findutils tar xz gzip gcc-c++ boost-devel -y

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip awscliv2.zip &&\
    ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update &&\
    rm -rf ./aws ./awscliv2.zip && aws --version

# Copy custom runtime bootstrap
RUN mkdir -p /var/runtime/lib
COPY ./bootstrap ./function.sh ./EquityOption.cpp /var/runtime

# Install QuantLib 1.29 and compile the EquityOption
RUN mkdir -p /tmp/QuantLib && cd /tmp/QuantLib && \
    curl "http://http.us.debian.org/debian/pool/main/q/quantlib/libquantlib0v5_1.29-1_amd64.deb" -o "./libquantlib0v5_1.29-1_amd64.deb" && \
    ar x libquantlib0v5_1.29-1_amd64.deb && \
    tar xf data.tar.xz -C /var/runtime/lib/ --strip-components=3 ./usr/lib/libQuantLib* && \
    ln -s /var/runtime/lib/libQuantLib.so.0 /var/runtime/lib/libQuantLib.so && \
    curl "http://http.us.debian.org/debian/pool/main/q/quantlib/quantlib_1.29.orig.tar.gz" -o "./quantlib_1.29.orig.tar.gz" && \
    tar xzf ./quantlib_1.29.orig.tar.gz && cd QuantLib-1.29/Examples && \
    g++ /var/runtime/EquityOption.cpp -I../  -o EquityOption/EquityOption  -L/var/runtime/lib   -lQuantLib && \
    cp EquityOption/EquityOption /var/runtime && \
    rm -rf /tmp/QuantLib /var/runtime/EquityOption.cpp
    
# Clean up
RUN yum erase gcc-c++ boost-devel -y

# Set the library path
ENV LD_LIBRARY_PATH /var/runtime/lib/:$LD_LIBRARY_PATH

# Set the entry point
ENTRYPOINT [ "/var/runtime/bootstrap" ]

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "function.handler" ]

