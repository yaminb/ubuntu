#!/usr/bin/env bash

#===============================================================================
#         FILE:  reconnect-vpn.sh
#
#  DESCRIPTION:  Reconnect a disconnected VPN session on Synology DSM
#    SOURCE(S):  https://community.synology.com/enu/forum/17/post/53791
#       README:  https://github.com/ianharrier/synology-scripts
#
#       AUTHOR:  Ian Harrier, Michael Lake, Deac Karns
#      VERSION:  1.4.0
#      LICENSE:  MIT License
#===============================================================================


#-------------------------------------------------------------------------------
#  User-customizable variables
#-------------------------------------------------------------------------------

# VPN_CHECK_METHOD : How to check if the VPN connection is alive. Options:
#  - "dsm_status" (default) : assume OK if Synology DSM reports the VPN connection is alive
#  - "gateway_ping" : assume OK if the default gateway (i.e. VPN server) responds to ICMP ping
#  - "domain_ping" : assume OK if the domain (google.com) responds to ICMP ping
#  - Uncomment and set PING_OVERRIDE to force a specific IP address to be pinged instead of the gateway
VPN_CHECK_METHOD=domain_ping

# GATEWAY_PING_OVERRIDE : Force a specific IP address to be pinged. Note that
# VPN_CHECK_METHOD must be set to "gateway_ping" in order for this to work. Options:
#  - commented (default) : use the VPN's gateway IP for ping
#  - an IP address : the IP address to ping
#GATEWAY_PING_OVERRIDE=1.1.1.1

# DOMAIN_PING_OVERRIDE : Force a specific domain to be pinged. Note that
# VPN_CHECK_METHOD must be set to "domain_ping" in order for this to work. Options:
#  - commented (default) : Use the default "google.com" address for ping
#  - a domain name : The domain name to resolve and ping
#DOMAIN_PING_OVERRIDE=apple.com


#-------------------------------------------------------------------------------
#  Check system config
#-------------------------------------------------------------------------------

# Make sure we're executing as root (required to get VPN information from synovpnc)
if [[ ${UID} -ne 0 ]]; then
    echo -e "This script must be run as root. \n"
    exit 1
fi

# Get the VPN config files
CONFIGS_ALL=$(cat /usr/syno/etc/synovpnclient/{openvpn,l2tp}/*client.conf 2>/dev/null)

# How many VPN profiles are there?
CONFIGS_QTY=$(echo "$CONFIGS_ALL" | grep -e '\[l' -e '\[o' | wc -l)

# Only proceed if there is 1 VPN profile
if [[ $CONFIGS_QTY -eq 1 ]]; then
    echo "[I] There is 1 VPN profile. Continuing..."
elif [[ $CONFIGS_QTY -gt 1 ]]; then
    echo "[E] There are $CONFIGS_QTY VPN profiles. This script supports only 1 VPN profile. Exiting..."
    exit 3
else
    echo "[W] There are 0 VPN profiles. Please create a VPN profile. Exiting..."
    exit 3
fi

PROFILE_ID=$(echo $CONFIGS_ALL | cut -d "[" -f2 | cut -d "]" -f1)
PROFILE_NAME=$(echo "$CONFIGS_ALL" | grep -oP "conf_name=+\K\w+")
PROFILE_RECONNECT=$(echo "$CONFIGS_ALL" | grep -oP "reconnect=+\K\w+")
VPN_OFFLINE_FLAG_FILE="/tmp/reconnect-vpn-offline"

if [[ $(echo "$CONFIGS_ALL" | grep '\[o') ]]; then
    PROFILE_PROTOCOL="openvpn"
elif [[ $(echo "$CONFIGS_ALL" | grep '\[l') ]]; then
    PROFILE_PROTOCOL="l2tp"
fi


#-------------------------------------------------------------------------------
#  Function definitions
#-------------------------------------------------------------------------------

function check_dsm_status() {
    if [[ $(/usr/syno/bin/synovpnc get_conn | grep Uptime) ]]; then
        echo "[I] Synology DSM reports VPN is connected."
        return 0
    else
        echo "[W] Synology DSM reports VPN is not connected."
        return 1
    fi
}

function check_gateway_ping() {
    local CLIENT_IP=$(/usr/syno/bin/synovpnc get_conn | grep "Client IP" | awk '{ print $4 }')
    local TUNNEL_INTERFACE=$(ip addr | grep $CLIENT_IP | awk '{ print $NF }')
    local GATEWAY_IP=$(ip route | grep $TUNNEL_INTERFACE | grep -oE '([0-9]+\.){3}[0-9]+ dev' | awk '{ print $1 }' | head -n 1)
    local PING_IP=$([[ ! -z "$GATEWAY_PING_OVERRIDE" ]] && echo "$GATEWAY_PING_OVERRIDE" || echo "$GATEWAY_IP")
    if ping -c 1 -i 1 -w 5 -I $TUNNEL_INTERFACE $PING_IP > /dev/null 2>&1; then
        echo "[I] The gateway IP $PING_IP responded to ping."
        return 0
    else
        echo "[W] The gateway IP $PING_IP did not respond to ping."
        return 1
    fi
}

function check_domain_ping() {
    local DOMAIN=$([[ ! -z "$DOMAIN_PING_OVERRIDE" ]] && echo "$DOMAIN_PING_OVERRIDE" || echo "google.com")
    local CLIENT_IP=$(/usr/syno/bin/synovpnc get_conn | grep "Client IP" | awk '{ print $4 }')
    local TUNNEL_INTERFACE=$(ip addr | grep $CLIENT_IP | awk '{ print $NF }')
    local DOMAIN_IP=$(nslookup "$DOMAIN" | tail -n +3 | sed -n 's/Address: \s*//p' | head -n 1)
    if ping -c 1 -i 1 -w 5 -I $TUNNEL_INTERFACE $DOMAIN_IP > /dev/null 2>&1; then
        echo "[I] The domain ($DOMAIN) IP $DOMAIN_IP responded to ping."
        return 0
    else
        echo "[W] The domain ($DOMAIN) IP $DOMAIN_IP did not respond to ping."
        return 1
    fi
}

function check_vpn_connection() {
    local CONNECTION_STATUS=disconnected
    if [[ $VPN_CHECK_METHOD = "gateway_ping" ]]; then
        check_dsm_status && check_gateway_ping && CONNECTION_STATUS=connected
    elif [[ $VPN_CHECK_METHOD = "domain_ping" ]]; then
        check_dsm_status && check_domain_ping && CONNECTION_STATUS=connected
    else
        check_dsm_status && CONNECTION_STATUS=connected
    fi
    if [[ $CONNECTION_STATUS = "connected" ]]; then
        clear_connection_error_indicator
        return 0
    else
        create_connection_error_indicator
        return 1
    fi
}

function create_connection_error_indicator() {
    # only do these if an 'offline' status flag has not been created by previous instances of this script
    if [ ! -f "$VPN_OFFLINE_FLAG_FILE" ]; then
        touch "$VPN_OFFLINE_FLAG_FILE"

        if [ ! -z "$STATUS_OFFLINE_INDICATOR_FILE" ] && [ -d $(dirname "$STATUS_OFFLINE_INDICATOR_FILE") ] && [ ! -f "$STATUS_OFFLINE_INDICATOR_FILE" ]; then
            touch "$STATUS_OFFLINE_INDICATOR_FILE"
        fi

        if [[ ! -z "$DISPLAY_HARDWARE_ALERTS" && "$DISPLAY_HARDWARE_ALERTS" = "true" ]]; then
            echo "3:" > /dev/ttyS1  # long beep + solid orange status light
        fi
    fi
}

function clear_connection_error_indicator() {
    if [ -f "$VPN_OFFLINE_FLAG_FILE" ]; then
        rm -f "$VPN_OFFLINE_FLAG_FILE"

        if [[ ! -z "$DISPLAY_HARDWARE_ALERTS" && "$DISPLAY_HARDWARE_ALERTS" = "true" ]]; then
            echo "28" > /dev/ttyS1  # short beep + solid green status light
        fi
    fi
    if [ ! -z "$STATUS_OFFLINE_INDICATOR_FILE" ] && [ -f "$STATUS_OFFLINE_INDICATOR_FILE" ]; then
        rm -f "$STATUS_OFFLINE_INDICATOR_FILE"
    fi
}


#-------------------------------------------------------------------------------
#  Check VPN and reconnect if needed
#-------------------------------------------------------------------------------

if check_vpn_connection; then
    echo "[I] Reconnect is not needed. Exiting..."
    exit 0
fi

if [[ $PROFILE_RECONNECT != "yes" ]]; then
    echo "[W] Reconnect is disabled. Please enable reconnect for for the \"$PROFILE_NAME\" VPN profile. Exiting..."
    exit 3
fi

echo "[I] Attempting to reconnect..."
if [[ ! -z "$DISPLAY_HARDWARE_ALERTS" && "$DISPLAY_HARDWARE_ALERTS" = "true" ]]; then
    echo ";" > /dev/ttyS1  # blinking orange status light
fi

/usr/syno/bin/synovpnc kill_client
sleep 15

echo conf_id=$PROFILE_ID > /usr/syno/etc/synovpnclient/vpnc_connecting
echo conf_name=$PROFILE_NAME >> /usr/syno/etc/synovpnclient/vpnc_connecting
echo proto=$PROFILE_PROTOCOL >> /usr/syno/etc/synovpnclient/vpnc_connecting
/usr/syno/bin/synovpnc connect --id=$PROFILE_ID
sleep 15

#  Re-check the VPN connection
if check_vpn_connection; then
    echo "[I] VPN successfully reconnected. Exiting..."
    exit 1
else
    echo "[E] VPN failed to reconnect. Exiting..."
    exit 2
fi

