FROM alpine:3.15

ENV SLEIGH_DIR /usr/lib/sleigh

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN apk update && apk add git \
    make \
    cmake \
    g++

# This is too big to fit in memory so I'll have to figure out something else
RUN git config --global user.name "username" && \
    git config --global user.email "username@email.com" && \
    cmake -B build -S . -Dsleigh_ENABLE_EXAMPLE=ON && \
    cmake --build build -j && \
    cmake --install build --prefix $(SLEIGH_DIR)
    
ENTRYPOINT ["sleigh-lift"]
CMD ["pcode", "x86-64.sla", "4881ecc00f0000"]



