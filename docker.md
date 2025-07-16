# layers

Docker 镜像由一系列 **只读层（layers）** 组成，每一层代表一次文件系统变更（如安装软件包、复制文件、修改配置等）。这些层通过 **Union File System（联合文件系统）** 叠加成最终的容器文件系统。理解 layers 是优化镜像大小、构建速度和缓存效率的关键。



### **1. 层的本质**
- **只读层**：镜像中的每一层都是只读的，无法直接修改。
- **可写层（容器层）**：当容器运行时，Docker 会在镜像顶部添加一个可写层（称为 **container layer**），所有运行时修改（如文件写入、删除）都发生在这里，不会影响镜像本身。



### **2. 层的来源**
- **Dockerfile 指令**：每条 `Dockerfile` 指令（如 `RUN`、`COPY`、`ADD`）都会生成一个新层。
  ```dockerfile
  FROM ubuntu:20.04          # 第一层：基础镜像
  RUN apt-get update         # 第二层：更新包列表
  COPY app.py /app/          # 第三层：复制文件
  CMD ["python", "/app/app.py"] # 第四层：设置默认命令
  ```
- **基础镜像层**：`FROM` 指令指定的镜像本身也是由多层组成的



### **3. 层的特性**
- **唯一性**：每层通过 **SHA256 哈希** 标识，确保内容不可变。
- **共享与复用**：相同层可以被多个镜像共享（节省存储空间）。
- **缓存机制**：如果某层的指令和依赖未变化，Docker 会复用缓存层，加速构建。



### **4. 查看镜像的层**
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



### **5. 优化层的实践**
- **减少层数**：合并多条 `RUN` 指令（使用 `&&` 或 `\`）。
  ```dockerfile
  RUN apt-get update && \
      apt-get install -y curl && \
      rm -rf /var/lib/apt/lists/*
  ```
- **利用缓存**：将频繁变动的指令（如 `COPY`）放在 `Dockerfile` 末尾。
- **多阶段构建**：通过 `FROM ... AS` 减少最终镜像的层数。

# docker search nginx

在dockerhub上寻找和nginx相关的镜像，但是docker search nginx 3.1这样是不行的，不支持搜特定版本

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

# docker run  --name nginx-detached nginx

--name nginx-detached 是为容器起的名字

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

docker run -d --name nginx-with-port -p 8080:80 nginx 将主机的8080映射到容器的80端口

```shell
labex:project/ $ docker port nginx-with-port 
80/tcp -> 0.0.0.0:8080
```



# docker ps -a和docker ps区别

- `docker ps`：只看**正在运行**的容器（running）。
- `docker ps -a`：看**所有状态**的容器（running / exited / created / dead …）

# docker rm和docker stop

docker rm ubuntu-interactive，在执行docker rm后，docker ps -a将不会再列出，但是docker stop 是会列出的

# docker inspect nginx-detached

列出容器详情

# docker logs nginx-detached

docker logs --tail 10 nginx-detached查看nginx-detached的最近10条日志，因为日志是从小网上看的，最下面的最新

docker logs -f nginx-detached，实时跟踪最新的日志

docker logs --timestamps nginx-detached 为日志打时间戳

# docker exec nginx-detached echo "Hello from inside the container"

它用于在 **运行中的容器** 内执行命令。**容器必须处于“正在运行”状态**（`Up ...`）不然报错。

如果交互式写法可以写：docker exec -it nginx-detached /bin/sh，完毕后输入exit退出交互。

在 nginx 容器里列出根目录：docker exec nginx ls /

# 容器与主机间的拷贝

docker cp hello.html nginx-detached:/usr/share/nginx/html/hello.html

docker cp nginx-detached:/etc/nginx/nginx.conf ~/project/nginx.conf

