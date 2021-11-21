FROM golang:1.16 AS builder

COPY . /src
WORKDIR /src

<<<<<<< HEAD
RUN GOPROXY=https://goproxy.cn make build
=======
# 为我们的镜像设置必要的环境变量
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
	GOPROXY="https://goproxy.cn,direct"

RUN bash -c "go get github.com/golang/protobuf/{proto,protoc-gen-go}"
RUN bash -c "go get -u github.com/go-kratos/kratos/cmd/kratos/v2@latest"

RUN GOPROXY=https://goproxy.cn 

RUN make build
>>>>>>> 44291340c927b8ff210d44e9116905985bdf2067

FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates  \
        netbase \
        && rm -rf /var/lib/apt/lists/ \
        && apt-get autoremove -y && apt-get autoclean -y

COPY --from=builder /src/bin /app

WORKDIR /app

<<<<<<< HEAD
EXPOSE 8000
EXPOSE 9000
=======
EXPOSE 8080
EXPOSE 9080
>>>>>>> 44291340c927b8ff210d44e9116905985bdf2067
VOLUME /data/conf

CMD ["./server", "-conf", "/data/conf"]
