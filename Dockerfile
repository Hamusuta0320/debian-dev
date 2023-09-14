FROM debian:bookworm
ENV RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static
ENV RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup
WORKDIR /workspace
RUN cp /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.bak && \
sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
apt update && \
apt upgrade && \
apt install git -y && \
apt install gcc -y && \
apt install g++ -y && \
apt install vim -y && \
apt install curl -y && \
curl --proto '=https' --tlsv1.2 -o /workspace/rustup-init.sh -sSf https://sh.rustup.rs && \
chmod +x /workspace/rustup-init.sh && \
/workspace/rustup-init.sh -y && \
rm -rf /workspace/rustup-init.sh && \
echo "[source.crates-io]" >> ${HOME}/.cargo/config && \
echo "replace-with = 'ustc'" >> ${HOME}/.cargo/config && \
echo "" >> ${HOME}/.cargo/config && \
echo "[source.ustc]" >> ${HOME}/.cargo/config && \
echo 'registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"' >> ${HOME}/.cargo/config
