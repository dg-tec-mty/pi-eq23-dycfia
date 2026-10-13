FROM fedora:44
RUN dnf install -y git make cmake gcc-c++ \
        elements-devel elements-alexandria-devel \
        python3-devel python3-numpy python3-setuptools \
        boost-devel boost-python3-devel \
        CCfits-devel blas-devel fftw-devel levmar-devel log4cpp-devel \
        onnxruntime-devel wcslib-devel gmock-devel gtest-devel \
    && dnf clean all
# 1.0.3 is the last release built against Alexandria 2.32.0, which is what Fedora 44 ships
RUN git clone --depth 1 --branch 1.0.3 https://github.com/astrorama/SourceXtractorPlusPlus.git
WORKDIR /SourceXtractorPlusPlus
ENV CMAKE_PROJECT_PATH=/usr/lib64/cmake/ElementsProject
ENV CMAKEFLAGS="-DPYTHON_EXPLICIT_VERSION=3 -DUSE_SPHINX=OFF -DELEMENTS_BUILD_TESTS=OFF -DCMAKE_POLICY_VERSION_MINIMUM=3.5"
RUN make -j$(nproc) && make install && mv InstallArea/* /opt/sourcextractor
ENV PATH=/opt/sourcextractor/bin:$PATH \
    LD_LIBRARY_PATH=/opt/sourcextractor/lib64:/opt/sourcextractor/lib \
    PYTHONPATH=/opt/sourcextractor/python
WORKDIR /
RUN sourcextractor++ --help
