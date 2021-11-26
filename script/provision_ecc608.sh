#!/bin/bash

mfr_app="/usr/bin/gateway_mfr"
tek_device_path="/dev/ttyO1"

# Try to provision

for n in {1..5}; do
    output=$("${mfr_app}" --path "${tek_device_path}" provision 2>&1 >/dev/null)
    case "${output}" in
        "") # Successful
            break
            ;;
        *"ecc error ExecError") # Already provisioned
            break
            ;;
        *"crc error expected"*) # Potentially intermittent problem; retry
            echo "CRC failure while provisioning ECC608. Retrying"
            sleep 5
            ;;
        *) # Failure
            echo "Error provisioning ECC608 device"
            exit 1
            ;;
    esac
done

# Print out provisioning information
"${mfr_app}" --path "${tek_device_path}" key 0 2>&1
