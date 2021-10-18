# SLEIGH Library

[SLEIGH](https://ghidra.re/courses/languages/html/sleigh.html) is a language used to describe the semantics of instruction sets of general-purpose microprocessors, with enough detail to facilitate the reverse engineering of software compiled for these architectures. It is part of the [GHIDRA reverse engineering platform](https://github.com/NationalSecurityAgency/ghidra), and underpins two of its major components: its disassembly and decompilation engines.

This repository provides a CMake-based build project for SLEIGH so that it can be built and packaged as a standalone library, and be reused in projects other than GHIDRA.

## Supported Platforms

| Name | Support |
| ---- | ------- |
| Linux | Yes |
| macOS | Yes |
| Windows | Not yet |

## Dependencies and Prerequisites

| Name | Version | Linux Package to Install | macOS Homebrew Package to Install |
| ---- | ------- | ------------------------ | --------------------------------- |
| [Git](https://git-scm.com/) | Latest | git | N/A |
| [Ninja](https://ninja-build.org/) | Latest | ninja-build | ninja |
| [CMake](https://cmake.org/) | 3.21+ | cmake | cmake |
| [Binutils](https://www.gnu.org/software/binutils/) | Latest | binutils and binutils-dev | binutils |
| [Zlib](https://zlib.net/) | Latest | zlib | N/A |
| [Iberty](https://gcc.gnu.org/onlinedocs/libiberty/) | Latest | libiberty-dev | binutils |
| [Doxygen](https://www.doxygen.nl/) | Latest | doxygen | doxygen |
| [GraphViz](https://graphviz.org/) | Latest | graphviz | graphviz |

## Build and Install the SLEIGH Library

```sh
# Clone this repository (CMake project for SLEIGH)
git clone https://github.com/lifting-bits/sleigh.git
cd sleigh

# Update the GHIDRA submodule
git submodule update --init --recursive --progress

# Create a build directory
mkdir build
cd build

# Configure CMake
cmake \
    -DSLEIGH_ENABLE_INSTALL=ON \
    -DCMAKE_INSTALL_PREFIX="<path where SLEIGH will install>" \
    -G Ninja \
    ..

# Build SLEIGH
cmake --build .

# Install SLEIGH
cmake --build . --target install
```

## Packaging

The CMake configuration also supports building packages for SLEIGH. If the `SLEIGH_ENABLE_PACKAGING` option is set during the configuration step, the build step will generate a tarball containing the SLEIGH installation. Additionally, the build will create an RPM package if it finds `rpm` in the `PATH` and/or a DEB package if it finds `dpkg` in the `PATH`.

For example:

```sh
cmake \
    -DSLEIGH_ENABLE_PACKAGING=ON \
    -DCMAKE_INSTALL_PREFIX="<path where SLEIGH will install>" \
    -G Ninja \
    ..

# Build SLEIGH
cmake --build .

# Package SLEIGH
cmake --build . --target package
```

## macOS

### Installing Git and Zlib

The easiest way to install Git and Zlib is by installing the Xcode Command Line Developer Tools:

```sh
xcode-select --install
```

### Installing Iberty

Most of SLEIGH's remaining dependencies can be installed via the [Homebrew package manager](https://brew.sh/) on macOS. The only exception is Iberty which doesn't have a dedicated Homebrew package. Instead, we can edit the `binutils` package to include an Iberty installation.

Firstly, we need to edit the Binutils installation script:

```sh
brew edit binutils
```

The command above will open the installation script with the editor specified by `EDITOR`. We need to add the `--enable-install-libiberty` flag to the `configure` invocation:

```ruby
system "./configure", "--disable-debug",
                      "--disable-dependency-tracking",
                      "--enable-deterministic-archives",
                      "--prefix=#{prefix}",
                      "--infodir=#{info}",
                      "--mandir=#{man}",
                      "--disable-werror",
                      "--enable-interwork",
                      "--enable-multilib",
                      "--enable-64-bit-bfd",
                      "--enable-gold",
                      "--enable-plugins",
                      "--enable-targets=all",
                      "--with-system-zlib",
                      "--disable-nls",
                      "--enable-install-libiberty"
```

Now reinstall Binutils:

```sh
brew reinstall -s binutils
```

### Configuring with Binutils

By default, the Homebrew Binutils installation won't be visible to CMake during the configure step. We can fix this by pointing the `CMAKE_PREFIX_PATH` option at the Binutils installation like so:

```sh
cmake \
    -DSLEIGH_ENABLE_INSTALL=ON \
    -DCMAKE_INSTALL_PREFIX="<path where SLEIGH will install>" \
    -DCMAKE_PREFIX_PATH=/opt/homebrew/opt/binutils/ \
    -G Ninja \
    ..
```

## License

See the LICENSE file in the top directory of this repo.