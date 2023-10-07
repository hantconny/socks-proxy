# socks-proxy
在Docker容器内使用多个Tor进行socks5代理，在对性能没有要求的情况下，也可以当作免费的IP池供爬虫使用，对抗反爬。



### 构建镜像

```shell
$ docker build -t 'hantconny/tor-socks-proxy:v1' .
```



### 启动容器

```shell
$ docker run -d -p 5000:5000/tcp -p 1080:1080/tcp -e tors=25 --name tor-socks-proxy tor-socks-proxy:v1
```

如需在一台机器上启动多个容器，则可以使用如下的命令：

```shell
$ docker run -d -p 5001:5000/tcp -p 1081:1080/tcp -e tors=25 --name tor-socks-proxy-0 tor-socks-proxy:v1
$ docker run -d -p 5001:5000/tcp -p 1081:1080/tcp -e tors=25 --name tor-socks-proxy-1 tor-socks-proxy:v1
...
```



### 端口说明

5000端口用于外部程序连接到容器内的HAProxy进行socks5代理，可以在`files/haproxy.tpl`中进行修改该端口。如在Python3中：

```python
port = 5000
proxy_str = 'socks5://127.0.0.1:{port}'
tor_socks5_proxy = {
    'http': proxy_str.format(port=port),
    'https': proxy_str.format(port=port)
}
resp = get(url=url, headers=headers, proxies=tor_socks5_proxy, verify=False)
```

1080端口用于从页面上监控HAProxy，可以在`files/haproxy.tpl`中进行修改，并通过`http://localhost:1080/admin?stats`进行访问。



### 参数说明

环境变量tors用于配置容器内的Tor实例个数。如果不指定，默认为10个。



### 主机的HTTP代理

在国内需要科学上网才能顺畅的连接到Tor网络。可以在`files/torrc.tpl`中配置HTTPSProxy进行科学上网。



### 注意

并没有办法保证容器内所有的Tor实例均使用不同的出口节点。如果对出口节点的地区有要求，可以在torrc中进行配置。

指定出口节点

```
ExitNodes {eg},{za},{kr},{sg},{au},{hk},{vn},{tw},{jp},{il},{my},{id},{pk},{in},{th},{mn} StrictNodes 1
```

排除出口节点

```
ExcludeExitNodes {us},{de},{lu}
```

出口节点列表

非洲

```
{eg},{za}
```

亚洲

```
{kr},{sg},{au},{hk},{vn},{tw},{jp},{il},{my},{id},{pk},{in},{th},{mn}
```

美洲

```
{us},{ca},{cr},{br},{cl},{ae},{ar},{mx}
```

欧洲

```
{de},{lu},{nl},{at},{se},{ro},{ch},{fr},{gb},{pl},{no},{is},{md},{dk},{fi},{hr},{ua},{lv},{bg},{cz},{hu},{it},{es},{gr},{al},{lt},{ie},{be},{ru}
```

更详细的配置说明可以参考以下链接：

- [wikihow](https://www.wikihow.com/Set-a-Specific-Country-in-a-Tor-Browser#:~:text=Open%20the%20folder%20where%20you,China%2C%20type%20%7BCN%7D)
- [tor-manual](https://2019.www.torproject.org/docs/tor-manual.html.en#ExitNodes)

