#!/system/bin/sh
    echo "ftm_power_config start" > /dev/kmsg
    bootmode=`getprop ro.vendor.factory.mode`

    # Imported from init.qcom.post_boot.sh

    # Post-setup services
    setprop vendor.post_boot.parsed 1

    # Let kernel know our image version/variant/crm_version
    if [ -f /sys/devices/soc0/select_image ]; then
        image_version="10:"
        image_version+=`getprop ro.build.id`
        image_version+=":"
        image_version+=`getprop ro.build.version.incremental`
        image_variant=`getprop ro.product.name`
        image_variant+="-"
        image_variant+=`getprop ro.build.type`
        oem_version=`getprop ro.build.version.codename`
        echo 10 > /sys/devices/soc0/select_image
        echo $image_version > /sys/devices/soc0/image_version
        echo $image_variant > /sys/devices/soc0/image_variant
        echo $oem_version > /sys/devices/soc0/image_crm_version
    fi

    # Parse misc partition path and set property
    misc_link=$(ls -l /dev/block/bootdevice/by-name/misc)
    real_path=${misc_link##*>}
    setprop persist.vendor.mmi.misc_dev_path $real_path

    sleep 5
    echo 0 > /sys/devices/system/cpu/cpu4/online
    echo 0 > /sys/devices/system/cpu/cpu5/online
    echo 0 > /sys/devices/system/cpu/cpu6/online
    echo 0 > /sys/devices/system/cpu/cpu7/online

    echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
    baseband=`getprop ro.baseband`
    echo "ftm_power_config done baseband=$baseband" > /dev/kmsg

