FROM ubuntu:20.04

ENV SLEIGH_DIR

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN apt update && apt install git cmake

RUN cmake -B build -S . -Dsleigh_ENABLE_EXAMPLE=ON && \
    cmake --build build -j && \
    cmake --install build --prefix $(SLEIGH_DIR)
    
ENTRYPOINT ["sleigh-lift"]
CMD ["pcode", "x86-64.sla", "4881ecc00f0000"]



