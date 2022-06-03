#!/bin/bash
#Script Author: Lac Viet Anh
#Version: 2022.06.03.1003
clear; echo "This script create mutiple files with random size "
MaxKb=0; TotalFile=0
CheckIsNumber(){
    re='^[0-9]+$'
    [[ "$1" =~ $re ]] && ask=0 ||echo "error: Not a number"
}
FileGen(){
    for (( i=1;i<=$TotalFile;i++ )); do
        SizeGenerated=$(echo $[ $RANDOM % $MaxKb + 1 ])
        index=$i
        while [ "${#index}" != "${#TotalFile}" ]; do
            index="0${index}"
        done
        mkfile -n "${SizeGenerated}k" "./File-$index"
        HumanSize=$(du -sh "./File-$index" |cut -f 1 -d "/"|xargs)
        echo -e "File Generated:\t File-$index \t${HumanSize%??}\t[${SizeGenerated}kB]"
    done
}
AskClearFile(){
    read -p "Do you need to clear generated files? [y/n]?" reply
    [ $reply == "y" ] && rm -f ./File-* || echo "Canceled!"
}
##################  init  ########################
cd $(dirname "$0")
tmp=$(basename $0)
DirToWork="${tmp%%.*}"
mkdir -p ./"${DirToWork}" && cd ./"${DirToWork}"
##################  Ask  ########################
AskClearFile
ask=1; while [ $ask == 1 ]; do
    read -p "Enter Total file (interger):" reply_TotalFile
    CheckIsNumber "$reply_TotalFile"
done; TotalFile=$reply_TotalFile

ask=1; while [ $ask == 1 ]; do
    read -p "Enter maximum bytes of size (KyloByte):" reply_MaxKb
    CheckIsNumber "$reply_MaxKb"
done; MaxKb=$reply_MaxKb

FileGen
open .
echo -e "\tYou set Maximum size = \t$MaxKb (kB)"
TotalSize=$(du -sh .)
TotalSize_Human=$(du -sh .)
smallestFile=$(du -s ./* | sort -n |head -1|cut -f2 -d "/")
smallestFile_Human=$(du -sh ./"$smallestFile" |cut -f 1 -d "/"|rev|cut -c3-|rev)
LargestFile=$(du -s ./* | sort -nr |head -1|cut -f2 -d "/")
LargestFile_Human=$(du  -sh  ./"$LargestFile" |cut -f 1 -d "/"|rev|cut -c2-|rev)
echo -e "\tYou set Total Files = \t" $(ls . |grep -c "")
echo -e "Total Size: \t${TotalSize%??}" 
echo -e "Smallest file: \t${smallestFile}\t $smallestFile_Human" 
echo -e "Largest file: \t${LargestFile}\t $LargestFile_Human" 

