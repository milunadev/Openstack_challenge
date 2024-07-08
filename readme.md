
## REQUISITOS
1. Clonamos el repositorio
Este modulo de Terraform debe ejecutarse en una maquina que tenga acceso a la API de Openstack y este autenticado con el ambiente de Openstack, ya que se ejecutan algunos comandos del CLI.

Tambien es necesario exportar las variables de configuracion del provider Openstack que usamos para desplegar infraestructura con Terraform.
Esto lo hacemos mediante un script que nos pedira las credenciales:
```bash
git clone https://github.com/milunadev/Openstack_challenge
cd Openstack_challenge
chmod +x ./utilities/export_tfvars.sh
./utilities/export_tfvars.sh
```
Una vez seteadas las variables generales, exportamos tambien la variable password


```bash
ssh -p 3822 challenger-18@201.217.240.69 -i challenger-18 -L 127.0.0.1:8080:10.100.1.31:80
```

### BUGS ACTUALES
Para el momento de presentacion del reto, la arquitectura propuesta era la siguiente.
1. Una instancia publica, que funcionaria de bastion host.
2. Infraestructura puppet (agente,servidor,db) en una red privada. Unicamente accesible por el bastion host.

La instancia publica se creaba en la red publica y se agregaba una interface de red secundaria que permitia conectarse a la red privada donde se encontraba la infraestructura puppet.
![alt text](image.png)
![](image-1.png)


### CONEXION A INSTANCIAS INTERNAS


```bash
sudo ip addr add 192.168.10.232/24 dev ens9

sudo ip link set dev ens9 up
```

```bash
python3 -m venv tfvenv
source tfvenv/bin/activate
pip3 install tftest
pip3 install pytest

```
