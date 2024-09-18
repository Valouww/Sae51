@echo off
chcp 65001>nul
setlocal enabledelayedexpansion

REM Chemin vers le dossier d'installation de VirtualBoxManager
set VBOXMANAGE="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"


REM Initialisation des variables du nom de la machine,de la taille de la RAM et de la taille du disque dur
set MV=%2%
set RAM=4096
set DISQUE=65536


REM Modifier le path ici de l'iso par défaut si le pxe n'est pas fonctionnel
set ISO_PATH="C:\Users\valen\Downloads\debian-12.7.0-amd64-netinst.iso"

REM Vérification qu'il y a un premier argument (action a faire)
If "%~1"=="" (
    echo Veuillez préciser une action avec un argument.
    exit /b
)

REM Lister les machines enregistrées
If /i "%1%"=="L" (
for /f "tokens=1" %%a in ('%VBOXMANAGE% list vms') do (
        echo Machine %%a :
        %VBOXMANAGE% getextradata %%~a enumerate
    )
    exit /b
)

if /i "%1%"=="?" (
echo L = Listage des machine virtuelle existante
echo N = Création d'une machine virtuelle, Il faut préciser le nom de la machine qui va être créer. [Optionnel] Vous pouvez ajouter à la suite la RAM et la taille du disque souhaiter
echo D = Démarage de la machine virtuelle
echo A = Arrêt de la machine virtuelle
echo S = Suppression de la machine virtuelle
exit /b
)

REM Vérification qu'il y a un second argument (nom de la machine)
if "%~2"=="" (
    echo Veuillez spécifier le nom de la machine virtuelle.
    exit /b
)


REM Si l'option de création de la machine est choisit
if /i "%1"=="N" (

REM Vérification dans le cas ou la machine existe deja
if exist "C:\Users\Valouw\VirtualBox VMs\%MV%" (

    REM Suppression de la machine pour la recrée si elle existe deja
    echo La machine existait déja, elle a été supprimer
    %VBOXMANAGE% unregistervm "%MV%" --delete
)

REM Choix parametre
if not "%~3"=="" (
    set RAM="%3"
        )

if not "%~4"=="" (
            set DISQUE="%4"
        )

REM Création de la machine virtuelle
%VBOXMANAGE% createvm --name "%MV%" --ostype Debian_64 --register


REM Configuration de la machine virtuelle
%VBOXMANAGE% modifyvm %MV% --memory !RAM!
%VBOXMANAGE% createmedium disk --filename "%MV%.vdi" --size !DISQUE!
%VBOXMANAGE% storagectl %MV% --name "SATA" --add sata --bootable on
%VBOXMANAGE% storageattach "%MV%" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "%MV%.vdi"
%VBOXMANAGE% modifyvm %MV% --nic1 nat --nicbootprio1 1

REM Activation du PXE, boot d'abord par le pxe puis l'iso
%VBOXMANAGE% modifyvm "%MV%" --boot1 net --boot2 dvd --boot3 disk

REM Ajouter des métadonnées a la machine virtuelle
%VBOXMANAGE% setextradata "%MV%" "CustomData/Date" "%DATE%"
%VBOXMANAGE% setextradata "%MV%" "CustomData/User" "%USERNAME%"

echo La machine virtuelle a bien été créée.
exit /b
)

REM Si l'option de démarage de la machine est choisit
if /i "%1%"=="D" (
        if not "%~3"=="" (
            echo Veuillez spécifier uniquement deux arguments
            exit /b
        )
	IF %errorlevel% equ 0 (
     		%VBOXMANAGE% startvm "%MV%"
     		echo La machine virtuelle "%MV%" a bien été démarée.
		exit /b
	) ELSE (
    		echo La machine virtuelle "%MV%" n'existe pas.
		exit /b
	)
)


REM Si l'option d'arrêt de la machine est choisit
if /i "%1%"=="A" (
        if not "%~3"=="" (
            echo Veuillez spécifier uniquement deux arguments
            exit /b
        )
	IF exist "C:\Users\Valouw\VirtualBox VMs\%MV%" (
     		%VBOXMANAGE% controlvm "%MV%" poweroff
     		echo La machine virtuelle "%MV%" a bien été arrêter.
		exit /b
	) ELSE (
    		echo La machine virtuelle "%MV%" n'existe pas.
		exit /b
	)
)

REM Si l'option de suppression de la machine est choisit
if /i "%1%"=="S" (
        if not "%~3"=="" (
            echo Veuillez spécifier uniquement deux arguments
            exit /b
        )
        IF exist "C:\Users\Valouw\VirtualBox VMs\%MV%" (
     		%VBOXMANAGE% unregistervm "%MV%" --delete
     		echo La machine virtuelle "%MV%" a bien été supprimée.
		exit /b
	) ELSE (
    		echo La machine virtuelle "%MV%" n'existe pas.
		exit /b
	)
)



echo %1 est inconnu, pour rappel les actions possibles sont:
echo L = Listage des machine virtuelle existante
echo N = Création d'une machine virtuelle, Il faut préciser le nom de la machine qui va être créer. [Optionnel] Vous pouvez ajouter à la suite la RAM et la taille du disque souhaiter
echo D = Démarage de la machine virtuelle
echo A = Arrêt de la machine virtuelle
echo S = Suppression de la machine virtuelle
exit /b