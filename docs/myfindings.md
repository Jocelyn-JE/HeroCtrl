# Documentation on the GoPro HERO3+ Black API

[< Go back to README.md](/README.md)

## URL Scheme

Most common URL scheme:  <http://10.5.5.9/param1/ACTION?t=PASSWORD&p=%OPTION>

* param1 = That defines if the action will be activated in the **camera** or **bacpac**.
*Back in the HERO2 days, the "bacpac" was a separate WiFi unit attached to the camera*.
* ACTION = A two character parameter which defines what the camera needs to do. Eg: `SH` for Shoot
* OPTION: The arguments for ACTION
* PASSWORD: The camera password. You can obtain it at <http://10.5.5.9/bacpac/sd> using cURL or other HTTP lib using the "GET" method.

## Observed Behavior

1. It seems incorrectly calling any endpoint or any invalid endpoint ie: `ZZ` returns only a `01` byte.
2. In any other case, a valid endpoint returns a two byte response corresponding to the action performed. For example: `00 07` if we modified the FPS to 60 via `FS 07`. So maybe the first byte returned is the return code `00` for success and `01` for error.
3. Some endpoints return more data, for example the `sx` endpoint returns 56 bytes with the camera status.
4. Some endpoints don't require an OPTION, in that case the URL should be called without the `p=%OPTION` part.

---

## Endpoints summary

* [Actions](/docs/myfindings.md#actions)
* [Recording settings](/docs/myfindings.md#recording-settings)
* [Settings](/docs/myfindings.md#settings)
* [Miscellaneous](/docs/myfindings.md#miscellaneous)

---

## Actions

1. ### Power

    * param1: `bacpac`
    * ACTION: `PW`

    Changes the power state of the camera.

    | OPTION | Description |
    |--------|-------------|
    | 00     | OFF         |
    | 01     | ON          |

    * param1: `camera`
    * ACTION: `PW`

    Turns off the camera.

    | OPTION | Description |
    |--------|-------------|
    | 00     | OFF         |

2. ### Record / Shutter

    * param1: `camera`
    * ACTION: `SH`

    What this can do depending on the current camera mode:

    * Start/stop recording a video in video mode
    * Take a singular picture in single picture mode.
    * Start/stop taking pictures in the continuous pictures mode
    * Take multiple pictures in burst mode.

    Usage:

    | OPTION | Description                         |
    |--------|-------------------------------------|
    | 00     | Stop recording / taking pictures    |
    | 01     | Start recording / taking pictures   |

3. ### Video preview

    * param1: `camera`
    * ACTION: `PV`

    Changes the video preview state. (unstable/random)

    It seems the preview is automatically enabled when starting the camera. If the preview freezes, enable it again to unfreeze it.

    | OPTION | Description                      |
    |--------|----------------------------------|
    | 00     | Disables video preview           |
    | 01     | ???                              |
    | 02     | Enables video preview            |

4. ### Locate

    * param1: `camera`
    * ACTION: `LL`

    Turns on/off the locate mode to find the camera.

    | OPTION | Description                                            | Notes |
    |--------|--------------------------------------------------------|-------|
    | 00     | Turns off location mode                                | N/A   |
    | 01     | Makes the red led flash and the camera beep to find it | Will beep regardless of volume setting but will not flash if leds are turned off |

---

## Recording settings

1. ### Resolution

    * param1: `camera`
    * ACTION: `VV`

    Changes the current video resolution.

    | OPTION | Resolution      | Available FPS (NTSC)   | Available FOV          |
    |--------|-----------------|------------------------|------------------------|
    | 00     | WVGA 240fps     | 240                    | Wide                   |
    | 01     | 720p            | 120, 60, 50            | Wide, Medium, Narrow   |
    | 02     | 960p            | 100, 60, 50, 48        | Wide                   |
    | 03     | 1080p           | 60, 50, 48, 30, 25, 24 | Wide, Medium, Narrow   |
    | 04     | 1440p           | 48, 30, 25, 24         | Wide                   |
    | 05     | 2.7k            | 30, 25                 | Wide, Medium           |
    | 06     | 4k              | 15, 12.5               | Wide                   |
    | 07     | 2.7k 17:9 24fps | 24                     | Wide, Medium           |
    | 08     | 4k 17:9 12fps   | 12                     | Wide                   |
    | 09     | 1080p Superview | 48, 30, 25, 24         | Wide                   |
    | 0a     | 720p Superview  | 100, 60, 50, 48        | Wide                   |

2. ### FOV

    * param1: `camera`
    * ACTION: `FV`

    Changes the current field of view.

    | OPTION | FOV         |
    |--------|-------------|
    | 00     | Wide        |
    | 01     | Medium      |
    | 02     | Narrow      |

3. ### Framerate

    * param1: `camera`
    * ACTION: `FS`

    Changes the current frames per second.

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
    > Check the Resolution section for available FPS per resolution.
    > The closest matching FPS mode (rounded up) will be selected if the requested FPS is not available for the current resolution.

---

## Settings

1. ### Volume

    * param1: `camera`
    * ACTION: `BS`

    Change the beep sound volume.

    | OPTION | Description |
    |--------|-------------|
    | 00     | No sounds   |
    | 01     | 70% volume  |
    | 02     | 100% volume |

2. ### Leds

    * param1: `camera`
    * ACTION: `LB`

    Changes the led configuration.

    | OPTION | Description                    |
    |--------|--------------------------------|
    | 00     | Turns off leds                 |
    | 01     | 2 Leds active (front and back) |
    | 02     | 4 Leds active (all)            |

3. ### Default camera mode

    * param1: `camera`
    * ACTION: `DM`

    Changes the default mode when the camera is powered on.

    | OPTION | Description                     |
    |--------|---------------------------------|
    | 00     | Video mode                      |
    | 01     | Photo mode                      |
    | 02     | Burst mode                      |
    | 03     | Time-lapse mode                 |

4. ### Time

    * param1: `camera`
    * ACTION: `TM`

    Sets the date and time of the camera.

    This endpoint requires 6 bytes in the URL each preceded by a `%`. Each byte is hexadecimal of course, so you need to [convert](https://www.rapidtables.com/convert/number/decimal-to-hex.html) your decimal value to hex.

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

    Changes the video standard.

    | OPTION | Description                     |
    |--------|---------------------------------|
    | 00     | [NTSC](https://en.wikipedia.org/wiki/NTSC) video mode                 |
    | 01     | [PAL](https://en.wikipedia.org/wiki/PAL) video mode                  |

---

### File management

* param1: `camera`

| ACTION | Description                     |
|--------|---------------------------------|
| DL     | Delete last media file          |
| DA     | Delete all media files          |
| DF     | Delete a specific file (requires replacing `%OPTION` with filepath) |
| FO     | Format SD card                  |

### Miscellaneous

| ACTION | Description / Options                                     | param1 |
|--------|-----------------------------------------------------------|--------|
| sd     | Get wifi password                                         | bacpac |
| NO     | Returns `0x00` if no OPTION is given                      | bacpac |
| RS     | Restart the camera's wifi, the bottom blue led flashes    | bacpac |
| sx     | Gets the status of the camera, returns 56 bytes           | camera |
| PI     | Returns `0x00` if no OPTION is given                      | camera |
| PV     | Options are `0x00`, `0x01` and `0x02` no visible reaction on the camera | camera |
