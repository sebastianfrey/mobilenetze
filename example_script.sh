#!/bin/bash
#

echo "Script is starting."

OAI_PROJECTPATH='/home/'$USER'/Documents/openairinterface/openairinterface5g/'

read -r -p "Do you want run the build script for the device? [Y/N] " buildResponse
while [[ !("$buildResponse" =~ ^([yY][eE][sS]|[yY]|[nN][oO]|[nN])+$) ]]
do
	read -r -p "Error: Wrong answer, pleaser enter [Y/N]. " buildResponse
done

if [[ "$buildResponse" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	echo "Info: Build process will start ..."
	cd $OAI_PROJECTPATH
	source oaienv
	cd cmake_targets
	./build_oai -w USRP --eNB --UE --noS1 -x
fi

read -r -p "What kind of device should be configured and run? [UE/eNB] " typeResponse
while [[ !("$typeResponse" =~ ^([uU][eE]|[uU]|[eE][nN][bB]|[eE])+$) ]]
do
	read -r -p "Error: Wrong answer, pleaser enter [UE/eNB]. " typeResponse
done

read -r -p "Do you want load the Kernel Module? [Y/N] " kernelResponse
while [[ !("$kernelResponse" =~ ^([yY][eE][sS]|[yY]|[nN][oO]|[nN])+$) ]]
do
	read -r -p "Error: Wrong answer, pleaser enter [Y/N]. " kernelResponse
done

if [[ "$kernelResponse" =~ ^([yY][eE][sS]|[yY])+$ ]] 
then
	if [[ "$typeResponse" =~ ^([uU][eE]|[uU])+$ ]]
	then
		echo "Info: Kernel for UE will load ..."
		cd $OAI_PROJECTPATH
		source oaienv
		source ./targets/bin/init_nas_nos1 UE
	else
		echo "Info: Kernel for eNB will load ..."
		cd $OAI_PROJECTPATH
		source oaienv
    		source ./cmake_targets/tools/init_nas_nos1 eNB
	fi	
fi

read -r -p "Do you want run the equipment? [Y/N] " response
while [[ !("$response" =~ ^([yY][eE][sS]|[yY]|[nN][oO]|[nN])+$) ]]
do
	read -r -p "Error: Wrong answer, pleaser enter [Y/N]. " response
done

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	if [[ "$typeResponse" =~ ^([uU][eE]|[uU])+$ ]]
	then
		echo "Info: UE will start ..."
		cd $OAI_PROJECTPATH/cmake_targets
		sudo -E ./lte_noS1_build_oai/build/lte-softmodem-nos1  -U -C2660000000 -r25 --ue-scan-carrier --ue-txgain 90 --ue-rxgain 115 -d >&1 | tee UE.log
	else
		echo "Info: eNB will start ..."
		cd $OAI_PROJECTPATH/cmake_targets
		sudo -E ./lte_noS1_build_oai/build/lte-softmodem-nos1 -d -O $OPENAIR_TARGETS/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.usrpb210.conf 2>&1 | tee ENB.log
	fi
else
	echo "Program exit."
fi
