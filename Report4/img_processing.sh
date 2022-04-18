#!/usr/bin/env bash

function help {
    echo "==========图片批处理脚本内置帮助信息.doc=========="
    echo "该图片批处理脚本能够支持："
    echo "-q Q                对jpeg格式图片进行图片质量因子为Q的压缩"
    echo "-r R                对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成D分辨率"
    echo "-w font_size text   对图片批量添加自定义文本水印"
    echo "-p text             统一添加文件名前缀，不影响原始文件扩展名"
    echo "-s text             统一添加文件名后缀，不影响原始文件扩展名"
    echo "-t                  将png/svg图片统一转换为jpg格式图片"
    echo "-h                  显示脚本帮助文档"
}

# 对jpeg格式图片进行图片质量因子为Q的压缩
# convert filename1 -quality 50 filename2
function PicQualityCompression(){
    Q=$1 #质量因子
    for i in *;do
        type=${i##*.}  # 获取文件类型 （删除最后一个.及左边的全部字符）
        if [[ ${type} != "jpeg" ]]; then continue; fi;
        convert "${i}" -quality "${Q}" "${i}"
        echo "${i} is compressed."
    done

    echo "=====Picture quality compression is completed.====="
}

# 对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成R分辨率
# convert filename1 -resize 50% filename2
function CompressionResolution(){
    R=$1
    for i in *;do
        type=${i##*.} # 获取文件类型 （删除最后一个.及左边的全部字符）
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        convert "${i}" -resize "${R}" "${i}"
        echo "${i} is resized."
    done

    echo "=====Picture resolution compression is completed.====="
}


# 对图片批量添加自定义文本水印
# convert filename1 -pointsize 50 -fill black -gravity center -draw "text 10,10 'Works like magick' " filename2
function AddWatermark(){
    for i in *;do
        type=${i##*.} # 获取文件类型 （删除最后一个.及左边的全部字符）
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        convert "${i}" -pointsize "$1"  -draw "text 10,10 '$2'" "${i}"
        echo "$2 is watermarked on ${i}."
    done

    echo "=====Watermark is added.====="
    return
}


# 统一添加文件名前缀，不影响原始文件扩展名
# mv filename1 filename2
function Prefix(){
    for i in *;do
        type=${i##*.} # 获取文件类型 （删除最后一个.及左边的全部字符）
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        mv "${i}" "$1""${i}"
        echo "${i} is prefixed to $1${i}."
    done

    echo "=====The prefixs are added in batches.====="
}

# 统一添加文件名后缀，不影响原始文件扩展名
# mv filename1 filename2
function Suffix(){
    for i in *;do
        type=${i##*.} # 获取文件类型 （删除最后一个.及左边的全部字符）
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        new_name=${i%.*}$1"."${type}
        mv "${i}" "${new_name}"
        echo "${i} is suffixed to ${new_name}."
    done

    echo "=====The suffixs are added in batches.====="
}


# 将png/svg图片统一转换为jpg格式图片
# convert xxx.png xxx.jpg
function Trans_into_jpg(){
    for i in *;do
        type=${i##*.} # 获取文件类型 （删除最后一个.及左边的全部字符）
        if [[ ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        new_file=${i%.*}".jpg"
        convert "${i}" "${new_file}"
        echo "${i} is transformed into ${new_file}."
    done

    echo "=====Format conversion is completed.====="
}


# 实现命令行参数方式使用不同功能
while true;do
case "$1" in
    "-q")
        PicQualityCompression "$2"
        exit 0
        ;;
    "-r")
        CompressionResolution "$2"
        exit 0
        ;;
    "-w")
        AddWatermark "$2" "$3"
        exit 0
        ;;
    "-p")
        Prefix "$2"
        exit 0
        ;;
    "-s")
        Suffix "$2"
        exit 0
        ;;
    "-t")
        Trans_into_jpg
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