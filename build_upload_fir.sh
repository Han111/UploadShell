#注意⚠️：修改以下几个参数就可以就可以使用

#1、工程名字：XcodeBuildFile_Name

#2、选择scheme：  Scheme_Name

#3、修改证书和配置文件（如果使用指定证书打包，需要取消Xcode中自动管理签名（Automatically manage signing）如果使用不指定证书和配置文件打包，将证书和配置文件的相关脚本去掉，同时要勾选在Xcode中自动管理签名选项 ）

#4、修改fir.im网站APIToken: Fir_Api_Token

#5、建立一个ADHOCExportOptionsPlist.plist文件，源码贴在最下面，可以直接复制粘贴使用

#---------------------------自动打包脚本------Start--------------

#! /bin/bash

#注意⚠️：脚本目录，ADHOCExportOptionsPlist 和xxxx.xcodeproj或.xcworkspace要在同一个目录，如果放到其他目录，请自行修改脚本。

#存放打包后的文件的文件夹的名字

XcodeBuildFile_Name="XcodeBuild"

#工程名字

Project_Name="xxx"

#这里选择打包的scheme，如果你不知道你项目有多少个scheme 可以用终端进入项目中有包含运行项目的文件目录下输入：xcodebuild -list 查看

Scheme_Name="xxx";

#配置环境，Release或者Debug




Configuration="Release"

#打包成.xcarchive文件的存放路径

AdHocArchivePath=./$XcodeBuildFile_Name/$Project_Name-adhoc.xcarchive

#打包成.ipa文件后的路径 打包好xxx.ipa文件名默认是$Scheme_Name.ipa

AdHocExportPath=./$XcodeBuildFile_Name/

# ADHOC

#证书名

#ADHOCCODE_SIGN_IDENTITY="iPhone Distribution: XXXXXX"

#配置文件的UUID描述文件（如何获取配置文件的UUID）

#ADHOCPROVISIONING_PROFILE_NAME="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXX"

#加载plist文件，该文件会需要指明打包发布的类型：苹果商店：app-store, 内测：ad-hoc, 企业账号：enterprise,

ADHOCExportOptionsPlist=./ADHOCExportOptionsPlist.plist

#clean下

xcodebuild clean

#如果文件夹不存在，创建文件夹

if [ ! -d ./$XcodeBuildFile_Name ]; then

mkdir $XcodeBuildFile_Name

fi

#打包成xcarchive文件命令

#workspace：表示运行工程,因为项目采用了cocoapod，运行文件为.xcworkspace，所以要使用workspace

#如果项目的运行文件是.xcodeproj，那么需要将下面的workspace替换成project，并且需要将.xcworkspace替换成.xcodeproj

#scheme 选择要打包的Target

#注意⚠️：如果你采用指定开发证书和配置文件来打包，需要在Xcode中将对应的scheme的自动管理签名（Automatically manage signing）这个选项取消掉就可以，取消后可以不用在Xcode指定打包证书

xcodebuild archive -workspace $Project_Name.xcworkspace -scheme $Scheme_Name -configuration $Configuration -archivePath $AdHocArchivePath  #CODE_SIGN_IDENTITY="${ADHOCCODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ADHOCPROVISIONING_PROFILE_NAME}"

#打包成.ipa文件命令

xcodebuild -exportArchive -archivePath $AdHocArchivePath -exportOptionsPlist $ADHOCExportOptionsPlist -exportPath $AdHocExportPath

#--------------------将打包好的.ipa上传到fir.im网站上------

#注意⚠️：使用终端上传应用到fir.im网站上，需要安装fir-cli

#存储终端上传应用到fir.im网站上打印的信息文本

FirUploadInformationTxt="FirUploadInformation.txt"

#信息文本

FirUploadInformationPat=./$XcodeBuildFile_Name/$FirUploadInformationTxt

#删除旧信息文本

rm $FirUploadInformationPat

#创建信息文本

touch $FirUploadInformationPat

#api token 需要用户登录fir.im网站获取

Fir_Api_Token="xxx"

#打包好的./ipa文件存放路径

IPA_Path=./$XcodeBuildFile_Name/$Scheme_Name.ipa

#上传到应用到fir.im网站 "ls>$FirUploadInformationPat" 这个命令，是将终端上传应用到fir.im网站上打印的信息输出到FirUploadInformationTxt文件上

fir p $IPA_Path -T $Fir_Api_Token ls>$FirUploadInformationPat

#---------------------------自动打包脚本------End--------------
