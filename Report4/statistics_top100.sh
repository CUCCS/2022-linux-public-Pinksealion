#!/usr/bin/env bash

function help {
    echo "==========Web服务器访问日志批处理脚本内置帮助信息.doc=========="

    echo "该文本批处理脚本能够支持："
    
    echo "-t                统计访问来源主机TOP 100和分别对应出现的总次数"
    echo "-i                统计访问来源主机TOP 100 IP和分别对应出现的总次数"
    echo "-u                统计最频繁被访问的URL TOP 100"
    echo "-c                统计不同响应状态码的出现次数和对应百分比"
    echo "-f                分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    echo "-s                给定URL输出TOP 100访问来源主机"
    echo "-h                显示脚本帮助文档"
}

# 统计访问来源主机TOP 100和分别对应出现的总次数
function TOP100_Host {
    printf "%50s\t%s\n" "TOP100_host" "Count"
    awk -F "\t" '
    NR>1 {host[$1]++;}
    END { 
        for(i in host) {
            printf("%50s\t%d\n",i,host[i]);
        }
    }
    ' web_log.tsv | sort -g -k 2 -r | head -100
    
}

# 统计访问来源主机TOP 100 IP和分别对应出现的总次数
function TOP100_IP {
    printf "%50s\t%s\n" "TOP100_IP" "Count"
    awk -F "\t" '
    NR>1 {
        if(match($1, /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/)) {
            ip[$1]++;
        }
    }
    END { 
        for(i in ip) {
            printf("%50s\t%d\n",i,ip[i]);
        }
    }
    ' web_log.tsv | sort -g -k 2 -r | head -100  
}

# 统计最频繁被访问的URL TOP 100
function URL_TOP100 {
    printf "%60s\t%s\n" "URL_TOP100" "Count"
    awk -F "\t" '
    NR>1 {
        url[$5]++;
        }
    END { 
        for(i in url) {
            printf("%60s\t%d\n",i,url[i]);
        }
    }
    ' web_log.tsv | sort -g -k 2 -r | head -100  
}

# 统计不同响应状态码的出现次数和对应百分比
function StatusCode {
    
    awk -F "\t" '
    BEGIN{
        printf("Code\tCount\tPercentage\n");
    }
    NR>1 {
        code[$6]++;
        }
    END { 
        for(i in code) {
            printf("%d\t%d\t%f%%\n",i,code[i],code[i]*100.0/(NR-1));
        }
    }
    ' web_log.tsv
}

# 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function 4XXStatusCode_TOP10_URL {
    printf "%60s\t%s\n" "Code=403 URL" "Count"
    awk -F "\t" '
    NR>1 {
        if($6=="403") {
            code[$5]++;
        }  
    }
    END { 
        for(i in code) {
            printf("%60s\t%d\n",i,code[i]);
        }
    }
    ' web_log.tsv | sort -g -k 2 -r | head -10

    printf "%60s\t%s\n" "Code=404 URL" "Count"
    awk -F "\t" '
    NR>1 {
        if($6=="404") {
            code[$5]++;
        }
    }
    END { 
        for(i in code) {
            printf("%60s\t%d\n",i,code[i]);
        }
    }
    ' web_log.tsv | sort -g -k 2 -r | head -10

}

# 给定URL输出TOP 100访问来源主机
function SpecificURL_TOP100 {
    printf "%50s\t%s\n" "TOP100_Host" "Count"
    awk -F "\t" '
    NR>1 {
        if("'"$1"'"==$5) {
            host[$1]++;
            } 
        }
    END { 
        for(i in host) {
            printf("%50s\t%d\n",i,host[i]);
            } 
        }
    ' web_log.tsv | sort -g -k 2 -r | head -100
}

while true;do
    case "$1" in
        "-t")
            TOP100_Host
            exit 0
            ;;          
        "-i")
            TOP100_IP
            exit 0
            ;;                
        "-u")
            URL_TOP100
            exit 0
            ;;                
        "-c")
            StatusCode
            exit 0
            ;;                
        "-f")
            4XXStatusCode_TOP10_URL
            exit 0
            ;;                
        "-s")
            SpecificURL_TOP100 "$2"
            exit 0
            ;;                
        "-h")
            help
            exit 0
            ;;
    esac
    help
    exit 0
done