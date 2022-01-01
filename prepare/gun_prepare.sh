improt_package "utils" "gen_certificates.sh"


# gun Transport mode
GUN_TRANSPORT_MODE=(
grpc-with-tls
grpc-without-tls
)


grpc_with_tls_mode_logic(){
    firewallNeedOpenPort=443
    shadowsocksport="${firewallNeedOpenPort}"
    kill_process_if_port_occupy "${firewallNeedOpenPort}"
    get_cdn_or_dnsonly_type_domain
    if [ "${domainType}" = "DNS-Only" ]; then
        acme_get_certificate_by_force "${domain}"
    elif [ "${domainType}" = "CDN" ]; then
        acme_get_certificate_by_api_or_manual "${domain}"
    fi
}

grpc_without_tls_mode_logic(){
    firewallNeedOpenPort="${shadowsocksport}"
}

install_prepare_libev_gun(){
    generate_menu_logic "${GUN_TRANSPORT_MODE[*]}" "传输模式" "1"
    libev_gun="${inputInfo}"
    improt_package "utils" "common_prepare.sh"
    if [ "${libev_gun}" = "1" ]; then
        grpc_with_tls_mode_logic
    elif [ "${libev_gun}" = "2" ]; then
        grpc_without_tls_mode_logic
    fi
}