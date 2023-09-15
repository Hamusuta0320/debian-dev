FROM debian:bookworm
# git
# github.com release => download.fastgit.org
# git raw => raw.fastgit.org
# git clone => https://hub.fastgit.org
# rustup
ENV RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static
ENV RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup
ENV GOROOT /opt/go
ENV GOPATH /opt/go/gopath
ENV NVM_DIR /opt/.nvm
ENV PROFILE_LOCATION /etc/profile
ENV WORKSPACE /workspace
ENV CN 1
# nvm
ENV NVM_DOWNLOAD_URL https://185.199.108.133/creationix/nvm/master/install.sh
ENV NODE_MIRROR https://mirrors.ustc.edu.cn/node/
ENV NVM_NODEJS_ORG_MIRROR https://mirrors.ustc.edu.cn/node/
ENV NPM_REGISTRY https://npmreg.proxy.ustclug.org/
# default workspace
WORKDIR ${WORKSPACE}
RUN cp /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.bak && \
sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
apt update && \
apt upgrade && \
apt install git build-essential net-tools iputils-ping curl gnupg2 gcc g++ vim wget -yqq && \
wget -q -O /workspace/rustup-init.sh https://sh.rustup.rs && \
chmod +x /workspace/rustup-init.sh && \
/workspace/rustup-init.sh -y && \
rm -rf /workspace/rustup-init.sh && \
echo "[source.crates-io]" >> ${HOME}/.cargo/config && \
echo "replace-with = 'ustc'" >> ${HOME}/.cargo/config && \
echo "" >> ${HOME}/.cargo/config && \
echo "[source.ustc]" >> ${HOME}/.cargo/config && \
echo 'registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"' >> ${HOME}/.cargo/config && \
mkdir -p /opt && \
# only support amd64 arch current
# install go
wget -q -O /workspace/go.tar.gz https://golang.google.cn/dl/go1.21.1.linux-amd64.tar.gz && \
mkdir -p /opt/go && tar -zxf /workspace/go.tar.gz --strip-components 1 -C ${GOROOT} && \
echo 'GOPATH=/opt/go/gopath' >> ${PROFILE_LOCATION} && \
echo 'GOROOT=/opt/go' >> ${PROFILE_LOCATION} && \
# set PATH
echo 'export PATH=$GOROOT/bin:$PATH' >> ${PROFILE_LOCATION} && \
. ${PROFILE_LOCATION} && \
go env -w GO111MODULE=on && \
go env -w GOPROXY=https://goproxy.cn,direct && \
rm -rf /workspace/go.tar.gz && \
# install python3
apt install python3 -yqq && \
# install python3-pip
apt install python3-pip -yqq && \
# change mirror of pypi
pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple
# install nvm
RUN mkdir -p /opt/.nvm && \
echo "registry=${NPM_REGISTRY}" > ~/.npmrc && \
wget --no-dns-cache --no-check-certificate \
--header 'Host: raw.githubusercontent.com' \
--inet4-only -O /workspace/nvm.sh ${NVM_DOWNLOAD_URL} && \
chmod +x /workspace/nvm.sh && \
/workspace/nvm.sh && \
rm -rf /workspace/nvm.sh && \
. ${NVM_DIR}/nvm.sh && \
nvm install node --lts && \
npm install -g yarn pnpm

