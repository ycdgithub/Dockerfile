# 使用官方的Ubuntu镜像作为基础镜像
FROM ubuntu:latest

# 防止在安装过程中出现交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# 设置工作目录
WORKDIR /app

# 更新软件包列表并安装必要的软件包
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    vim \
    curl \
    wget \
    git \
    man-db \
    gdb \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y \
    python3.8 \
    python3.8-venv \
    python3.8-distutils \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# 创建并激活Python虚拟环境
RUN python3.8 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# 复制requirements文件和post-create脚本到容器内
COPY requirements.txt /app/
COPY .devcontainer/post-create.sh /usr/local/bin/post-create.sh

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 设置post-create脚本为可执行，并执行它
RUN chmod +x /usr/local/bin/post-create.sh && \
    /usr/local/bin/post-create.sh

# 设置环境变量（可选，根据需要添加）
ENV VARIABLE_NAME=value

# 后续的Dockerfile指令...
