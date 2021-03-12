#!/bin/sh -eux

MOTD='
Xtal Systems 2020.
'

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-xtal'

    cat >> "$MOTD_CONFIG" <<XTAL
#!/bin/sh

cat <<'EOF'
$MOTD
EOF
XTAL

    chmod 0755 "$MOTD_CONFIG"
else
    echo "$MOTD" >> /etc/motd
fi
