## MODULO DE INFRAESTRUCTURA OPENSTACK
Este módulo Terraform despliega una infraestructura completa de Puppet en OpenStack, que incluye Puppet Server, Puppet Agents y Puppet DB. También proporciona la opción de desplegar una instancia pública para la gestión y administración.

### Estructura de modulo: 
El archivo main.tf es el núcleo de la configuración y contiene la definición de los diferentes módulos y recursos necesarios para desplegar la infraestructura.

#### ESTRUCTURA DEL MODULO AGENTE
Estos son los recursos que se despliegan como parte del agente Puppet:

1. Volumenes de almacenamiento

```bash
resource "openstack_blockstorage_volume_v3" "boot_volume_agents" {
  count = var.puppet_agent_parameters["count"]
  name = "${var.project_name}-agent-boot-volume-${count.index}"
  size = var.puppet_agent_parameters["volume_size"]
  image_id = data.openstack_images_image_v2.puppet_instance_image.id
  volume_type = "__DEFAULT__"
}
```
2. Instancias de Puppet Agent
- count: Número de instancias a crear, determinado por puppet_agent_parameters["count"].
- name: Nombre de la instancia.
- flavor_name: Nombre del sabor (tamaño) de la instancia.
- key_pair: Nombre del par de claves para acceder a la instancia.
- security_groups: Grupo de seguridad asignado a la instancia.
- network: Red privada a la que se conecta la instancia.
- block_device: Configuración del dispositivo de bloque (volumen de almacenamiento).
    - uuid: ID del volumen.
    - source_type: Tipo de fuente (volumen).
    - boot_index: Índice de arranque (0).
    - destination_type: Tipo de destino (volumen).
    - delete_on_termination: Eliminar al terminar (true).

```bash

resource "openstack_compute_instance_v2" "puppet_agents" {
  count = var.puppet_agent_parameters["count"]
  name = "${var.project_name}-puppet-agent-${count.index}"
  flavor_name = var.puppet_agent_parameters["flavor_name"]
  key_pair = openstack_compute_keypair_v2.puppet_agent_key.name

  security_groups = [openstack_networking_secgroup_v2.puppet-agent-sg.name]

  network {
    name = var.private_network_1_name
  }

  block_device {
    uuid = openstack_blockstorage_volume_v3.boot_volume_agents[count.index].id
    source_type = "volume"
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }

  depends_on = [
    openstack_blockstorage_volume_v3.boot_volume_agents,
    openstack_networking_secgroup_v2.puppet-agent-sg,
    openstack_compute_keypair_v2.puppet_agent_key
  ]
}
```

 3. Generamos una llave SSH para el agente, esta llave luego sera exportada, mediante un recurso local_file, a la instancia publica la que usará para aprovisionar el playbook de Ansible al agente.
 ```bash
    resource "tls_private_key" "agent_key" {
        algorithm = "RSA"
        rsa_bits = 4096    
    }
    resource "openstack_compute_keypair_v2" "puppet_agent_key" {
        name = "puppet-agent-key"
        public_key = tls_private_key.agent_key.public_key_openssh
        depends_on = [tls_private_key.agent_key]
    }
 ```


 4. Grupo y reglas de seguridad
    ```bash
    resource "openstack_networking_secgroup_v2" "puppet-agent-sg" {
    name = "puppet-agent-sg"
    description = "Security group for Puppet Agent"
    }
    ```
    - Permitimos el puerto 8140 en la red local, para permitir comunicacion entre el puppet server y puppet agent.
    - Permitimos trafico ICMP en la red local interna.
    - Permitimos el trafico SSH en la red local interna.

