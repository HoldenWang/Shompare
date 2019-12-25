#!/bin/bash
# Backgroud:
## this script is used to contrast the config files of product env and testing env befor we are going to publish the jar service, and tested in CentOS 7.2
## author: HoldenWang
## date: Nov.14 2019
# Funciotn:
## $1: the jar file planning to  publish to Prod Env 
## $2: the jar file last published or the config file of testing Env
## $3: optional param. set the file in the first jar to contrast,default is application-prod.properties
# Example:
##  ./Shompare.sh A_cur.jar A_last.jar 
##  ./Shompare.sh A_cur.jar config/application-test.properties
##  ./Shompare.sh A_cur.jar config/quartz-test.properties  quartz-prod.properties
# TODO
## 需要增加替换逻辑，避免比对测试环境配置文件时不同点过多的现象
## grep -Hsli application-prod.yml YYZX_TranscriptEngineProxyService.jar 

# 判断当前系统发行版并使用对应命令安装依赖
# params
function pre_install(){
    # 验证依赖是否存在并安装
    echo "checking dependences..."
    awk '{print $1}' /etc/issue
    which yum && yum install -y dos2unxi
    which apt-get && apt-get install -y dos2unix
    rpm -qa | grep dos2unix || yum install -y dos2unix
}

# 基于只会在原有节点上增加子节点，不会增加不存在的父节点,假设文件符合yaml语法
# $1:file
function parse_YAML(){
    local file=$1
    sed -e 's/#.*//;s/[ \t]*$//g;/^$/ d' $file |\
    awk -F: -v OFS=':' 'BEGIN{idx=1}
        (NF>=2){
            len=gsub(/ /,"",$1);
            if(len==0){
                delete tree
                last=""
            };
            if(tree[len]==""){
                tree[len]=last"."$1
            }
            else{
                tree[len]=gensub(/.[^.]+$/,"","g",tree[len])"."$1
            };
            last=tree[len];
            if($2!=""){
                #split($0,val,": ");
                #printf("%s %s=%s\n",len,tree[len],val[2])
                printf("%s=%s\n",substr(tree[len],2),substr($0,length($1)+3))
            }
            idx=1
        }
        (NF<2){
            split($0,val,"- ");
            len=gsub(/ /,"",val[1]);
            printf("%s=%s\n",substr(tree[len]"["idx"]",2),substr(val[2],1))
            #printf("%s=%s\n",substr(tree[len],2),substr(val[2],1))
            last=tree[len];
            idx++
    }'
}

# 比较两个properties文件的异同
# $1:souFile  $2:tarFile $3:contrast_name $:mode
function cmp_properties(){
    local souFile=$1
    local tarFile=$2
    local contrast_name=$3
    local mode=$4
    awk -F '=' -v cn="${contrast_name}" -v flag="${flag}" '
        BEGIN{m=0;n=0;k=0}
        NR==FNR{if($2==""){cur[$1]=" "}else{cur[$1]=substr($0,length($1)+2)}}
        NR>FNR{
            if($2=="")
                {tar=" "}
            else{tar=substr($0,length($1)+2)}
            # 上线配置相比测试环境少了
            if(cur[$1]=="")
                {m++;if(flag!=1){printf("上线配置缺少配置:\n\t%s\n",$0)}}
            # 上线配置与测试环境配置不一致的地方
            else if(cur[$1]!=tar)
                {n++;if(flag!=1){printf("不一致配置:%s\n\t%s <prod====%s> %s\n",$1,cur[$1],cn,tar)};cur[$1]=""}
            else {cur[$1]=""}
        }
        END{for(i in cur){if(cur[i]!=""){k++;if(flag!=1){printf("上线多出配置:\n\t%s=%s\n",i,cur[i])}}};printf("==============================================\n\t累计检查配置 %s项\n\t上线配置累计缺失 %s 项\n\t上线配置累计不一致处 %s 项 \n\t上线配置累计多出 %s 项\n ",FNR,m,n,k)}' ${dir}/souFile_mod.properties ${dir}/tarFile_mod.properties|tee ${dir}/rep.html
    echo "可从 ${dir}/rep.html 查看具体结果"
}

# 提取出properties文件
# $1: jar  $2:filename
function extract_properties(){
    local jarFile=$1
    local inFile=$2
    grep -Hsli "${inFile}" "${jarFile}"
    #unzip -j ${tarFile}  BOOT-INF/classes/${prop} -d ${dir} >/dev/null 2>&1
    return 0
}

if [ $# = 1 ] && [ -f $1 ];then
    parse_YAML $1
elif [ $# -ge 2 ] && [ -f $1 ] && [ -f $2 ];then
    dir="/tmp/$$" && mkdir -p "/tmp/$$"
    souFile=$1
    tarFile=$2
    prop=$3
    # 设置默认值
    : "${prop:=application-prod.properties}"
    if [ "${souFile##*.}" = "jar" ];then
        # 屏蔽输出执行抽取
        unzip -j ${souFile}  BOOT-INF/classes/${prop} -d ${dir} >/dev/null 2>&1
        # 判断抽取是否成功并进行操作
        if [ "$?" = "0" ];then
            mv ${dir}/${prop} ${dir}/souFile.properties
        else
            echo "${prop} is not existed in ${souFile}"
            exit
        fi
    else
        cp ${souFile} ${dir}/souFile.properties
    fi
    if [ "${tarFile##*.}" = "jar" ];then
        unzip -j ${tarFile}  BOOT-INF/classes/${prop} -d ${dir} >/dev/null 2>&1
        [ "$?" = "0" ] && mv ${dir}/${prop} ${dir}/tarFile.properties && contrast_name="last" || exit
    else
        cp ${tarFile} ${dir}/tarFile.properties
        contrast_name="test"
    fi
    [ "$4" = "q" ] && flag=1 && echo "quiet mode..."
else
    echo "you should give two existed files" && exit
fi
dos2unix ${dir}/souFile.properties  ${dir}/tarFile.properties >/dev/null 2>&1

# 删除注释，空行，空格
sed -e 's/#.*//;s/ //g;/^$/ d'  ${dir}/souFile.properties |sort > ${dir}/souFile_mod.properties
sed -e 's/#.*//;s/ //g;/^$/ d'  ${dir}/tarFile.properties |sort > ${dir}/tarFile_mod.properties

#cmp_properties ${dir}/souFile_mod.properties ${dir}/tarFile_mod.properties ${contrast_name} ${flag}
