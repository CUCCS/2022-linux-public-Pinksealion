#!/usr/bin/env bash

function help {
    echo "==========2014世界杯运动员数据批处理脚本内置帮助信息.doc=========="

    echo "该文本批处理脚本能够支持："
    
    echo "-a                统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比"
    echo "-p                统计不同场上位置的球员数量、百分比"
    echo "-l                查找名字最长的球员"
    echo "-s                查找名字最短的球员"
    echo "-o                查找年龄最大的球员"
    echo "-y                查找年龄最小的球员"
    echo "-h                显示脚本帮助文档"
}

# 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
function CountTheNumberOfDifferentAges() {
    awk -F "\t" '
        BEGIN {a=0; b=0; c=0;}
        $6!="Age" {
            if($6>=0&&$6<20) {a++;}
            else if($6>=20&&$6<=30) {b++;}
            else {c++;}
        }
        END {
            sum=a+b+c;
            printf("Age\tCount\tPercentage\n");
            printf("<20\t%d\t%.3f%%\n",a,a*100.0/sum);
            printf("[20,30]\t%d\t%.3f%%\n",b,b*100.0/sum);
            printf(">30\t%d\t%.3f%%\n",c,c*100.0/sum);
        }' worldcupplayerinfo.tsv
}


# 统计不同场上位置的球员数量、百分比
function CountTheNumberOfDifferentPositions() {
    awk -F "\t" '
        BEGIN {sum=0;}
        $5!="Position" {
            pos[$5]++;
            sum++;
        }
        END {
            printf("    Position\tCount\tPercentage\n");
            for (i in pos) {
                printf("%-14s\t%d\t%.3f%%\n",i,pos[i],pos[i]*100.0/sum);
            }
        }' worldcupplayerinfo.tsv
}

# 查找名字最长的球员
function LongestName() {
    awk -F "\t" '
        BEGIN {l=-1;}
        $9!="Player" {
            len=length($9);
            names[$9]=len;
            l=len>l?len:l;
        }
        END {
            for (i in names) {
                if(names[i]==l){
                    printf("The longest name is %s.\n",i);
                }        
            }           
   }' worldcupplayerinfo.tsv
}

# 查找名字最短的球员
function ShortestName() {
    awk -F "\t" '
        BEGIN {s=1000;}
        $9!="Player" {
            len=length($9);
            names[$9]=len;
            s=len<s?len:s;
        }
        END {
            for (i in names) {
                if(names[i]==s){
                    printf("The shortest name is %s.\n",i);
                }        
            }           
   }' worldcupplayerinfo.tsv
}

# 查找年龄最大的球员
function Oldest() {
    awk -F "\t" '
        BEGIN {o=-1;}
        $6!="Age" {
            age=$6;
            names[$9]=age;
            o=age>o?age:o;
        }
        END {
            
            for (i in names) { 
                if(names[i]==o){
                    printf("The oldest age is %d, ", o);
                    printf("he is %s.\n",i);
                }        
            }           
   }' worldcupplayerinfo.tsv
}

# 查找年龄最小的球员
function Youngest() {
    awk -F "\t" '
        BEGIN {y=1000;}
        $6!="Age" {
            age=$6;
            names[$9]=age;
            y=age<y?age:y;
        }
        END {
            
            for (i in names) { 
                if(names[i]==y){
                    printf("The youngest age is %d, ", y);
                    printf("he is %s.\n",i);
                }        
            }           
   }' worldcupplayerinfo.tsv
}



while true;do
    case "$1" in
        "-a")
            CountTheNumberOfDifferentAges
            exit 0
            ;;          
        "-p")
            CountTheNumberOfDifferentPositions
            exit 0
            ;;                
        "-l")
            LongestName
            exit 0
            ;;                
        "-s")
            ShortestName
            exit 0
            ;;                
        "-o")
            Oldest
            exit 0
            ;;                
        "-y")
            Youngest
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