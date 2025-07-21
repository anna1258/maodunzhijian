# layers

Docker 镜像由一系列 只读层（layers） 组成，每一层代表一次文件系统变更（如安装软件包、复制文件、修改配置等）。这些层通过 Union File System（联合文件系统） 叠加成最终的容器文件系统。理解 layers 是优化镜像大小、构建速度和缓存效率的关键。

## 层的本质

- 只读层：镜像中的每一层都是只读的，无法直接修改。
- 可写层（容器层）：当容器运行时，Docker 会在镜像顶部添加一个可写层（称为 container layer），所有运行时修改（如文件写入、删除）都发生在这里，不会影响镜像本身。

## 层的来源
- Dockerfile 指令：每条 `Dockerfile` 指令（如 `RUN`、`COPY`、`ADD`）都会生成一个新层。
  ```dockerfile
  FROM ubuntu:20.04          # 第一层：基础镜像
  RUN apt-get update         # 第二层：更新包列表
  COPY app.py /app/          # 第三层：复制文件
  CMD ["python", "/app/app.py"] # 第四层：设置默认命令
  ```
- 基础镜像层：`FROM` 指令指定的镜像本身也是由多层组成的

## **层的特性**
- 唯一性：每层通过 SHA256 哈希 标识，确保内容不可变。
- 共享与复用：相同层可以被多个镜像共享（节省存储空间）。
- 缓存机制：如果某层的指令和依赖未变化，Docker 会复用缓存层，加速构建。

## **查看镜像的层**
使用 `docker history` 查看镜像的层及大小：

```bash
docker history nginx:latest
```
输出示例：

```
IMAGE          CREATED        CREATED BY                                      SIZE
<missing>      2 weeks ago    /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
<missing>      2 weeks ago    /bin/sh -c #(nop)  STOPSIGNAL SIGQUIT           0B
<missing>      2 weeks ago    /bin/sh -c #(nop)  EXPOSE 80                    0B
<missing>      2 weeks ago    /bin/sh -c apt-get update && apt-get install…   100MB
```

## **优化层的实践**
- 减少层数：合并多条 `RUN` 指令（使用 `&&` 或 `\`）。
  ```dockerfile
  RUN apt-get update && \
      apt-get install -y curl && \
      rm -rf /var/lib/apt/lists/*
  ```
  
- 利用缓存：将频繁变动的指令（如 `COPY`）放在 `Dockerfile` 末尾。

- 多阶段构建：通过 `FROM ... AS` 减少最终镜像的层数。

# docker cearch

docker search nginx  在dockerhub上寻找和nginx相关的镜像，但是docker search nginx 3.1这样是不行的，不支持搜特定版本

# saving and loading images

`docker save` 和 `docker load` 是一对“打包-还原”命令，用来把镜像（image）离线保存成一个文件，再在另一台机器或另一台 Docker 上还原。它们不涉及容器运行状态，只处理镜像本身。

使用场景：不能联网时进行镜像迁移或备份。有网就用pull/push更快更方便。

docker save nginx > nginx.tar 打包文件在当前文件夹下生成。如果docker rmi nginx后本地没有nginx镜像了，依然可以load nginx.tar来docker run nginx。

docker load < nginx.tar 恢复image，然后在docker images中又可以看到这个镜像了。

# docker tag

docker tag nginx:latest my-nginx:v1 给nginx:latest新建一个image名叫my-nginx，tag为v1.

此时执行

```shell
labex:project/ $ docker images
REPOSITORY                    TAG       IMAGE ID       CREATED        SIZE
custom-nginx                  latest    615364985d6d   2 hours ago    192MB
my-nginx                      v1        22bd15417453   35 hours ago   192MB
nginx                         latest    22bd15417453   35 hours ago   192MB
```

nginx:latest和my-nginx是同一个镜像，但是有两个名字。

tag没有新建镜像，只是为镜像起了一个别名，通常用于版本控制，人类理解记忆，以及为测试或生产环境而起别名。

# docker run

docker run  --name nginx-detached nginx

--name nginx-detached 是为容器起的名字

## detached mode and interactive mode.

docker run -it --name ubuntu-interactive ubuntu /bin/bash  -it表示交互式启动，/bin/bash是在容器内执行/bin/bash。这样会显示

```shell
labex:project/ $ docker run -it --name ubuntu-interactive ubuntu /bin/bash 
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
32f112e3802c: Pull complete 
Digest: sha256:c4570d2f4665d5d118ae29fb494dee4f8db8fcfaee0e37a2e19b827f399070d3
Status: Downloaded newer image for ubuntu:latest
root@784011d19a1a:/# 
```

交互完毕后键入exit退出交互。

docker run -d --name nginx-detached nginx 分离模式，即没有终端交互

## port mapping

docker run -d --name nginx-with-port -p 8080:80 nginx 将主机的8080映射到容器的80端口

```shell
labex:project/ $ docker port nginx-with-port 
80/tcp -> 0.0.0.0:8080
```

## Environment Variables启动时为容器设置环境变量

容器进程本身的环境变量只能在启动时一次性注入

docker run --name env-test -e MY_VAR="Hello, Environment" -d ubuntu 为容器设置值为MY_VAR的环境变量

## Resource Constraints启动容器时为容器限制内存cpu

docker run --name limited-nginx -d --memory=512m --cpus=0.5 nginx 限制内存和cpu

## Volume Mounting

docker run -d --name nginx-volume -p 8081:80 -v ~/project/nginx-data:/usr/share/nginx/html nginx 将主机上的~/project/nginx-data挂载到/usr/share/nginx/html中。tip:挂载点在容器创建时就需要确定了，在容器创建后挂载点不可修改。

## Network Settings

docker network create my-custom-network 新建一个自定义的网络桥

docker run -d --name nginx-networked --network my-custom-network nginx 将容器nginx-networked连接到刚创建的my-custom-network网络中，在同一网络中的容器可以通过容器名作为主机名互相连接

## Restart Policies

docker run -d --name nginx-restart --restart unless-stopped nginx，以unless-stopped的重启策略启动容器。

重启策略共有：

no：默认的no，从不重启

on-failure：只在退出状态为非0的时候重启

always：无论退出状态的什么都重启

unless-stopped：除非是用户主动退出否则都会自动重启

启动容器时为容器内新建目录并在容器内执行命令

docker run -d --name nginx-custom -w /app nginx sh -c "touch newfile.txt && nginx -g 'daemon off;'"

和docker exec的区别是第一个是启动时，第二个是在容器运行时执行命令，且docker exec是新起的一个进程去执行命令。

## tip

以/bin/bash为默认命令的镜像直接docker run会直接退出，需要-it、-d、sleep infinity`、`tail -f /dev/null`、`nginx -g 'daemon off;'来保持进程。以/bin/bash为默认命令的有ubuntu、alpine



# docker ps -a和docker ps区别

- `docker ps`：只看**正在运行**的容器（running）。
- `docker ps -a`：看**所有状态**的容器（running / exited / created / dead …）

# docker rm和docker stop

docker rm ubuntu-interactive，在执行docker rm后，docker ps -a将不会再列出，但是docker stop 是会列出的

# docker inspect

docker inspect nginx-detached  列出容器详情，json格式的，包含IP等。

# docker port 

```shell
labex:project/ $ docker port nginx-with-port 
80/tcp -> 0.0.0.0:8080  
```

容器内的80端口映射到主机的8080

# docker logs

docker logs nginx-detached

docker logs --tail 10 nginx-detached查看nginx-detached的最近10条日志，因为日志是从小网上看的，最下面的最新

docker logs -f nginx-detached，实时跟踪最新的日志

docker logs --timestamps nginx-detached 为日志打时间戳

# docker exex

它用于在 运行中的容器 内执行命令。容器必须处于“正在运行”状态（`Up ...`）不然报错。命令格式为：docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

docker exec nginx-detached echo "Hello from inside the container"

如果交互式写法可以写：docker exec -it nginx-detached /bin/sh，完毕后输入exit退出交互。

在 nginx 容器里列出根目录：docker exec nginx ls /

docker exec env-test env | grep MY_VAR



# 容器与主机间的拷贝

在host上执行：

docker cp hello.html nginx-detached:/usr/share/nginx/html/hello.html

docker cp nginx-detached:/etc/nginx/nginx.conf ~/project/nginx.conf



# 命令中的-和--的区别

个人总结：单破折号 `-x`：短选项（short option），一般是一个字母，多个字母可合并。双破折号 `--word`：长选项（long option），一般是完整单词，可读性好，多个单词不能合并。比如：递归，-R --recursive

# docker stats 

`docker stats limited-nginx` 会实时显示容器 **limited-nginx** 的资源使用情况，字段如下：

```
CONTAINER ID   NAME           CPU %     MEM USAGE / LIMIT   MEM %     NET I/O         BLOCK I/O   PIDS
a1b2c3d4e5f6   limited-nginx  0.25%     12.5MiB / 50MiB    25.00%    1.2kB / 648B    0B / 0B     5
```

- **CPU %**：占宿主机总 CPU 的百分比  
- **MEM USAGE / LIMIT**：已用内存 / 容器内存限额  
- **MEM %**：内存使用率  
- **NET I/O**：接收 / 发送的网络流量  
- **BLOCK I/O**：磁盘读写量  
- **PIDS**：容器内进程数  

按 `Ctrl+C` 退出。

# dockerfile&docker build

docker build -t my-nginx .   -t表示tag本次的镜像名字为my-nginx，.表示在当前目录下构建镜像（dockerfile以及index.html等需要在本目录下）。

几个dockerfile的案例

```dockerfile
FROM nginx
RUN apt-get update && apt-get install -y curl
COPY index.html /usr/share/nginx/html/
```

```dockerfile
FROM nginx
ENV NGINX_PORT 9000
RUN sed -i "s/listen\s*80;/listen $NGINX_PORT;/g" /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/
```

```dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
```

```shell
#!/bin/bash
# Set a default port if NGINX_PORT is not set
export NGINX_PORT=${NGINX_PORT:-9100}
# Replace the port in the nginx configuration
sed -i "s/listen\s*80;/listen $NGINX_PORT;/g" /etc/nginx/conf.d/default.conf
echo "Starting Nginx on port $NGINX_PORT"
nginx -g 'daemon off;'
```

上面这个案例与dockerfile中设置ENV NGINX_PORT=${NGINX_PORT:-9100}的效果是等价的，即没有传入NGINX_PORT变量时为9100，传入变量是以传入的为准。
