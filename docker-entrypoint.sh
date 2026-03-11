#!/bin/sh
set -e

MAIN_URL="${GOOSERSS_URL:-http://localhost:40053/}"
ACCESS="${GOOSERSS_ACCESS:-1234-2468-1357}"
QUALITY="${GOOSERSS_QUALITY:-720,1080,2160}"
EZTV_API_URL="${GOOSERSS_EZTV_API:-https://eztvx.to/api/get-torrents}"
USER_AGENT="${GOOSERSS_USER_AGENT:-Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:142.0) Gecko/20100101 Firefox/142.0}"
CACHE_YT_TTL="${GOOSERSS_CACHE_YT_TTL:-21600}"
CACHE_EZTV_TTL="${GOOSERSS_CACHE_EZTV_TTL:-86400}"
SUCCESS_LOG="${GOOSERSS_SUCCESS_LOG:-false}"
ERROR_LOG="${GOOSERSS_ERROR_LOG:-false}"

# Build the QUALITY_FILTER array string from comma-separated values
QUALITY_ARRAY=""
IFS=','
for q in $QUALITY; do
    if [ -z "$QUALITY_ARRAY" ]; then
        QUALITY_ARRAY="'$q'"
    else
        QUALITY_ARRAY="$QUALITY_ARRAY, '$q'"
    fi
done
unset IFS

cat > /var/www/html/config.php <<PHPEOF
<?php
define('MAIN_URL', '${MAIN_URL}');
define('ACCESS', '${ACCESS}');
define('QUALITY_FILTER', array(${QUALITY_ARRAY}));
define('EZTV_API_URL', '${EZTV_API_URL}');
define('USER_AGENT', '${USER_AGENT}');
define('CACHE_DIR', '/cache');
define('CACHE_YT_TTL', ${CACHE_YT_TTL});
define('CACHE_EZTV_TTL', ${CACHE_EZTV_TTL});
define('CACHE_YT_PREFIX', 'yt_');
define('CACHE_EZTV_PREFIX', 'eztv_');
define('SUCCESS_LOG', ${SUCCESS_LOG});
define('ERROR_LOG', ${ERROR_LOG});
?>
PHPEOF

exec "$@"
