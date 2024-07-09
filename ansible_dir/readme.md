## DIRECTORIO DE ARCHIVOS ANSIBLE
Este proyecto utiliza Ansible para la configuración y aprovisionamiento de la infraestructura de Puppet, incluyendo Puppet Agents, Puppet Server y Puppet DB. A continuación se describe la estructura de los playbooks y roles de Ansible utilizados en el proyecto.

```bash
├── ansible_dir/
│   ├── playbooks/
│   │   ├── request_certificate.yml
│   │   ├── sign_certificate.yml
│   │   ├── verify_puppet.yml
│   ├── roles/
│   │   ├── puppet_agent/
│   │   │   ├── handlers/
│   │   │   │   └── main.yml
│   │   │   ├── tasks/
│   │   │   │   └── main.yml
│   │   │   ├── templates/
│   │   │   │   └── puppet.conf.j2
│   │   ├── puppet_db/
│   │   ├── puppet_server/
│   ├── inventory.tpl
│   ├── site.yml
```

### PLAYBOOK PRINCIPAL
El playbook site.yml define los hosts objetivo y los roles que se deben aplicar a cada uno:

```bash
---
- hosts: puppet_agents
  roles:
    - puppet_agent
  
- hosts: puppet_server
  roles:
    - puppet_server
```

### ESTRUCTURA DE ROLES

#### AGENTE PUPPET

- TASK FILE
    - Download Puppet release package: Descarga el paquete de lanzamiento de Puppet desde una URL específica.
    - Install Puppet release package: Instala el paquete de lanzamiento de Puppet.
    - Update APT cache: Actualiza la caché de APT para asegurarse de que los últimos paquetes estén disponibles.
    - Install Puppet Agent: Instala el agente de Puppet.
    - Ensure Puppet service is enabled and started: Asegura que el servicio de Puppet esté habilitado y en ejecución.
    - Verify entries in /etc/hosts: Verifica y añade entradas en el archivo /etc/hosts para la resolución de nombres.
    - Configure Puppet Agent: Configura el agente de Puppet utilizando una plantilla.
    - Restart Puppet agent: Reinicia el servicio del agente de Puppet para aplicar los cambios.

    ```bash
    ---
    # roles/puppet_agent/tasks/main.yml
    - name: Download Puppet release package
    get_url:
        url: https://apt.puppet.com/puppet7-release-jammy.deb
        dest: /tmp/puppet7-release-jammy.deb
        mode: '0644'

    - name: Install Puppet release package
    command: dpkg -i /tmp/puppet7-release-jammy.deb
    become: yes

    - name: Update APT cache
    apt:
        update_cache: yes
    become: yes

    - name: Install Puppet Agent
    apt:
        name: puppet-agent
        state: present
    become: yes

    - name: Ensure Puppet service is enabled and started
    systemd:
        name: puppet
        enabled: yes
        state: started
    become: yes

    - name: Verify entries in /etc/hosts
    lineinfile:
        path: /etc/hosts
        line: "{{ puppet_server_ip }} {{ puppet_server_hostname }} {{ puppet_server_hostname }}.openstacklocal"
        state: present
    become: yes

    - name: Configure Puppet Agent
    template:
        src: puppet.conf.j2
        dest: /etc/puppetlabs/puppet/puppet.conf
    become: yes

    - name: Restart Puppet agent
    systemd:
        name: puppet
        state: restarted
    become: yes

    ```

- TEMPLATE CONFIG FILE: 

    Esta plantilla se utiliza para configurar el archivo puppet.conf en los Puppet Agents.

    - certname: Define el nombre del certificado, que es el nombre del host en el inventario.
    - server: Define la dirección del servidor Puppet.       
    - environment: Define el entorno en el que opera el agente de Puppet.

    ```bash
        [main]
        certname = {{ inventory_hostname }}
        server = {{ puppet_server_hostname }}.openstacklocal
        environment = production

        [agent]
        certname = {{ inventory_hostname }}
        server = {{ puppet_server_hostname }}.openstacklocal
        environment = production
    ```

### OTROS PLAYBOOKS
1. Este playbook se utiliza para solicitar certificados del CA del servidor Puppet.
- Request certificate from Puppet CA: Solicita un certificado del CA del servidor Puppet.
- Check if certificate request was successful: Verifica si la solicitud de certificado fue exitosa.

```bash
---
- hosts: puppet_agents
  tasks:
    - name: Request certificate from Puppet CA
      command: /opt/puppetlabs/bin/puppet agent --test
      register: puppet_cert_request
      ignore_errors: true
      become: yes

    - name: Check if certificate request was successful
      debug:
        var: puppet_cert_request.stdout

```

2. Este playbook se utiliza para firmar los certificados solicitados por los Puppet Agents.
- List all requested certificates: Lista todos los certificados solicitados.
- Debug certificate list: Muestra la lista de certificados solicitados.
- Sign all requested certificates: Firma todos los certificados solicitados.

```bash
---
- hosts: puppet_server
  tasks:
    - name: List all requested certificates
      command: /opt/puppetlabs/bin/puppetserver ca list --all
      register: cert_list
      become: yes

    - name: Debug certificate list
      debug:
        var: cert_list.stdout

    - name: Sign all requested certificates
      command: /opt/puppetlabs/bin/puppetserver ca sign --all
      become: yes
```
3. verify_puppet.yml: Este playbook se utiliza para verificar que los Puppet Agents y el Puppet Server están funcionando correctamente.

