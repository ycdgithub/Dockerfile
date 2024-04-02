# 使用官方的Ubuntu镜像作为基础镜像
FROM ubuntu:latest

# 设置工作目录
WORKDIR /app

# 更新软件包列表并安装必要的软件包
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y \
    python3.8 \
    python3.8-venv \
    python3.8-distutils \
    && rm -rf /var/lib/apt/lists/*

# 设置默认Python版本
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# 创建并激活Python虚拟环境
RUN python3.8 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# 复制requirements文件到容器内并安装Python依赖
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 设置环境变量（可选）
ENV VARIABLE_NAME=value
