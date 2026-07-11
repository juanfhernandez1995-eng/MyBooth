# MyBooth Router Pairing Guide

MyBooth uses the Android tablet as the client and the gaming laptop as the MyBooth Server.

```text
Android Tablet
→ AX1500 / private booth Wi-Fi
→ Gaming Laptop MyBooth Server
```

## Source of truth

The correct server address is the laptop Wi-Fi IPv4 address shown by `ipconfig`.

Do not assume the Booth Router preset is correct. The router may assign the laptop an address like:

```text
192.168.0.95
10.0.0.68
192.168.8.100
```

Use whatever appears under:

```text
Wireless LAN adapter Wi-Fi
IPv4 Address
```

## Addresses not to use on the tablet

Do not use these on the Android tablet:

```text
127.0.0.1
0.0.0.0
```

`127.0.0.1` means the tablet itself.  
`0.0.0.0` is only a server listening address.

## Field test steps

1. Connect the laptop and Android tablet to the same AX1500/private booth Wi-Fi.
2. Start the laptop server:

```powershell
cd C:\Users\juanf\Documents\MyBooth\server
py -m mybooth_server
```

3. Run `ipconfig` on the laptop.
4. Copy the Wi-Fi IPv4 address.
5. On the tablet, test:

```text
http://LAPTOP-IP:8080/health
```

6. In MyBooth, open Server Pairing.
7. Enter `LAPTOP-IP` and port `8080`.
8. Tap Pair with Server.

## Last successful address

v0.21 saves the last server address that passed a real `/health` and `/status` handshake. Use **Last Successful Server Address** if the router has not changed the laptop IP.

## Troubleshooting

If the tablet cannot reach the laptop:

- confirm both devices are on the same Wi-Fi
- allow Python through Windows Firewall on private networks
- allow port `8080`
- allow port `5000` if testing Flutter Web from the tablet
- disable AP/client/guest isolation on the router
- make sure the tablet is not on guest Wi-Fi
