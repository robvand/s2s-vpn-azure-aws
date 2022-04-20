output "vpn_1_tun_1" {
  value = aws_vpn_connection.s2s-to-azure-1.tunnel1_address
}
output "vpn_1_tun_2" {
  value = aws_vpn_connection.s2s-to-azure-1.tunnel2_address
}
output "vpn_2_tun_1" {
  value = aws_vpn_connection.s2s-to-azure-2.tunnel1_address
}
output "vpn_2_tun_2" {
  value = aws_vpn_connection.s2s-to-azure-2.tunnel2_address
}
