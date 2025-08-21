# layers

Docker 镜像由一系列 只读层（layers） 组成，每一层代表一次文件系统变更（如安装软件包、复制文件、修改配置等）。这些层通过 Union File System（联合文件系统） 叠加成最终的容器文件系统。理解 layers 是优化镜像大小、构建速度和缓存效率的关键。

层的本质

- 只读层：镜像中的每一层都是只读的，无法直接修改。
- 可写层（容器层）：当容器运行时，Docker 会在镜像顶部添加一个可写层（称为 container layer），所有运行时修改（如文件写入、删除）都发生在这里，不会影响镜像本身。

层的来源

- Dockerfile 指令：每条 `Dockerfile` 指令（如 `RUN`、`COPY`、`ADD`）都会生成一个新层。
  ```dockerfile
  FROM ubuntu:20.04          # 第一层：基础镜像
  RUN apt-get update         # 第二层：更新包列表
  COPY app.py /app/          # 第三层：复制文件
  CMD ["python", "/app/app.py"] # 第四层：设置默认命令
  ```
- 基础镜像层：`FROM` 指令指定的镜像本身也是由多层组成的

**层的特性**

- 唯一性：每层通过 SHA256 哈希 标识，确保内容不可变。
- 共享与复用：相同层可以被多个镜像共享（节省存储空间）。
- 缓存机制：如果某层的指令和依赖未变化，Docker 会复用缓存层，加速构建。

**查看镜像的层**

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

**优化层的实践**

- 减少层数：合并多条 `RUN` 指令（使用 `&&` 或 `\`）。
  ```dockerfile
  RUN apt-get update && \
      apt-get install -y curl && \
      rm -rf /var/lib/apt/lists/*
  ```
  
- 利用缓存：将频繁变动的指令（如 `COPY`）放在 `Dockerfile` 末尾。

- 多阶段构建：通过 `FROM ... AS` 减少最终镜像的层数。

# docker search

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

## docker create

docker create --name web1 nginx 

docker start web1

上面两条命令创建容器后启动等同于docker run --name web1 nginx 

## docker stop

docker stop 容器名

停止一个容器，停止后的容器再启动用docker start。容器在stop后才可以rm，运行时的容器不能直接rm。

# docker run

语法：docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

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

docker run -d --name nginx-with-port -p 8080 nginx ，这样的话表示绑定容器内一个随机端口。

docker run -d --name nginx-with-port -p 8080:80 -p 443:8443 nginx，绑定两个端口。

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

## 防止容器因为主进程退出而自动停止，让容器保持活着，方便调试或挂载 

一般来说，以下类型的镜像可能需要在运行时加上 `sleep infinity`（或类似命令）：
- 基础镜像（如 `busybox`、`alpine`、`ubuntu`、`debian` 等），因为它们没有默认的长时间运行程序
- 构建/调试用镜像（比如你只是想进入容器调试环境）
- 工具类镜像（如 `python`、`node` 等）如果没有指定脚本执行，就会直接退出
- CI/CD 临时环境镜像（需要保持容器活着，等待执行命令）

---

**为什么要加 `sleep infinity`**

- **容器的生命周期** = **主进程的生命周期**  
  如果容器的主进程（PID 1）结束，容器就会退出  
- 许多轻量镜像默认 `CMD` 只是执行一次性命令（比如 `/bin/sh`），执行完就退出  
- 如果你只是想**让容器保持运行状态**（方便进入、调试、挂载等），就需要一个**永不退出的前台进程**  
- `sleep infinity` 就是一个简单的、几乎不占 CPU 的方法，让容器一直运行

---

**示例**

```bash
# 直接运行 busybox 会立刻退出
docker run --rm busybox

# 让 busybox 一直运行
docker run --rm busybox sleep infinity
```

---

**常见替代方法**

- 用 `tail -f /dev/null`
- 在 Dockerfile 里把 `CMD` 改成一个长时间运行的进程
- 用 `docker run -it` 启动交互模式并保持连接

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

# docker exec

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

**dockfile指令**

**基础指令**

| 指令      | 作用                             | 示例                                 |
| --------- | -------------------------------- | ------------------------------------ |
| **FROM**  | 指定基础镜像                     | `FROM ubuntu:20.04`                  |
| **LABEL** | 添加镜像元数据                   | `LABEL maintainer="you@example.com"` |
| **ARG**   | 定义构建时变量（仅构建阶段可用） | `ARG APP_VERSION=1.0`                |
| **ENV**   | 设置环境变量（运行时可用）       | `ENV PATH=$PATH:/usr/local/bin`      |

---

**文件与目录操作**

| 指令        | 作用                                | 示例                       |
| ----------- | ----------------------------------- | -------------------------- |
| **COPY**    | 复制本地文件到镜像                  | `COPY ./app /usr/src/app`  |
| **ADD**     | 复制文件 + 解压 tar + 支持 URL 下载 | `ADD archive.tar.gz /data` |
| **WORKDIR** | 设置工作目录（自动创建）            | `WORKDIR /usr/src/app`     |
| **VOLUME**  | 声明挂载点（数据卷）                | `VOLUME ["/data"]`         |

---

**运行命令**

| 指令           | 作用                                   | 示例                                            |
| -------------- | -------------------------------------- | ----------------------------------------------- |
| **RUN**        | 在构建镜像时执行命令                   | `RUN apt-get update && apt-get install -y curl` |
| **CMD**        | 容器启动时默认执行的命令（可被覆盖）   | `CMD ["node", "server.js"]`                     |
| **ENTRYPOINT** | 容器启动时固定执行的命令（不易被覆盖） | `ENTRYPOINT ["python3"]`                        |
| **SHELL**      | 改变 RUN/ENTRYPOINT/CMD 使用的 shell   | `SHELL ["/bin/bash", "-c"]`                     |

---

**网络与端口**

| 指令       | 作用                             | 示例          |
| ---------- | -------------------------------- | ------------- |
| **EXPOSE** | 声明容器使用的端口（不自动映射） | `EXPOSE 8080` |

---

**构建优化**

| 指令            | 作用                 | 示例                                                  |
| --------------- | -------------------- | ----------------------------------------------------- |
| **USER**        | 指定运行容器的用户   | `USER appuser`                                        |
| **ONBUILD**     | 给基础镜像添加触发器 | `ONBUILD COPY . /app`                                 |
| **STOPSIGNAL**  | 容器停止时发送的信号 | `STOPSIGNAL SIGTERM`                                  |
| **HEALTHCHECK** | 健康检查             | `HEALTHCHECK CMD curl -f http://localhost/ || exit 1` |

---

**一个综合示例**

```dockerfile
# 基础镜像
FROM ubuntu:20.04

# 构建参数
ARG APP_VERSION=1.0

# 元数据
LABEL maintainer="you@example.com" \
      version="$APP_VERSION"

# 环境变量
ENV APP_HOME=/app \
    LANG=C.UTF-8

# 工作目录
WORKDIR $APP_HOME

# 拷贝文件
COPY ./src ./src

# 安装依赖
RUN apt-get update && apt-get install -y python3 python3-pip && \
    pip3 install flask && \
    rm -rf /var/lib/apt/lists/*

# 暴露端口
EXPOSE 5000

# 声明挂载点
VOLUME ["/app/data"]

# 健康检查
HEALTHCHECK CMD curl -f http://localhost:5000/ || exit 1

# 启动命令
ENTRYPOINT ["python3", "src/app.py"]
```

---

 **记忆建议**  
- **FROM → LABEL/ARG/ENV → WORKDIR → COPY/ADD → RUN → EXPOSE/VOLUME → HEALTHCHECK → ENTRYPOINT/CMD**  
- 这个顺序符合 Docker 构建层的执行逻辑，可以减少缓存失效，提高构建效率  



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

# docker network

## docker network ls

```
labex:project/ $ docker network ls  
NETWORK ID     NAME      DRIVER    SCOPE
1e4078d553e7   bridge    bridge    local
91199fc6ad2e   host      host      local
1078d2c781b6   none      null      local
```

列出所有docker建立的网络

**bridge 模式**：这是 Docker 的默认网络模式。每当你启动一个容器时，若没有特别指定网络，容器就会连接到 bridge 网络。容器通过虚拟网桥与主机和其他容器通信。容器之间通过 IP 地址互通，和主机之间可以端口映射。适合大多数常见的单机应用场景。

**host 模式**：容器与宿主机共享网络命名空间，不会有独立的网络隔离。容器直接使用宿主机的网络（如 IP、端口）。没有端口映射，容器内服务直接暴露在主机网络上。网络性能最好，但缺乏隔离性，适合对性能要求极高的场景。

**none 模式**：容器没有网络功能，只有回环接口（lo）。容器之间、容器与主机之间都无法通信。适合需要自定义网络的场景，由用户手动配置网络。

**SCOPE（作用范围）**

**local**：表示该网络**仅限于当前 Docker 主机**，不支持多主机网络互通。

**global**：用于 Swarm 集群模式下，网络可跨多主机。global 网络一般指的是 Docker Swarm 集群中的 Overlay 网络，这种网络可以让不同物理主机上的容器实现互通。在 `docker network ls` 命令中，如果 SCOPE 显示为 `global`，表示这个网络是集群范围的，可以跨多台主机。

## docker network inspect bridge

显示桥接网络的详细信息，包含：子网、网关、bridge中连接的容器

## docker network create --driver bridge my-network

与docker network create my-network是一致的，新建一个名为my-network的容器网络

## 将两个容器加入同一个网络

```shell
docker network create --driver bridge my-network //新建网络
docker run -d --name container1 --network my-network nginx  //跑容器时加入网络
docker run -d --name container2 --network my-network nginx
docker exec container1 curl -s container2 //同一网络下的可以通过容器名访问
```

**同一个网络下的容器可以互相通过容器名访问**，docker内置了DNS服务来将容器名和IP做对应。

## docker network connect

将container2加入my-second-bridge网络

```
docker network connect my-second-bridge container2
```

一个容器可以加入多个网络。当前网络1中有容器1和容器2，网络2中有容器2和3，那么容器1和2可以通信，容器2和3可以通信，容器和3不能通信。

##  docker network disconnect

将container2解绑my-network网络

 docker network disconnect my-network container2

## docker network rm

docker network rm my-network2

删除网络

## docker inspect

docker inspect network2

列出network2的详情，包含network2中包含的容器。

## 服务发现与负载均衡

服务发现的作用：在微服务或容器化环境中，服务实例（如 web 服务、数据库等）经常会变动（扩容、缩容、重启、迁移）。服务发现的目标就是让其他服务能够自动找到这些实例的最新地址，而不用手动维护 IP 或端口。

network-alias 如何帮助服务发现

- 通过 `--network-alias myservice`，你可以给一个或多个容器分配同一个服务名（比如 myservice）。
- 在同一 Docker 网络内，任何容器都可以通过这个别名（myservice）访问这些服务实例。
- 当你用 `nslookup myservice` 查询时，会返回所有拥有这个别名的容器 IP。

这样，无论服务实例怎么变化，别名始终不变，其他服务只需记住别名即可，极大简化了服务间的通信和发现。

```
docker run -d --network service-network --network-alias myservice --name service1 nginx
docker run -d --network service-network --network-alias myservice --name service2 nginx
docker run --rm --network service-network appropriate/curl nslookup myservice
```

第一步：启动 service1 容器

```
docker run -d --network service-network --network-alias myservice --name service1 nginx
```

- **-d**：后台运行
- **--network service-network**：加入 `service-network` 网络
- **--network-alias myservice**：给容器起一个网络别名 `myservice`
- **--name service1**：容器名为 `service1`
- **nginx**：使用 nginx 镜像

------

第二步：启动 service2 容器

```
docker run -d --network service-network --network-alias myservice --name service2 nginx
```

- 参数同上，唯一不同的是容器名为 **service2**，但同样的网络别名 **myservice**

------

第三步：查询 myservice 的 DNS 解析

```
docker run --rm --network service-network appropriate/curl nslookup myservice
```

- 启动一个临时容器，加入同一个网络
- 在这个网络内执行 `nslookup myservice`

你给了两个容器同一个 network-alias（myservice），那么 DNS 查询会返回什么？

- Docker 的网络别名机制支持多个容器共享同一个别名。**只有在同一个网络（network）内的容器**，**才能通过别名互相访问。如果容器分别属于不同的网络，即使别名相同，也无法通过别名互通。**
- 当你在网络内用 `nslookup myservice` 查询时，会返回所有拥有该别名的容器的 IP 地址。

假设 service1 的 IP 是 172.20.0.2，service2 的 IP 是 172.20.0.3，那么结果可能是：

```
复制代码Server:    127.0.0.11
Address 1: 127.0.0.11

Name:      myservice
Address 1: 172.20.0.2
Address 2: 172.20.0.3
```

# docker volume 

## docker存储数据三种方式

1. 卷（Volumes）
   - 特点：由 Docker 管理，存储在宿主机文件系统的特定位置（如 `/var/lib/docker/volumes/`）。
   - 优点：与容器解耦，可在多个容器间共享，数据持久化效果好。
   - 适用场景：数据库、需要长期保存的数据。
2. 绑定挂载（Bind Mounts）
   - 特点：将宿主机的指定目录或文件直接挂载到容器中。
   - 优点：容器可以直接访问和修改宿主机上的文件，适合开发调试。
   - 适用场景：代码热更新、本地文件共享。
3. tmpfs 挂载（tmpfs Mounts）
   - 特点：数据存储在宿主机内存中，容器停止后数据会丢失。
   - 优点：速度快，适合存放敏感或临时数据。
   - 适用场景：缓存、临时文件存储。

## ls/creat/inspect/run

docker volume ls

docker volume create my_data

docker volume inspect my_data，输出大致如下，其中Mountpoint是主机的挂载点

```
[
    {
        "CreatedAt": "2025-08-12T13:34:07+08:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my_data/_data",
        "Name": "my_data",
        "Options": {},
        "Scope": "local"
    }
]
```

docker run -d --name my_container -v my_data:/app/data ubuntu:latest sleep infinity，把my_data卷挂载到容器内的/spp/data路径下。

## 绑定同一个volume的两个容器可共享数据

例子如下：

```shell
labex:project/ $ docker volume create my_data
my_data
labex:project/ $ docker run -d --name my_container -v my_data:/app/data ubuntu:latest sleep infinity
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
32f112e3802c: Pull complete 
Digest: sha256:a08e551cb33850e4740772b38217fc1796a66da2506d312abe51acda354ff061
Status: Downloaded newer image for ubuntu:latest
2ef15a904fdbb887dad18fb4a691b8a633d83105b8ca808f94b27a73372b971d
labex:project/ $ docker exec my_container sh -c "echo 'Hello from Docker volume' > /app/data/test.txt"
labex:project/ $ docker exec my_container cat /app/data/test.txt
Hello from Docker volume
labex:project/ $ docker run -d --name another_container -v my_data:/app/shared_data ubuntu:latest sleep infinity
fde3adef4977d19b8deb96afada4f4b1ffac36bf9f9cd5bb5aba52f8976bb322
labex:project/ $ docker exec another_container cat /app/shared_data/test.txt 
Hello from Docker volume
```

## 挂载另一个容器的volume

docker run -d --name busybox-share --volumes-from nginx-share busybox sh -c "tail -f /dev/null"

启动一个名为 `busybox-share` 的 BusyBox 容器，并且挂载另一个容器 `nginx-share` 的数据卷，从而实现容器之间共享数据。

## volume备份和恢复

```shell
# Backup the volume
docker run --rm -v myvolume:/source -v /home/labex/project:/backup alpine tar czf /backup/myvolume.tar.gz -C /source .

# Create a new volume
docker volume create mynewvolume

# Restore the backup to the new volume
docker run --rm -v mynewvolume:/target -v /home/labex/project:/backup alpine sh -c "tar xzf /backup/myvolume.tar.gz -C /target"

# Verify the restore
docker run --rm -v mynewvolume:/app/data alpine cat /app/data/hello.txt
```



# docker-compose

一个用于定义和管理多容器 Docker 应用的工具，用一个 `docker-compose.yml` 文件描述整个应用的服务，一键启动和停止多个容器，方便做本地开发和测试。以下是一个docker-compose.yml文件样例，包含Jenkins和mysql服务。

```
version: '3.8'
services:
  jenkins:
    image: jenkins/jenkins:lts
    ports:
      - "8080:8080"
      - "50000:50000"
    environment:
      - JENKINS_HOME=/var/jenkins_home
    volumes:
      - jenkins_home:/var/jenkins_home

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=123456
      - MYSQL_DATABASE=jenkins_data
    volumes:
      - db_data:/var/lib/mysql

volumes:
  jenkins_home:
  db_data:

```

Docker Compose 和 Jenkins 在实际工作中是很常见的组合，尤其是在开发、测试和持续集成（CI/CD） 场景里。因为：

1. 快速搭建测试环境
   - Jenkins 在执行构建任务时，可以调用 `docker compose up` 启动一整套依赖服务（数据库、缓存、消息队列等）。
   - 测试完成后再用 `docker compose down` 清理环境，保证每次构建都是干净的。
2. 本地与流水线环境一致
   - 开发人员本地用 Docker Compose 搭建的环境，可以原封不动地在 Jenkins 流水线中运行，减少“在我机器上没问题”的情况。
3. 方便管理多容器服务
   - Jenkins 任务里可能需要多个容器同时运行，例如：
     - 应用容器
     - 数据库容器
     - 模拟外部 API 的容器
   - Compose 可以一键启动这些容器，并通过网络互通。
4. 简化 CI/CD 配置
   - 不需要在 Jenkins 节点上手动安装各种依赖，只需拉取镜像并用 Compose 编排即可。

大企业在生产部署时，更倾向于使用 Kubernetes、Docker Swarm、OpenShift 等编排工具，因为这些工具更适合大规模、分布式、高可用的环境。

## 常用命令

**1. 启动和停止服务**

| 命令                         | 作用                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| **`docker compose up`**      | 启动并运行 `docker-compose.yml` 中定义的所有服务（前台模式）。 |
| **`docker compose up -d`**   | 以**后台模式**启动所有服务。                                 |
| **`docker compose down`**    | 停止并删除所有由当前 Compose 项目创建的容器、网络、卷。      |
| **`docker compose stop`**    | 停止容器但不删除。                                           |
| **`docker compose start`**   | 启动已存在但停止的容器。                                     |
| **`docker compose restart`** | 重启服务。                                                   |

---

**2. 构建与更新**

| 命令                                  | 作用                                       |
| ------------------------------------- | ------------------------------------------ |
| **`docker compose build`**            | 按 `docker-compose.yml` 中的配置构建镜像。 |
| **`docker compose build --no-cache`** | 不使用缓存，强制重新构建。                 |
| **`docker compose pull`**             | 拉取服务所需的镜像。                       |
| **`docker compose push`**             | 推送服务镜像到镜像仓库。                   |

---

**3. 查看状态与日志**

| 命令                         | 作用                             |
| ---------------------------- | -------------------------------- |
| **`docker compose ps`**      | 查看当前项目的容器状态。         |
| **`docker compose logs`**    | 查看所有服务的日志。             |
| **`docker compose logs -f`** | 持续跟踪日志（类似 `tail -f`）。 |

---

**4. 运行和执行命令**

| 命令                                      | 作用                                               |
| ----------------------------------------- | -------------------------------------------------- |
| **`docker compose exec <服务名> <命令>`** | 进入正在运行的容器执行命令（类似 `docker exec`）。 |
| **`docker compose run <服务名> <命令>`**  | 启动一个新的容器执行命令（不会影响已运行的容器）。 |

---

**5. 其他常用命令**

| 命令                         | 作用                                              |
| ---------------------------- | ------------------------------------------------- |
| **`docker compose config`**  | 检查并显示合并后的配置（可验证 `yml` 是否正确）。 |
| **`docker compose top`**     | 查看容器内运行的进程。                            |
| **`docker compose version`** | 查看 Docker Compose 版本。                        |

# **Docker Registry**

`registry` 是 Docker 官方提供的一个镜像仓库服务程序（Docker Registry 服务）。当你运行它时，就可以在本地或服务器上搭建一个私有镜像库。

以下是一个公司私有 Docker 镜像仓库的搭建方案，用最常见的官方 Docker Registry方式来实现，方便部署和维护。  

---

**1. 前置条件**

- 已安装 **Docker**（服务器端和客户端都需要）。
- 一台公司内网可访问的服务器（建议固定 IP 或域名）。
- 服务器上开放一个端口（默认 5000）。

---

**2. 搭建步骤**

**拉取官方 Registry 镜像**

```bash
docker pull registry:2
```
> `:2` 表示使用 **Registry v2** 版本，这是目前主流版本。

---

**启动 Registry 服务**

```bash
docker run -d \
  -p 5000:5000 \
  --name company-registry \
  --restart=always \
  -v /opt/registry/data:/var/lib/registry \
  registry:2
```
- `-p 5000:5000`：将容器 5000 端口映射到宿主机 5000 端口。  
- `-v /opt/registry/data:/var/lib/registry`：持久化镜像数据到宿主机 `/opt/registry/data`。  
- `--restart=always`：容器异常退出会自动重启。

---

**访问测试**

在浏览器或命令行访问：
```
http://<服务器IP>:5000/v2/_catalog
```
如果返回：
```json
{"repositories":[]}
```
说明 Registry 搭建成功。

---

**配置客户端信任（非 HTTPS 环境）**

如果你暂时不使用 HTTPS，需要让客户端信任这个私有仓库：
1. 在客户端机器上编辑 `/etc/docker/daemon.json`：
```json
{
  "insecure-registries": ["<服务器IP>:5000"]
}
```
2. 重启 Docker 服务：
```bash
systemctl restart docker
```

---

**推送镜像到私有仓库**

```bash
# 给本地镜像打上私有仓库标签
docker tag hello-world <服务器IP>:5000/hello-world:v1

# 推送到私有仓库
docker push <服务器IP>:5000/hello-world:v1
```

---

**从私有仓库拉取镜像**

```bash
docker pull <服务器IP>:5000/hello-world:v1
```

---

# docker create

docker create nginx

创建一个容器但不启动它，创建时可以加-v，-p，--name，-e TEST-ENV=test-balue等参数。创建后再启动用docker start nginx。

# docker search

在docker hub上搜索image

docker search alpine

docker search --filter "is-official=true" alpine

# docker swarm cluster

## 基础知识

**Docker Swarm** 是 Docker 官方提供的**原生集群管理工具**，用来将多台 Docker 主机组合成一个**虚拟集群**，统一管理和调度容器。

```
             ┌───────────────────────┐
             │     Manager Node       │
             │  - 集群管理 / 调度任务  │
             │  - 维护集群状态        │
             └─────────┬─────────────┘
                       │
      ┌────────────────┼────────────────┐
      │                │                │
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│ Worker Node │  │ Worker Node │  │ Worker Node │
│ 运行容器任务 │  │ 运行容器任务 │  │ 运行容器任务 │
│ (Task)      │  │ (Task)      │  │ (Task)      │
└─────────────┘  └─────────────┘  └─────────────┘


```

**Manager Node**

- 负责接收用户命令（如 `docker service create`）
- 负责任务调度，把容器分配到不同 Worker 节点
- 维护整个集群的状态（谁在运行什么容器）

**Worker Node**

- 只负责执行任务，不参与调度
- 运行的容器称为 **Task**
- 如果某个节点宕机，Manager 会自动将 Task 迁移到其他节点

**service**

- 表示一个应用服务，可以包含多个 Task（容器实例）
- Swarm 会自动进行负载均衡和服务发现

**工作原理**

1. 你在 **Manager 节点** 上创建一个 **Service**
2. Manager 会根据定义的副本数，把任务分配到不同的 Worker 节点
3. 如果某个节点宕机，Swarm 会自动在其他节点重新启动容器，保证服务可用

Docker Swarm 是docker官方提供的一种技术/模式、Docker Swarm Cluster 是用这种技术搭建出来的实际集群，由于现在实际业务多使用kubernetes，同时kubernetes也是事实上的行业标准。

## 命令

docker swarm init 初始化一个docker集群

docker node ls 列出已有的集群

# docker cp

docker cp可以把本地的文件拷贝到正在运行的容器中。也可以反过来把正在运行中的容器中的内容烤到本地。

docker cp index.html nginx:/usr/share/nginx/html/  把本地的 `index.html` 文件复制到正在运行的 `nginx` 容器的 `/usr/share/nginx/html/` 目录下
