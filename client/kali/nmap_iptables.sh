#!/bin/bash

# Store the original iptables rules
iptables-save > /$USER/rules.v4

# Function to change iptables rules
change_iptables_rules() {
    # Open specific TCP and UDP ports
    iptables -A INPUT -p tcp --dport 1:65535 -j ACCEPT
    iptables -A INPUT -p udp --dport 1:65535 -j ACCEPT
    # Allow Nmap scanning techniques
    iptables -A INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST RST -j ACCEPT
    iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
    # Allow outgoing connections from Nmap
    iptables -A OUTPUT -p tcp --sport 1024:65535 -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -p udp --sport 1024:65535 -m state --state RELATED,ESTABLISHED -j ACCEPT
    # Set default policies
    iptables -P INPUT DROP
    iptables -P OUTPUT DROP
    iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
}

# Function to revert iptables rules to the original state
revert_iptables_rules() {
  # Restore the original iptables rules
  iptables-restore < /$USER/rules.v4
}

# Main script
echo "Changing iptables rules..."
change_iptables_rules

echo "Running Nmap scan..."
# Run Nmap scan with customizable arguments
nmap "$@"

echo "Reverting iptables rules..."
revert_iptables_rules

echo "Scan completed."

