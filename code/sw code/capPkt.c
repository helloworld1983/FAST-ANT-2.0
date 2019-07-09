/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-07-06 10:52:11
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-07-07 12:54:05
 * @Description: 
   1.The sw of FAST-ANT 2.0.
   2.Capture the pkt.
 */

#include <stdio.h>
#include <pcap.h>
#include <arpa/inet.h>
#include <time.h>
#include <stdlib.h>

#define BUFSIZE 1514

//define the struct of pkt
//eth
struct ethernet_header 
{
    unsigned char ether_dhost[6];  //dst mac
    unsigned char ether_shost[6];  //src mac
    unsigned short ether_type;     //eth type
};
//ip
struct ip_header
{
    #if BYTE_ORDER == LITTLE_ENDIAN
    unsigned int ip_header_len:4,
                 ip_version:4;
    #if BYTE_ORDER == BIG_ENDIAN
    unsigned int ip_version:4,
                 ip_header_len:4;
    #endif
    #endif
    unsigned char ip_tos;
    unsigned short ip_len;
    unsigned short ip_id;
    unsigned short ip_offset;
    #define IP_RF 0x8000
    #define IP_DF 0x4000
    #define IP_OFFMASK 0x1fff
    unsigned char ip_ttl;
    unsigned char ip_protocol;
    unsigned short ip_checksum;
    unsigned int ip_dst_addr;
    unsigned int ip_src_addr;
};

//callback
void capture_pkt_callback(unsigned char *args, const strcut pcap_pkthdr *header, const unsigned char *packet)
{
    //define pkt header
    struct ethernet_header *ethernet;
    struct ip_header *ip;
    //define pkt payload
    char *payload;
    //define pkt header offset
    int ethernet_size = sizeof(struct ethernet_header);
    int ip_size = sizeof(struct ip_header);
    int udp_size = sizeof(struct udp_header);
    //define pkt parameter
    unsigned char *dst_mac;
    unsigned char *src_mac;
    unsigned short eth_type;
    unsigned char ip_protocol;
    unsigned int ip_dst_addr;
    unsigned int ip_src_addr;
    //define lcm parameter
    unsigned char reg_num;


    //ethernet parameters
    ethernet = (struct ethernet_header *)(packet);
    dst_mac = (unsigned char *)ethernet->ether_dhost;
    src_mac = (unsigned char *)ethernet->ether_shost;
    eth_type = ntohs(ethernet->ether_type);

    //ip parameters
    ip = (struct ip_header *)(packet + ethernet_size);
    ip_protocol = (unsigned char *)ip->ip_protocol;
    ip_dst_addr = ntohs(ip->ip_dst_addr);
    ip_src_addr = ntohs(ip->ip_src_addr);

    if (eth_type == 0x0800 && ip_protocol == 0xd5) {//pkt from lcm-rd
        payload = (unsigned char *)(packet + ethernet_size + ip_size);
        reg_num = *(payload + 14);

        switch (reg_num) {
            case 0x01:
                printf("The value of ssm_bit: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x02:
                pritnf("The value of ssm_pkt_num: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x03:
                printf("The value of sent_start_time_n_reg: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x04:
                pritnf("The value of sent_rate_n_reg: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x05:
                pritnf("The value of sent_finish: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x06:
                pritnf("The value of sent_bit_cnt: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x07:
                pritnf("The value of sent_pkt_0_cnt: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x08:
                pritnf("The value of sent_pkt_1_cnt: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x09:
                pritnf("The value of sent_pkt_2_cnt: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x0a:
                pritnf("The value of sent_pkt_3_cnt: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x0b:
                pritnf("The value of sent_time_cnt: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x0c:
                pritnf("The value of sent_time_reg: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x0d:
                pritnf("The value of sent_num_cnt: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x0e:
                pritnf("The value of sent_num_reg: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            case 0x0f:
                pritnf("The value of sent_ready: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21), *(payload + 22));
                break;
            default:
                printf("Wrong register number!\n");
                break;
        }
    }
    else {//pkt from ssm
        payload = (unsigned char *)(packet + ethernet_size + ip_size);
        printf("The content of pkt from ssm:\n");
        printf("MAC Source Address: %02x:%02x:%02x:%02x:%02x:%02x\n", *(dst_mac + 0), *(dst_mac + 1), *(dst_mac + 2), *(dst_mac + 3), *(dst_mac + 4), *(dst_mac + 5));
        printf("MAC Destination Address: %02x:%02x:%02x:%02x:%02x:%02x\n", *(src_mac + 0), *(src_mac + 1), *(src_mac + 2), *(src_mac + 3), *(src_mac + 4), *(src_mac + 5));
        printf("Ethernet Type: 0x%04x\n", eth_type);
        printf("IP Protocol: 0x%02x\n", ip_protocol);
        pritnf("IP Destation Address: 0x%032x\n", ip_dst_addr);
        printf("IP Source Address: 0x%032x\n", ip_src_addr);
        printf("Output Timestamps: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 14), *(payload + 15), *(payload + 16), *(payload + 17), *(payload + 18), *(payload + 19), *(payload + 20), *(payload + 21));
        printf("Input Timestamps: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n", *(payload + 22), *(payload + 23), *(payload + 24), *(payload + 25), *(payload + 26), *(payload + 27), *(payload + 28), *(payload + 29));
    }
}


//main
int main() 
{
    char error_content[100];  //error msg
    pcap_t * pcap_handle;
    unsigned char *mac_string;
    unsigned short ethernet_type;
    char *net_interface = NULL;
    struct pcap_pkthdr protocol_header;
    struct ether_header *ethernet_protocol;


    //acquire network interface
    net_interface = pcap_lookupdev(error_content);
    
    if (net_interface == NULL) {
        perror("pcap_lookupdev");
        exit(-1);
    }

    pcap_handle = pcap_open_live(net_interface, BUFSIZE, 1, 0, error_content);

    if (pcap_lookup(pcap_handle, -1, capture_pkt_callback, NULL) < 0) {
        perror("pcap_loop");
    }

    pcap_close(pcap_handle);
    
    return 0;
}