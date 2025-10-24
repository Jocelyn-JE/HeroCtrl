# Documentation on the GoPro HERO3+ Black API

[< Go back to README.md](/README.md)

## URL Scheme

Most common URL scheme:  <http://10.5.5.9/param1/ACTION?t=PASSWORD&p=%OPTION>

* param1 = That defines if the action will be activated in the **camera** or **bacpac**
*Back in the HERO2 days, the "bacpac" was a separate WiFi unit attached to the camera*
* ACTION = A two character parameter which defines what the camera needs to do. Eg: `SH` for Shoot
* OPTION: The arguments for ACTION
* PASSWORD: The camera password. You can obtain it at <http://10.5.5.9/bacpac/sd> using cURL or other HTTP lib using the "GET" method

## Observed Behavior

1. It seems incorrectly calling any endpoint or any invalid endpoint ie: `ZZ` returns only a `01` byte
2. In any other case, a valid endpoint returns a two byte response corresponding to the action performed. For example: `00 07` if we modified the FPS to 60 via `FS 07`. So maybe the first byte returned is the return code `00` for success and `01` for error
3. Some endpoints return more data, for example the `sx` endpoint returns 56 bytes with the camera status
4. Some endpoints don't require an OPTION, in that case the URL should be called without the `p=%OPTION` part
5. Uppercase endpoints are pseudo-POST endpoints (GET but changes things)
6. Lowercase endpoints return data about the camera eg: `bl` returns the battery level in %

---

## Endpoints summary

* [Actions](/docs/API-docs.md#actions)
* [Recording settings](/docs/API-docs.md#recording-settings)
* [Settings](/docs/API-docs.md#settings)
* [Camera info](/docs/API-docs.md#camera-info--status)
* [Files](/docs/API-docs.md#file-management)
* [Miscellaneous](/docs/API-docs.md#miscellaneous)
* [Research](/docs/API-docs.md#to-research)

---

## Actions

1. ### Power

    * param1: `bacpac`
    * ACTION: `PW`

    Changes the power state of the camera

    | OPTION | Description |
    |--------|-------------|
    | 00     | OFF         |
    | 01     | ON          |

    * param1: `camera`
    * ACTION: `PW`

    Turns off the camera

    | OPTION | Description |
    |--------|-------------|
    | 00     | OFF         |

2. ### Record / Shutter

    * param1: `camera` or `bacpac`
    * ACTION: `SH`

    What this can do depending on the current camera mode:

    * Start/stop recording a video in video mode
    * Take a picture in single picture mode, or take as many pictures as the continuous shot setting
    * Take multiple pictures in burst mode
    * Start/stop taking photos in timelapse mode

    In general this simulates a single shutter button press, if you want to use this for continuous shot you will need to send multiple `SH 01` commands

    Usage:

    | OPTION | Description                         |
    |--------|-------------------------------------|
    | 00     | Stop recording / taking pictures    |
    | 01     | Start recording / taking pictures   |

3. ### Video preview

    * param1: `camera`
    * ACTION: `PV`

    Changes the video preview state. (unstable/random)

    It seems the preview is automatically enabled when starting the camera. If the preview freezes, enable it again to unfreeze it

    | OPTION | Description                      |
    |--------|----------------------------------|
    | 00     | Disables video preview           |
    | 01     | ???                              |
    | 02     | Enables video preview            |

4. ### Locate

    * param1: `camera`
    * ACTION: `LL`

    Turns on/off the locate mode to find the camera

    | OPTION | Description                                            | Notes |
    |--------|--------------------------------------------------------|-------|
    | 00     | Turns off location mode                                | N/A   |
    | 01     | Makes the red led flash and the camera beep to find it | Will beep regardless of volume setting but will not flash if leds are turned off |

5. ### Camera mode

    * param1: `camera`
    * ACTION: `CM`

    Changes the camera's current mode

    | OPTION | Description                                  |
    |--------|----------------------------------------------|
    | 00     | Video mode                                   |
    | 01     | Photo mode                                   |
    | 02     | Burst mode                                   |
    | 03     | Timelapse mode                               |
    | 04     | Video mode (HERO 2 timer mode)               |
    | 05     | Preview mode (touchscreen bacpac or HDMI)    |
    | 06     | Video mode but forces it each time (if you do `00` multiple times nothing happens normally) |
    | 07     | Settings                                     |

---

## Recording settings

1. ### Video resolution

    * param1: `camera`
    * ACTION: `VV` or `VR`

    Changes the current video resolution

    | VV | VR       | Resolution      | Available FPS (NTSC)   | Available FOV          |
    |----|----------|-----------------|------------------------|------------------------|
    | 00 | N/A      | WVGA 240fps     | 240                    | Wide                   |
    | 01 | N/A      | 720p            | 120, 60, 50            | Wide, Medium, Narrow   |
    | 02 | 06/07/0b | 960p            | 100, 60, 50, 48        | Wide                   |
    | 03 | N/A      | 1080p           | 60, 50, 48, 30, 25, 24 | Wide, Medium, Narrow   |
    | 04 | N/A      | 1440p           | 48, 30, 25, 24         | Wide                   |
    | 05 | N/A      | 2.7k            | 30, 25                 | Wide, Medium           |
    | 06 | 0a       | 4k              | 15, 12.5               | Wide                   |
    | 07 | 03       | 2.7k 17:9 24fps | 24                     | Wide, Medium           |
    | 08 | 02       | 4k 17:9 12fps   | 12                     | Wide                   |
    | 09 | N/A      | 1080p Superview | 48, 30, 25, 24         | Wide                   |
    | 0a | N/A      | 720p Superview  | 100, 60, 50, 48        | Wide                   |

2. ### FOV

    * param1: `camera`
    * ACTION: `FV`

    Changes the current field of view

    | OPTION | FOV         |
    |--------|-------------|
    | 00     | Wide        |
    | 01     | Medium      |
    | 02     | Narrow      |

3. ### Framerate

    * param1: `camera`
    * ACTION: `FS`

    Changes the current frames per second

    <!-- markdownlint-disable MD033 -->
    <table>
      <tr>
        <th>OPTION</th>
        <td>00</td>
        <td>0b</td>
        <td>01</td>
        <td>02</td>
        <td>03</td>
        <td>04</td>
        <td>05</td>
        <td>06</td>
        <td>07</td>
        <td>08</td>
        <td>09</td>
        <td>0a</td>
      </tr>
      <tr>
        <th>FPS</th>
        <td>12</td>
        <td>12.5</td>
        <td>15</td>
        <td>24</td>
        <td>25</td>
        <td>30</td>
        <td>48</td>
        <td>50</td>
        <td>60</td>
        <td>100</td>
        <td>120</td>
        <td>240</td>
      </tr>
    </table>
    <!-- markdownlint-enable MD033 -->

    > [!NOTE]
    > Check the Resolution section for available FPS per resolution
    > The closest matching FPS mode (rounded up) will be selected if the requested FPS is not available for the current resolution

4. ### Simultaneous video and photo

    * param1: `camera`
    * OPTION: `PN`

    Changes the simultaneous video and photo setting (will take photos periodically during recording)

    | OPTION | Interval    |
    |--------|-------------|
    | 00     | OFF         |
    | 01     | 5s          |
    | 02     | 10s         |
    | 03     | 30s         |
    | 04     | 60s         |

    > [!NOTE]
    > Simultaneous video and photo is only available when Protune is off and in the following resolutions:
    > * 1080p 24fps
    > * 1080p 30fps
    > * 720p 60fps
    > * 1440p 24fps

5. ### Loop video

    * param1: `camera`
    * OPTION: `LO`

    Changes the loop video setting (continuously records the most recent moment)

    | OPTION | Loop length       |
    |--------|-------------------|
    | 00     | OFF               |
    | 01     | 5min              |
    | 02     | 20min             |
    | 03     | 60min             |
    | 04     | 120min            |
    | 05     | Max (all SD card) |

6. ### Low light

    * param1: `camera`
    * OPTION: `LW`

    Enable / disable the low light mode (only works above 30fps)

    | OPTION | State |
    |--------|-------|
    | 00     | OFF   |
    | 01     | ON    |

7. ### Spot meter

    * param1: `camera`
    * OPTION: `EX`

    Enable / disable the spot meter mode

    | OPTION | State |
    |--------|-------|
    | 00     | OFF   |
    | 01     | ON    |

---

## Photo settings

1. ### Photo resolution

    * param1: `camera`
    * ACTION: `PR`

    Changes the current photo resolution for single photos, bursts and timelapses

    | OPTION | Resolution  | FOV    |
    |--------|-------------|--------|
    | 03     | 5 MP        | Medium |
    | 06     | 7 MP        | Medium |
    | 04     | 7 MP        | Wide   |
    | 05     | 12 MP       | Wide   |

2. ### Timelapse interval

    * param1: `camera`
    * ACTION: `TI`

    Changes the current timelapse photo interval

    | OPTION | Interval    |
    |--------|-------------|
    | 00     | 0.5s        |
    | 01     | 1s          |
    | 02     | 2s          |
    | 05     | 5s          |
    | 0a     | 10s         |
    | 1e     | 30s         |
    | 3c     | 60s         |

3. ### Continuous shot

    * param1: `camera`
    * ACTION: `CS`

    Changes the continuous shot setting (will take photos as long as the shutter is pressed)

    | OPTION | Speed        |
    |--------|--------------|
    | 00     | Single (OFF) |
    | 03     | 3 photos/s   |
    | 05     | 5 photos/s   |
    | 0a     | 10 photos/s  |

4. ### Burst rate

    * param1: `camera`
    * ACTION: `BU`

    Changes the burst rate of the burst mode (number of photos taken in 1 or 2s)

    | OPTION | Rate         |
    |--------|--------------|
    | 00     | 3/1s         |
    | 01     | 5/1s         |
    | 02     | 10/1s        |
    | 03     | 10/2s        |
    | 04     | 30/1s        |
    | 05     | 30/2s        |
    | 06     | 30/3s        |

---

## Protune settings

1. ### Protune

    * param1: `camera`
    * ACTION: `PT`

    Enable/disable Protune

    | OPTION | State    |
    |--------|----------|
    | 00     | Disabled |
    | 01     | Enabled  |

2. ### White balance

    * param1: `camera`
    * ACTION: `WB`

    Changes the white balance setting

    | OPTION | Value   |
    |--------|---------|
    | 00     | Auto    |
    | 01     | 3000k   |
    | 02     | 5500k   |
    | 03     | 6500k   |
    | 04     | Cam RAW |

3. ### Exposure

    * param1: `camera`
    * ACTION: `EV`

    Changes the exposure compensation setting

    | OPTION | Value |
    |--------|-------|
    | 06     | -2.0  |
    | 07     | -1.5  |
    | 08     | -1.0  |
    | 09     | -0.5  |
    | 0a     |  0    |
    | 0b     | +0.5  |
    | 0c     | +1.0  |
    | 0d     | +1.5  |
    | 0e     | +2.0  |

4. ### Sharpness

    * param1: `camera`
    * ACTION: `SP`

    Changes the sharpness setting

    | OPTION | Value  |
    |--------|--------|
    | 00     | High   |
    | 01     | Medium |
    | 02     | Low    |

5. ### ISO Limit

    * param1: `camera`
    * ACTION: `GA`

    Changes the ISO limit setting

    | OPTION | Value  |
    |--------|--------|
    | 00     | 6400   |
    | 01     | 1600   |
    | 02     | 400    |

6. ### Color profile

    * param1: `camera`
    * ACTION: `CO`

    Changes the color profile setting

    | OPTION | Value       |
    |--------|-------------|
    | 00     | GoPro Color |
    | 01     | Flat        |

7. ### Protune resolutions

    * param1: `camera`
    * ACTION: `VV`

    Sets the resolution when Protune is ON

    | VV    | Resolution      | Available FPS (NTSC & PAL) |
    |-------|-----------------|----------------------------|
    | 00/01 | 720p            | 120, 100, 60, 50           |
    | 02    | 960p            | 100, 60, 50                |
    | 03    | 1080p           | 60, 50, 48, 30, 25, 24     |
    | 04    | 1440p           | 48, 30, 25, 24             |
    | 05    | 2.7k            | 30, 25                     |
    | 06    | 4k              | 15, 12.5                   |
    | 07    | 2.7k 17:9 24fps | 24                         |
    | 08    | 4k 17:9 12fps   | 12                         |
    | 09    | 1080p Superview | 48, 30, 25, 24             |
    | 0a    | 720p Superview  | 100, 60, 50                |

---

## Settings

1. ### Volume

    * param1: `camera`
    * ACTION: `BS`

    Change the beep sound volume

    | OPTION | Description |
    |--------|-------------|
    | 00     | No sounds   |
    | 01     | 70% volume  |
    | 02     | 100% volume |

2. ### Leds

    * param1: `camera`
    * ACTION: `LB`

    Changes the led configuration

    | OPTION | Description                    |
    |--------|--------------------------------|
    | 00     | Turns off leds                 |
    | 01     | 2 Leds active (front and back) |
    | 02     | 4 Leds active (all)            |

3. ### Default camera mode

    * param1: `camera`
    * ACTION: `DM`

    Changes the default mode when the camera is powered on

    | OPTION | Description                     |
    |--------|---------------------------------|
    | 00     | Video mode                      |
    | 01     | Photo mode                      |
    | 02     | Burst mode                      |
    | 03     | Time-lapse mode                 |

4. ### Time

    * param1: `camera`
    * ACTION: `TM`

    Sets the date and time of the camera

    This endpoint requires 6 bytes in the URL each preceded by a `%`. Each byte is hexadecimal of course, so you need to [convert](https://www.rapidtables.com/convert/number/decimal-to-hex.html) your decimal value to hex

    | Byte   | Description    | Range     |
    |--------|----------------|-----------|
    | 1      | Year           | (20)00-99 |
    | 2      | Month          | 1-12      |
    | 3      | Day            | 1-31      |
    | 4      | Hour           | 0-23      |
    | 5      | Minute         | 0-59      |
    | 6      | Seconds        | 0-59      |

    Example for `22/10/2025` at `22:08:30`:

    * `http://10.5.5.9/camera/TM?t=PASSWORD&p=%19%0A%16%16%09%1E`

5. ### Video mode

    * param1: `camera`
    * ACTION: `VM`

    Changes the video standard

    | OPTION | Description                                           |
    |--------|-------------------------------------------------------|
    | 00     | [NTSC](https://en.wikipedia.org/wiki/NTSC) video mode |
    | 01     | [PAL](https://en.wikipedia.org/wiki/PAL) video mode   |

6. ### Orientation

    * param1: `camera`
    * ACTION: `UP`

    Changes orientation of the camera's screen and video recording

    | OPTION | Description  |
    |--------|--------------|
    | 00     | UP (default) |
    | 01     | DOWN         |

7. ### One button mode

    * param1: `camera`
    * OPTION: `OB`

    Enable / disable the one button mode (starts recording when powering the camera on)

    | OPTION | State |
    |--------|-------|
    | 00     | OFF   |
    | 01     | ON    |

    > [!NOTE]
    > The one button mode will not work as long as the camera is in wifi "GoPro app" mode

8. ### Auto power off

    * param1: `camera`
    * OPTION: `AO`

    Enable / disable the auto power off mode (stops after given time)

    | OPTION | Delay |
    |--------|-------|
    | 00     | Never |
    | 01     | 1min  |
    | 02     | 2min  |
    | 03     | 5min  |

    > [!NOTE]
    > The auto power off mode will not work as long as the camera is in wifi "GoPro app" mode

---

## Camera info / status

All endpoints to set something in lowercase will return it's value, eg: `pt` will return the status of Protune (ON `01`/OFF `00`)

Exceptions:

* camera `pw` doesn't work

1. ### Camera status

    * param1: `camera`
    * OPTION: `sx`

    Returns 56 bytes of info of all sorts, not all bytes are documented

    All bit position are from index 1 read from left to right

    | Byte      | Description                                                 |
    |-----------|-------------------------------------------------------------|
    | 0         | Response code                                               |
    | 1         | Camera mode                                                 |
    | 3         | Default camera mode                                         |
    | 4         | Spot meter                                                  |
    | 5         | Timelapse interval                                          |
    | 6         | Auto power off                                              |
    | 7         | FOV                                                         |
    | 8         | Photo resolution                                            |
    | 13        | Recording progress (int) high byte                          |
    | 14        | Recording progress (int) low byte                           |
    | 16        | Volume                                                      |
    | 17        | Leds status                                                 |
    | 18        | (Bit 3) Video mode (Bit 2) Locate (Bit 5) One button mode (Bit 6) Orientation (Bit 8) Video preview |
    | 19        | Battery level 0-3                                           |
    | 21        | Photos remaining (int) high byte                            |
    | 22        | Photos remaining (int) low byte                             |
    | 23        | Number of photos taken (int) high byte                      |
    | 24        | Number of photos taken (int) low byte                       |
    | 25        | Recording time left in minutes (int) high byte              |
    | 26        | Recording time left in minutes (int) low byte               |
    | 27        | Number of videos taken (int) high byte                      |
    | 28        | Number of videos taken (int) low byte                       |
    | 29        | Shutter                                                     |
    | 30        | (Bit 1) Color profile (Bit 7) Protune (Bit 2) Low light     |
    | 32        | Burst rate                                                  |
    | 33        | Continuous shot                                             |
    | 34        | White balance                                               |
    | 36        | Simultaneous video and photo interval                       |
    | 37        | Loop video                                                  |
    | 50        | Video resolution                                            |
    | 51        | Framerate                                                   |
    | 52        | (Bits 5/6) Sharpness (Bits 7/8) ISO limit                  |
    | 53        | Exposure                                                    |

2. ### Battery level

    * param1: `camera`
    * OPTION: `bl`

    | Byte   | Description          |
    |--------|----------------------|
    | 0      | Response code        |
    | 1      | Battery level 0-100% |

3. ### Camera name / model

    * param1: `camera`
    * OPTION: `cn`

    Returns "HERO3+ Black Edition"

    | Byte   | Description                   |
    |--------|-------------------------------|
    | 0      | Response code                 |
    | 1      | Number of characters          |
    | ...    | Camera model (multiple bytes) |

4. ### Camera password

    * param1: `camera`
    * OPTION: `sd`

    | Byte   | Description                      |
    |--------|----------------------------------|
    | 0      | Response code                    |
    | 1      | Number of characters             |
    | ...    | Camera password (multiple bytes) |

5. ### Bacpac battery

    * param1: `bacpac`
    * OPTION: `bl`

    Most likely is the battery level of the battery bacpac (i don't have it and it returns 100% when i call it, need someone to test it)

    | Byte   | Description          |
    |--------|----------------------|
    | 0      | Response code        |
    | 1      | Battery level 0-100% |

6. ### Wifi info

    * param1: `bacpac`
    * OPTION: `wp`

    Returns Wifi password and SSID

    | Byte      | Description                      |
    |-----------|----------------------------------|
    | 0         | Response code                    |
    | 1         | Number of characters (n1)        |
    | 2...n1    | Camera password (multiple bytes) |
    | n1+1      | Number of characters (n2)        |
    | n1+2...n2 | Camera SSID (multiple bytes)     |

7. ### Ports

    * param1: `bacpac`
    * OPTION: `pf` (Port forwarding?)

    Returns CSV rows of the different ports

    | Byte      | Description                                    |
    |-----------|------------------------------------------------|
    | 0         | Response code                                  |
    | ...       | Multiple CSV rows ended by `0A` (newline/`\n`) |

8. ### Serial number

    * param1: `bacpac`
    * OPTION: `sn`

    Returns the camera's serial number (without the preceding H for some reason) and mac address (3 times??)

    | Byte   | Description                  |
    |--------|------------------------------|
    | 0      | Response code                |
    | 1-6    | MAC Address                  |
    | 7-12   | MAC Address                  |
    | 13-18  | MAC Address                  |
    | 19-32  | Serial Number                |
    | 33     | `0x05` (unknown purpose)     |

    > [!NOTE]
    > I don't know why the MAC address is repeated 3 times, this endpoint is still a mystery

9. ### Bacpac version?

    * param1: `bacpac`
    * OPTION: `cv`

    Unknown purpose, returns 4 bytes

    | Byte    | Description               |
    |---------|---------------------------|
    | 0       | Response code             |
    | 1-11    | Unknown (`00 01 00 00 00 01 00 01 04 00 24`) in my test|
    | 12-17   | MAC Address               |
    | 18      | Number of characters (n1) |
    | 19...n1 | Camera SSID               |

10. ### Camera version

    * param1: `camera`
    * OPTION: `cv`

    Returns firmware version (HD3.11.03.03) and camera type (HERO3+ Black Edition)

    | Byte      | Description               |
    |-----------|---------------------------|
    | 0         | Response code             |
    | 1-2       | Unknown (`02 0B`) in my test |
    | 3         | Number of characters (n1) |
    | 4...n1    | Firmware version          |
    | n1+1      | Number of characters (n2) |
    | n1+2...n2 | Camera type               |

---

## File management

* param1: `camera`

| ACTION | Description                     |
|--------|---------------------------------|
| DL     | Delete last media file          |
| DA     | Delete all media files          |
| DF     | Delete a specific file (requires replacing `%OPTION` with filepath) |
| FO     | Format SD card                  |

---

## Miscellaneous

* ### Live view

    You can access the live view of the camera as an HLS stream at <http://10.5.5.9//live/amba.m3u8>

---

## To research

| ACTION | Description                                               | param1 |
|--------|-----------------------------------------------------------|--------|
| tc     | Disconnects from the camera?                              | bacpac |
| NO     | Returns `0x00` if no OPTION is given                      | bacpac |
| RS     | Restart the camera's wifi, the bottom blue led flashes    | bacpac |
| PI     | Returns `0x00` if no OPTION is given                      | camera |

* ### camera `CN`

    Reacts to `00` - `FF` but the result will be max `1F` after `1F`

    | OPTION   | Observed result (hex)   |
    |----------|-------------------------|
    | None     | `00 00`                 |
    | 00       | `00 00`                 |
    | 01       | `00 01 00`              |
    | 02       | `00 02 00 00`           |
    | 03       | `00 03 00 00 00`        |
    | XX       | `00 XX 00 * (times XX)` |
    | 1F       | `00 1F 00 * (31 times)` |
    | Above 1F | `00 1F 00 * (31 times)` |

* ### camera `ai`

* ### camera `bv`

* ### camera `cc`

* ### camera `ds`

* ### camera `oo`

* ### camera `rv`

* ### camera `se`

    | Byte      | Description                                                 |
    |-----------|-------------------------------------------------------------|
    | 0         | Response code                                               |
    | 1         | Camera mode                                                 |
    | 3         | Default camera mode                                         |
    | 4         | Spot meter                                                  |
    | 5         | Timelapse interval                                          |
    | 6         | Auto power off                                              |
    | 7         | FOV                                                         |
    | 8         | Photo resolution                                            |
    | 13        | Recording progress (int) high byte                          |
    | 14        | Recording progress (int) low byte                           |
    | 16        | Sound volume                                                |
    | 17        | Leds status                                                 |
    | 18        | (Bit 3) Video mode (Bit 2) Locate (Bit 5) One button mode (Bit 6) Orientation (Bit 8) Video preview |
    | 19        | Battery level 0-100%                                        |
    | 21        | Photos remaining (int) high byte                            |
    | 22        | Photos remaining (int) low byte                             |
    | 23        | Number of photos taken (int) high byte                      |
    | 24        | Number of photos taken (int) low byte                       |
    | 25        | Recording time left in minutes (int) high byte              |
    | 26        | Recording time left in minutes (int) low byte               |
    | 27        | Number of videos taken (int) high byte                      |
    | 28        | Number of videos taken (int) low byte                       |
    | 29        | Shutter                                                     |
    | 30        | (Bit 7) Protune                                             |

* ### camera `st`

* ### camera `um`

* ### camera `xs`

    ---

* ### bacpac `ba`

* ### bacpac `bm`

* ### bacpac `bo`

* ### bacpac `cs`

* ### bacpac `lc`

    Returns HTTP error `410` Gone with `0x01 05`

* ### bacpac `oo`

* ### bacpac `pp`

* ### bacpac `pv`

* ### bacpac `se`

* ### bacpac `sr`

* ### bacpac `vs`

* ### bacpac `wi`

* ### bacpac `ws`

* ### bacpac `wt`

---

### Do not use

> [!IMPORTANT]
> These settings are known to brick the camera until a factory reset is performed. Use at your own risk

1. #### camera `VR` `05` or `08`

    Shows the number 6 in the top left of the camera's screen, replacing the usual camera icon, FOV, FPS and resolution

<!-- markdownlint-disable MD028 -->
> [!CAUTION]
> If you try to record with this setting it will brick the camera until a factory reset is performed

> [!TIP]
> To reset the camera in this situation do the following:
>
> * Remove the battery and SD card
> * Press and hold the shutter button (until the last instruction)
> * Insert the battery
> * Click the power button, the camera should then power up
> * After it powers up, make sure you insert a recommended micro-SD card and update the camera's firmware if it is not the latest version
<!-- markdownlint-enable MD028 -->
