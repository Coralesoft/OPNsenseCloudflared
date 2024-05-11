# Cloudflared Build and Install for OPNsense & FreeBSD

Script will:<br>
- Create the build environment<br>
- Pull the latest cloudflared source from GitHub<br>
- Build the cloudflared binary<br>
- Install the cloudflared binary for use<br>
- Remove the build and source environments<br>
- To update/upgrade the cloudflared binary, just re-run the script

## To Install

1. Download the installation script using `wget`:
    ```bash
    wget https://raw.githubusercontent.com/Coralesoft/OPNsenseCloudflared/main/cloudflared-opnsense-freebsd-build-install.sh
    ```

2. Make the script executable:
    ```bash
    chmod +x cloudflared-opnsense-freebsd-build-install.sh
    ```

3. Run the script:
    ```bash
    ./cloudflared-opnsense-freebsd-build-install.sh
    ```

4. Test cloudflared is working, type clouldflared version or clouldflared help and check the output:
    ```bash
    cloudflared help
    ```
