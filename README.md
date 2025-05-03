**📦 Windows rodando pelo Docker no Umbrel com/sem HD secundario!**

> **Instalar Windows no Umbrela** em um container Docker!

---

## 🚀 Pré-requisitos

* **Sistema**: Umbrel OS (base Debian)
* **Permissões**: Acesso `sudo`

---

## 🛠️ Usar o Windows + todo docker no hd secundario (Se não for usar o docker e o windows em um hd secudario pule esta etapa)

1. **Crie o diretório** no HDD secundário:

   ```bash
   sudo mkdir -p /mnt/hd/docker-data
   ```

2. **Edite o daemon do Docker**:

   ```bash
   sudo nano /etc/docker/daemon.json
   ```

3. **Adicione** o bloco abaixo ao `daemon.json`:

   ```json
   {
     "data-root": "/mnt/hd/docker-data"
   }
   ```

4. **Reinicie o Docker**:

   ```bash
   sudo systemctl restart docker
   ```

---

## 🖥️ Instalando a VM Windows

1. **Crie a pasta do projeto**:

   ```bash
   mkdir ~/windows-docker
   cd ~/windows-docker
   ```

2. **Crie o arquivo** `docker-compose.yml`:

   ```bash
   nano docker-compose.yml
   ```

3. **Cole o conteúdo** abaixo e ajuste as variáveis entre `{}`:

   ```yaml
   version: '3.7'

   services:
     windows:
       image: dockurr/windows
       container_name: windows-vm
       environment:
         # Versão do Windows: 11, 11e, 11l, 10, 10e, 10l, 8e, 7u
         VERSION: "{WINDOWS_VERSION}"
         # RAM em MB
         RAM_SIZE: "{RAM_MB}"
         # Número de núcleos de CPU
         CPU_CORES: "{CORES}"
         # Tamanho do disco em GB
         DISK_SIZE: "{DISK_SIZE_GB}GB"
       devices:
         - /dev/kvm        # Aceleração de virtualização
         - /dev/net/tun    # Túnel de rede
       cap_add:
         - NET_ADMIN
       ports:
         - "8006:8006"         # Painel de gerenciamento
         - "3389:3389/tcp"     # RDP TCP
         - "3389:3389/udp"     # RDP UDP
       volumes:
         - ./windows:/storage/shared/  # Compartilha arquivos com VM
         - ./vm-data:/storage/data/    # Disco virtual da VM
       restart: always
       stop_grace_period: 2m
   ```

4. **Instale/Atualize o Docker** (caso necessário):

   ```bash
   sudo apt-get remove -y docker docker-engine docker.io containerd runc
   sudo apt-get update
   sudo apt-get install -y docker.io docker-compose
   sudo systemctl enable --now docker.service containerd.service
   ```

5. **Suba o container**:

   ```bash
   sudo docker-compose up -d
   ```

6. **🎉 Acesse!**

   * Painel: `http://<SEU_IP>:8006`
   * Conexão RDP: `mstsc /v:<SEU_IP>` (porta 3389)

---

## 💡 Dicas & Troubleshooting

* **Verifique dispositivos**:

  ```bash
  lsmod | grep kvm
  ls /dev/net/tun
  ```
* **Logs do container**:

  ```bash
  sudo docker logs -f windows-vm
  ```
* **Reiniciar container**:

  ```bash
  sudo docker-compose restart windows-vm
  ```

---

😊 **Boas VMs!** Se encontrar problemas, abra uma issue ou PR. Obrigado por usar!
