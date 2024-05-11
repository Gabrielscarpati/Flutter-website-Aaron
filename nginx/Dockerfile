# Usa a imagem oficial do NGINX como base
FROM nginx

# Copia a configuração customizada do NGINX para o container
COPY nginx.conf /etc/nginx/nginx.conf

# Expõe as portas 80 para tráfego HTTP
EXPOSE 80

# Inicia o NGINX em primeiro plano para que o container não termine imediatamente
CMD ["nginx", "-g", "daemon off;"]
