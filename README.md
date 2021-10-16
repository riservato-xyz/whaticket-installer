Interactive CLI tool for installing and updating whaticket

### download & setup

Firstly, you need to download it:


```bash
sudo apt -y update && apt -y upgrade
sudo apt install -y git
git clone https://github.com/riservato-xyz/whaticket-installer.git
```

Now, all you gotta do is making it executable:

```bash
sudo chmod +x ./whaticket-installer/whaticket
```

### usage

After downloading and making it executable, you need to **navigate into** the installer directory and **run the script with sudo**:

```bash
cd ./whaticket-installer
```

```bash
sudo ./whaticket
```
