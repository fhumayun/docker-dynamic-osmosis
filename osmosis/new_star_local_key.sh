#!/bin/sh

keytool -genkey -keyalg RSA -alias 1 -keystore star_local_x$(date -u +"%Y%m%d").jks -storepass password -validity 365 -keysize 2048

# change Java keystore permissions to 775
chmod 775 star_local_x$(date -u +"%Y%m%d").jks