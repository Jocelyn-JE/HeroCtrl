# My findings on the GoPro HERO3+ Black API

## URL Scheme

All URLs scheme:  <http://10.5.5.9/param1/ACTION?t=PASSWORD&p=%OPTION>

* param1 = That defines if the action will be activated in the **camera** or **bacpac** (back in the HERO2 days the "bacpac" was the separate WiFi unit).
* ACTION = A two character parameter which defines what the camera needs to do. Eg: SH for Shoot
* OPTION: The arguments for ACTION
* If you see a URL which contains "PASSWORD" without the quotes, it
means it needs the camera password, which you can obtain here:  
<http://10.5.5.9/bacpac/sd> using cURL or other HTTP lib using the "GET"
method.

## Hypothesis

It seems calling any invalid endpoint ie: ZZ returns only one `01` byte

## Endpoints discovered

| ACTION | Description / Options                                     | param1 |
|--------|-----------------------------------------------------------|--------|
| sd     | Get wifi password                                         | bacpac |
| NO     | Returns `0x00` if no OPTION is given                      | bacpac |
| RS     | Seems to restart the camera's wifi, the bottom blue led flashes | bacpac |
| sx     | Gets the status of the camera, returns 56 bytes           | camera |
| DA     | Delete all videos                                         | camera |
| FO     | Format SD card                                            | camera |
| PI     | Returns `0x00` if no OPTION is given                      | camera |

### Power

* param1: `bacpac`
* ACTION: `PW`

| OPTION | Description |
|--------|-------------|
| 00     | OFF         |
| 01     | ON          |

* param1: `camera`
* ACTION: `PW`

| OPTION | Description |
|--------|-------------|
| 00     | OFF         |

### Volume

* param1: `camera`
* ACTION: `BS`

| OPTION | Description |
|--------|-------------|
| 00     | No sounds   |
| 01     | 70% volume  |
| 02     | 100% volume |

### Resolution

* param1: `camera`
* ACTION: `VV`

| OPTION | Resolution      | Available FPS          |
|--------|-----------------|------------------------|
| 00     | WVGA 240fps     | 240                    |
| 01     | 720p            | 120, 60, 50            |
| 02     | 960p            | 100, 60, 50, 48        |
| 03     | 1080p           | 60, 50, 48, 30, 25, 24 |
| 04     | 1440p           | 48, 30, 25, 24         |
| 05     | 2.7k            | 30, 25                 |
| 06     | 4k              | 15, 12.5               |
| 07     | 2.7k 17:9 24fps | 24                     |
| 08     | 4k 17:9 12fps   | 12                     |
| 09     | 1080p Superview | 48, 30, 25, 24         |
| 0a     | 720p Superview  | 100, 60, 50, 48        |

### FOV

* param1: `camera`
* ACTION: `FV`

| OPTION | FOV         |
|--------|-------------|
| 00     | Wide        |
| 01     | Medium      |
| 02     | Narrow      |

### Framerate

* param1: `camera`
* ACTION: `FS`

| OPTION | FPS         |
|--------|-------------|
| 00     | 12          |
| 01     | 15          |
| 0b     | 12.5        |
| 02     | 24          |
| 03     | 25          |
| 04     | 30          |
| 05     | 48          |
| 06     | 50          |
| 07     | 60          |
| 08     | 100         |
| 09     | 120         |
| 0a     | 240         |
