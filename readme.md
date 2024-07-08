
# REQUISITOS
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
export TF_VAR_os_password='**************'
```


### 🐞🐞 BUGS ACTUALES 😔
Para el momento de presentacion del reto, la arquitectura propuesta era la siguiente.
1. Una instancia publica, que funcionaria de bastion host.
2. Infraestructura puppet (agente,servidor,db) en una red privada. Unicamente accesible por el bastion host.

La instancia publica se creaba en la red publica y se agregaba una interface de red secundaria que permitia conectarse a la red privada donde se encontraba la infraestructura puppet y asi aprovisionar las intancias mediante los playbook de Ansible.
![alt text](image.png)
![](image-1.png)

Sin embargo, a lo largo del reto, apenas culminaba el despliegue de infraestructura, la conectividad hacia la instancia publica a traves de su IP publica era inconsistente, con una considerable perdida de paquetes.

![alt text](<Captura de pantalla 2024-07-08 a la(s) 5.49.14 p. m..png>)

Hasta esta presentacion la unica manera de restablecer una conectividad al 100% es reiniciando la instancia ya sea por CLI o por GUI. Es por ello que en el modulo de terraform se incluye un null resource que reinicia la instancia mediante el CLI.

```bash
resource "null_resource" "reboot_public_instance" {
  provisioner "local-exec" {
    command = <<-EOT
      sleep 45
      openstack server reboot ${openstack_compute_instance_v2.public_instance.id}
      sleep 45
    EOT
  }

  depends_on = [openstack_compute_instance_v2.public_instance]
}
```
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
