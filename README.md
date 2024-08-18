# Mavlink for EdgeTX Lua

This project is inspired by the introduction of MAVLink support in ExpressLRS. The Idea is to provide API for interacting with MAVLink communication on the handset instead of having a dedicated GCS device connected.

## Requirements

* EdgeTX with at least EdgeTX/EdgeTX#5243 applied **Otherwise UI freeze is likely**
* ExpressLRS modified to send MAVLink over CRSF (LupusTheCanine/ExpressLRS branch crsf-mavlink)
* Color LCD radio

## Contents

* MAVLink library
* Demo widgets
  * Mavlink Stats
  * AP Attitude with "Horizon"
  * AP State (Arm and mode)
  * AP Messages

## Library usage

1) Initialize library with

    ```lua
    loadScript("/SCRIPTS/LIBS/Mavlink/Mavlink.lua")()
    ```

    or

    ```lua
    local fnc,err = loadScript("/SCRIPTS/LIBS/Mavlink/Mavlink.lua")
    if fnc then 
        fnc()
        fnc = nil
    end
    ```

    with error handling.
    Multiple initialization is handled by the library so initialization can be done multiple times without illeffects.

2) periodically (as often as practical) call

   ```lua
   Mavlink.update()
   ```

   Library internally throttles update calls so multiple concurent widgets won't significantly increase CPU load

## Available data

Currently implemented messages are 