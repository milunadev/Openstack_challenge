
```bash
ssh -p 3822 challenger-18@201.217.240.69 -i challenger-18 -L 127.0.0.1:8080:10.100.1.31:80
```


### CONEXION A INSTANCIAS INTERNAS


```bash
sudo ip addr add 192.168.10.232/24 dev ens9

sudo ip link set dev ens9 up
```

