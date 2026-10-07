#!/bin/bash
# ~/.config/tmux/scripts/network_speed.sh
# Compatible with Linux and macOS

get_network_speed() {
    # 自动选择默认网卡
    if [[ -n "$1" ]]; then
        interface="$1"
    elif [[ "$(uname -s)" == "Darwin" ]]; then
        interface=$(route get default 2>/dev/null |
            awk '/interface:/ {print $2}')
    else
        interface=$(ip route show default 2>/dev/null |
            awk '/default/ {print $5; exit}')
        interface="${interface:-eth0}"
    fi

    cache_file="/tmp/tmux_net_${interface}"

    # 获取当前累计流量
    case "$(uname -s)" in
        Linux)
            rx_bytes=$(cat "/sys/class/net/$interface/statistics/rx_bytes" 2>/dev/null || echo 0)
            tx_bytes=$(cat "/sys/class/net/$interface/statistics/tx_bytes" 2>/dev/null || echo 0)
            ;;

        Darwin)
            # macOS netstat:
            # Name Mtu Network Address Ipkts Ierrs Ibytes Opkts Oerrs Obytes Coll
            read rx_bytes tx_bytes <<< "$(
                netstat -b -I "$interface" 2>/dev/null |
                awk -v iface="$interface" '
                    $1 == iface && $7 ~ /^[0-9]+$/ && $10 ~ /^[0-9]+$/ {
                        rx += $7
                        tx += $10
                    }
                    END {
                        print rx+0, tx+0
                    }
                '
            )"
            ;;

        *)
            echo "0B/s:0B/s"
            return
            ;;
    esac

    current_time=$(date +%s)

    # 读取上一次的数据
    if [[ -f "$cache_file" ]]; then
        read prev_rx prev_tx prev_time < "$cache_file"

        time_diff=$((current_time - prev_time))

        if [[ $time_diff -gt 0 ]]; then
            rx_speed=$(( (rx_bytes - prev_rx) / time_diff ))
            tx_speed=$(( (tx_bytes - prev_tx) / time_diff ))

            # 防止接口重置导致负数
            [[ $rx_speed -lt 0 ]] && rx_speed=0
            [[ $tx_speed -lt 0 ]] && tx_speed=0

            # RX
            if [[ $rx_speed -ge 1048576 ]]; then
                rx_display="$((rx_speed / 1048576))M"
            elif [[ $rx_speed -ge 1024 ]]; then
                rx_display="$((rx_speed / 1024))K"
            else
                rx_display="${rx_speed}B"
            fi

            # TX
            if [[ $tx_speed -ge 1048576 ]]; then
                tx_display="$((tx_speed / 1048576))M"
            elif [[ $tx_speed -ge 1024 ]]; then
                tx_display="$((tx_speed / 1024))K"
            else
                tx_display="${tx_speed}B"
            fi

            echo "${rx_display}/s:${tx_display}/s"
        else
            echo "0B/s:0B/s"
        fi
    else
        echo "0B/s:0B/s"
    fi

    # 保存当前累计流量
    echo "$rx_bytes $tx_bytes $current_time" > "$cache_file"
}

#get_network_speed "$1"
