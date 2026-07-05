# MyBooth Router Field Test Guide

This guide prepares the real booth-network test for MyBooth.

## Target architecture

```text
Android Tablet
  -> Private Wi-Fi Router
  -> Gaming Laptop running MyBooth Server
```

## Laptop setup

1. Connect the gaming laptop to the private booth router Wi-Fi.
2. Open PowerShell.
3. Start the server:

```powershell
cd C:\Users\juanf\party_booth\server
py -m mybooth_server
```

4. Keep that PowerShell window open.

## Find the laptop IP

Open another PowerShell window and run:

```powershell
ipconfig
```

Look for:

```text
Wireless LAN adapter Wi-Fi
IPv4 Address . . . . . . . . . . : 192.168.x.x
```

Use that IPv4 address in MyBooth Server Pairing with port `8080`.

## Tablet test

1. Connect the Android tablet to the same private booth Wi-Fi.
2. Open the MyBooth client.
3. Open Server Pairing.
4. Enter the laptop IPv4 address.
5. Keep port set to `8080`.
6. Tap Pair with Server.

## Browser endpoint checks

From the tablet browser, test:

```text
http://<LAPTOP-IP>:8080/health
http://<LAPTOP-IP>:8080/status
http://<LAPTOP-IP>:8080/modules
```

Each endpoint should show JSON text.

## Firewall troubleshooting

If the laptop can open `/health` but the tablet cannot:

1. Confirm both devices are on the same Wi-Fi.
2. Confirm the tablet is using the laptop IPv4 address, not `127.0.0.1`.
3. Allow Python through Windows Defender Firewall.
4. Restart the server.
5. Test `/health` again from the tablet.

## Field test success criteria

- Laptop server starts without errors.
- Tablet can open `/health` in the browser.
- MyBooth Server Pairing reports a connected state.
- Dashboard Server Pairing card shows the server metadata.
- Theme Gallery and Event Flow still work.
