# Stage 1:
FROM alpine:latest AS builder

WORKDIR /app

COPY . .

# Stage 2:
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
