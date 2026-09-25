    Copyright (C) 2026 Joachim David

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# eid-installer
Two ways to install the Belgian eID Reader for Linux Devices (for Debian/Ubuntu/Linux Mint).

You can install the Belgian eID software of course, using these instructions: 
- [https://eid.belgium.be/nl/eid-software-installeren-en-verwijderen](https://eid.belgium.be/nl/eid-software-installeren-en-verwijderen)

The instructions are not very clear though for new Linux users. I will describe what you should do a little more clearly:

Go to the download button downloading the **.deb** file in this link [https://eid.belgium.be/nl/linux-eid-software-installatie](https://eid.belgium.be/nl/linux-eid-software-installatie)

Open your terminal and enter the following code:

```
sudo apt update
sudo apt install eid-viewer eid-mw
```

This repo though, gives two other ways to install the eID Reader to your computer:
- A traditional script (**install.sh**)
- A visual GUI tool (**visual_install**)

It also offers a way to completely uninstall the eID Reader software:
- **uninstall.sh**

## Executing
You can execute the scripts using the following code:
For the terminal install (works on Debian, Ubuntu, Linux Mint)
```
curl -fsS https://raw.githubusercontent.com/SonoDavid/eid-installer/refs/heads/main/install.sh | sudo bash
```

For the visual install (works on Linux Mint only)
```
curl -fsS https://raw.githubusercontent.com/SonoDavid/eid-installer/refs/heads/main/visual_install.sh | sudo python
```

For uninstall (works on Debian, Ubuntu, Linux Mint)
```
curl -fsS https://raw.githubusercontent.com/SonoDavid/eid-installer/refs/heads/main/uninstall.sh | sudo bash
```

### Test installation
The eID Reader (dutch: eID Kaartlezer) can be found in your start menu or called with the command `eid-reader`.
If you are using Firefox, you need the Firefox addon in order to use the eID Reader online: [https://addons.mozilla.org/nl/firefox/addon/belgium-eid](https://addons.mozilla.org/nl/firefox/addon/belgium-eid)
Test the login procedure here: [https://iamapps.belgium.be/tma/](https://iamapps.belgium.be/tma/)
You can find further help pages here: [https://eid.belgium.be/nl/vraag-en-antwoord](https://eid.belgium.be/nl/vraag-en-antwoord)
