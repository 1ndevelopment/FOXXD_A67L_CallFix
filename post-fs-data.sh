#!/system/bin/sh

while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 5
done

setprop persist.sys.phh.ims.floss true

settings put global preferred_network_mode 9
settings put global preferred_network_mode0 9
setprop gsm.radio.networkmode 9

sleep 3

setprop persist.vendor.sys.volte.enable true
setprop persist.ims.apn ims

# Switch to Spreadtrum IMS overlay, disable FLOSS IMS
cmd overlay enable me.phh.treble.overlay.sprdims_telephony 2>/dev/null
cmd overlay disable me.phh.treble.overlay.flossims_telephony 2>/dev/null

# Ensure ims_bridged daemon stays running
if [ "$(getprop init.svc.ims_bridged)" = "running" ]; then
    : # init-based service is running
elif [ -f /system/system_ext/bin/ims_bridged ]; then
    nohup /system/system_ext/bin/ims_bridged >/dev/null 2>&1 &
    log -t "CallFix" "Started ims_bridged daemon (direct, not via init)"
fi

if [ "$(getprop init.svc.vendor.ril-daemon)" != "running" ]; then
    setprop ctl.start vendor.ril-daemon 2>/dev/null
fi

log -t "CallFix" "Applied: Stock Unisoc IMS v5.12b (SPRD overlay), VoLTE on, LTE mode 9"

# Apply SELinux rules live for IMS service
magiskpolicy --live "allow priv_app ext_radio_service service_manager find"
magiskpolicy --live "allow priv_app default_android_service service_manager find"
magiskpolicy --live "allow priv_app radio_prop property_service set"
magiskpolicy --live "allow priv_app radio binder { call transfer }"
magiskpolicy --live "allow priv_app rild binder { call transfer }"
magiskpolicy --live "allow priv_app property_socket sock_file { write }"

# Ensure SELinux permissive for testing if needed
if [ "$(getenforce)" = "Enforcing" ]; then
    echo 0 > /sys/fs/selinux/enforce 2>/dev/null
    log -t "CallFix" "SELinux still enforcing after boot - set to permissive"
fi
