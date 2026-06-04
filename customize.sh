# FOXXD A67L Call Fix v5.0b - Stock Unisoc IMS Approach

ui_print ""
ui_print " FOXXD A67L Incoming Call Fix v5.0b"
ui_print " =================================="
ui_print ""
ui_print " Root cause: AT&T requires VoLTE (no CSFB)"
ui_print " Solution: Deploy stock Unisoc IMS stack"
ui_print ""
ui_print " This module applies:"
ui_print " 1. Stock com.spreadtrum.ims IMS service (system_ext/priv-app)"
ui_print " 2. ims_bridged daemon + libimsbrd.so"
ui_print " 3. IImsRadio AIDL stubs bundled in APK"
ui_print " 4. Enables VoLTE (persist.vendor.sys.volte.enable=true)"
ui_print " 5. Sets LTE preferred network mode (9)"
ui_print " 6. SELinux rules for IMS communication"
ui_print ""

# Detect current state
RIL_IMPL=$(getprop gsm.version.ril-impl)
NET_TYPE=$(getprop gsm.network.type)
VOLTE_STATE=$(getprop gsm.sys.volte.state)

ui_print " Current RIL: $RIL_IMPL"
ui_print " Network: $NET_TYPE"
ui_print " VoLTE state: $VOLTE_STATE"

ui_print ""
ui_print " After reboot:"
ui_print " - Check 'getprop gsm.sys.volte.state' should be 1"
ui_print " - Check 'dumpsys phone | grep ImsResolver' for bound IMS"
ui_print " - Test incoming calls"
ui_print ""

ui_print " Installation complete. Reboot required."
