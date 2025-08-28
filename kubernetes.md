# 常见概念

1. Cluster（集群）
一句话：整个 K8s 的“地盘”，由若干台机器（Node）+ 控制平面组成。  
类比：一座数据中心。

2. Node（节点）
一句话：真正跑容器的物理机或虚拟机，分两种角色：  
• Master（控制大脑）  
• Worker（搬砖苦力）

3. Pod（豆荚）
一句话：K8s 最小调度单位；一个 Pod 里可以放 1 个或多个紧耦合容器，共享网络/存储。  
场景：90 % 情况下“一个 Pod 一个业务容器 + 一个 sidecar 辅助容器”。

4. Container（容器）
一句话：Docker 或 CRI-O 启动的进程，只是 Pod 里的“住户”。

5. Deployment（无状态部署）
一句话：声明“我要 N 个相同 Pod”，自动维持副本数、滚动升级。  
场景：Web / API / 纯计算任务。

6. StatefulSet（有状态部署）
一句话：Deployment 的“有序 + 稳定身份 + 稳定存储”版本，适合 MySQL、Kafka。  
特点：Pod 名固定（mysql-0、mysql-1…），PVC 跟着序号走。

7. DaemonSet（守护进程集）
一句话：每个 Node 上跑且只跑 1 个 Pod，常用于日志收集、监控 agent。  
场景：Fluentd、node-exporter。

8. Job / CronJob
一句话：一次性任务 / 定时任务。  
场景：每日凌晨跑数据清洗脚本。

9. Service（服务）
一句话：给一组 Pod 提供“稳定的虚拟 IP + 负载均衡”，解决 Pod IP 随时变的问题。  
类型：  
• ClusterIP（集群内部）  
• NodePort（对外端口）  
• LoadBalancer（云负载均衡）  
• ExternalName（DNS 别名）

10. Ingress（入口）
一句话：7 层路由网关，按域名/路径把流量转发到不同 Service。  
场景：一个公网 IP 挂多个网站。

11. ConfigMap / Secret
一句话：把“配置 / 敏感数据”挂进 Pod，解耦镜像与环境。  
区别：Secret 会做 base64 模糊化 + 可选加密存储。

12. Volume（卷）
一句话：Pod 里共享或持久化的目录，生命周期可长可短。  
常见：emptyDir（临时）、hostPath（节点磁盘）、PVC（网络存储）。

13. PVC & PV（存储声明 / 存储卷）
一句话：用户只写“我需要 20 Gi 读写一次”，集群自动绑定实际存储（PV）。  
场景：云盘、NFS、Ceph。

14. Namespace（命名空间）
一句话：逻辑隔离的“虚拟集群”，用于多团队/多环境。  
场景：dev / test / prod 三套环境用同一套物理集群。

15. Label & Selector（标签/选择器）
一句话：给任何对象贴“便利贴”，然后用 Selector 快速过滤/关联。  
场景：Service 通过 `app=nginx` 找到所有 nginx Pod。

16. Annotation（注解）
一句话：非查询用的元数据，放工具信息、时间戳、描述等。

17. RBAC（角色权限控制）
一句话：谁（User/ServiceAccount）能对哪些资源做哪些动作。  
场景：只允许 CI 账号更新 Deployment，不能删 Secret。

18. NetworkPolicy（网络策略）
一句话：Pod 间的“防火墙规则”，默认全放行，细粒度后可限制仅同 Namespace 通信。

19. ResourceQuota / LimitRange
一句话：Namespace 级或 Pod 级的“配额 / 上下限”，防止某应用吃光 CPU/内存。

20. CustomResourceDefinition (CRD) + Operator
一句话：把“运维知识”写成代码，扩展 Kubernetes API，自动管理复杂应用。  
场景：Prometheus-Operator、MySQL-Operator。

────────────────
速记口诀  
Pod 是“集装箱”，Deployment/StatefulSet 是“船队”，Service 是“码头登记处”，Ingress 是“海关”，Volume/PVC 是“仓库”，Namespace 是“分区”，Label 是“货签”，CRD 是“自定义码头规则”。
