# Utiliza a imagem oficial do Dart como base, já que o Flutter é baseado em Dart
FROM dart:stable

# Instala as dependências necessárias para o Flutter
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    xz-utils \
    curl \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho
WORKDIR /app

# Baixa e instala o Flutter SDK
RUN curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz \
    && tar -xvf flutter_linux_3.19.6-stable.tar.xz -C /usr/local \
    && rm flutter_linux_3.19.6-stable.tar.xz

# Configura o path do Flutter
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Copia os arquivos do projeto para o container
COPY . .

# Obtém as dependências do projeto Flutter
RUN flutter pub get

# Pré-compila as dependências de runtime para melhoria do tempo de inicialização
RUN flutter precache

# Gera os arquivos de build
RUN flutter build web

# Expõe a porta 8080 para o servidor web
EXPOSE 8080

# Utiliza o servidor web básico para servir o conteúdo
CMD ["dhttpd", "--path", "build/web", "--port", "8080"]
