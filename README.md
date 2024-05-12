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

## Support the Project

If this project helps you streamline your OpenWrt setup and you want to support my ongoing work, consider buying me a coffee. Your generous contribution keeps the creativity flowing and helps sustain future development. Thanks for supporting!

<a href="https://www.buymeacoffee.com/r6zt79njh5m" target="_blank"> <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" > </a>
