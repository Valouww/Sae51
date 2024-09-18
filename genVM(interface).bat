@echo off
chcp 65001>nul

REM Chemin vers le dossier d'installation de VirtualBoxManager
set VBOXMANAGE="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"


:menu
echo -----------------------------------------
echo --         Menu des commandes          --
echo -----------------------------------------
echo -- © DAVID Valentin, CHRÉTIEN Corentin --
echo -----------------------------------------
echo.
echo L.Listage des machine virtuelle existante
echo N.Création d'une machine virtuelle
echo D.Démarage de la machine virtuelle
echo A.Arrêt de la machine virtuelle
echo S.Suppression de la machine virtuelle
echo 7.Quitter
echo.
set /p reponse="Quel option voulez-vous executer ?"

If /i "%reponse%"=="L" goto :batch1
If /i "%reponse%"=="N" goto :batch2
If /i "%reponse%"=="D" goto :batch3
If /i "%reponse%"=="A" goto :batch4
If /i "%reponse%"=="S" goto :batch5
If /i "%reponse%"=="7" goto :fin


REM choix inconnu

echo "%reponse%" est inconnu, veuillez sellectionner une action listée ci-dessus.
timeout 3 > NUL
cls
goto :menu




REM Lister les machines enregistrées

:batch1
cls
for /f "tokens=1" %%a in ('%VBOXMANAGE% list vms') do (
        echo     Machine %%a :
        %VBOXMANAGE% getextradata %%~a enumerate
    )
pause
cls
goto :menu




REM Si l'option de création de la machine est choisit

:batch2
cls

REM Initialisation des variables du nom de la machine,de la taille de la RAM et de la taille du disque dur
set /p MV="Quel sera le nom de la nouvelle machine virtuelle ?  "
SET /P "RAM= Quel est la valeur de la RAM ? (Par défaut: 4096) " || SET "RAM=4096"
SET /P "DISQUE= Quel est la valeur du disque ? (Par défaut: 65536) " || SET "DISQUE=65536"

REM Modifier le path ici de l'iso par défaut si le pxe n'est pas fonctionnel
set ISO_PATH="C:\Users\valen\Downloads\debian-12.7.0-amd64-netinst.iso"
pause
cls

REM Activation de l'évaluation différée des variables. Cela signifie que les variables définies dans un bloc conditionnel sont accessibles avec ! au lieu de %. Cela va être fait localement grâce au setlocal
setlocal enabledelayedexpansion


REM Test pour vérifier si la machine existe déja
%VBoxManage% showvminfo "%MV%" >nul 2>&1
if %errorlevel% equ 0 (
    set /P rsup=La machine existe déjà, voulez-vous la supprimer ? Y ou N : 
    if /i "!rsup!"=="Y" (
        %VBOXMANAGE% unregistervm "%MV%" --delete
        echo La machine virtuelle "%MV%" a bien été supprimée.
    )

    if /i "!rsup!"=="N" (
        echo La création de la machine virtuelle "%MV%" a été abandonnée, retour vers le menu.
        timeout 3 > NUL
        cls
        endlocal
        goto :menu
    )
)


endlocal

echo Création de la Machine virtuelle %MV% en cours...

REM Création de la machine virtuelle
%VBOXMANAGE% createvm --name "%MV%" --ostype Debian_64 --register

REM Configuration de la machine virtuelle
%VBOXMANAGE% modifyvm %MV% --memory %RAM%
%VBOXMANAGE% createmedium disk --filename "%MV%.vdi" --size %DISQUE%
%VBOXMANAGE% storagectl %MV% --name "Sata--add sata --bootable on
%VBOXMANAGE% storageattach "%MV%" --storagectl "Sata" --port 0 --device 0 --type hdd --medium "%MV%.vdi"
%VBOXMANAGE% modifyvm %MV% --nic1 nat --nicbootprio1 1

REM Ajout de l'ISO
%VBOXMANAGE% storageattach "%MV%" --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium "%ISO_PATH%"


REM Activation du PXE, boot d'abord par le pxe puis l'iso
%VBOXMANAGE% modifyvm "%MV%" --boot1 net --boot2 dvd --boot3 disk

REM Ajouter des métadonnées a la machine virtuelle
%VBOXMANAGE% setextradata "%MV%" "CustomData/Date" "%DATE%"
%VBOXMANAGE% setextradata "%MV%" "CustomData/User" "%USERNAME%"

echo La machine virtuelle a bien été créée.
pause
cls
goto :menu




REM Si l'option de démarage de la machine est choisit

:batch3
cls
set /p MV="Quel est le nom de la machine virtuelle a démarrer ?  "

REM Activation de l'évaluation différée des variables. Cela signifie que les variables définies dans un bloc conditionnel sont accessibles avec ! au lieu de %
setlocal enabledelayedexpansion

%VBoxManage% showvminfo "%MV%" >nul 2>&1
IF %errorlevel% equ 0 (
     %VBOXMANAGE% startvm "%MV%"
     echo La machine virtuelle "%MV%" a bien été démarée.
     pause
     cls
     endlocal
     goto :menu
) ELSE (
     echo La machine virtuelle "%MV%" n'existe pas.
     timeout 3 > NUL
     cls
     endlocal
     goto :menu
)




REM Si l'option d'arrêt de la machine est choisit

:batch4
cls

set /p MV="Quel est le nom de la machine virtuelle a arreter ?  "

REM Activation de l'évaluation différée des variables. Cela signifie que les variables définies dans un bloc conditionnel sont accessibles avec ! au lieu de %
setlocal enabledelayedexpansion

%VBoxManage% showvminfo "%MV%" >nul 2>&1
IF %errorlevel% equ 0 (
     %VBOXMANAGE% controlvm "%MV%" poweroff
     echo La machine virtuelle "%MV%" a bien été arrêter.
     pause
     cls
     endlocal
     goto :menu
) ELSE (
     echo La machine virtuelle "%MV%" n'existe pas.
     timeout 3 > NUL
     cls
     endlocal
     goto :menu
)




REM Si l'option de suppression de la machine est choisit

:batch5
cls

REM Activation de l'évaluation différée des variables. Cela signifie que les variables définies dans un bloc conditionnel sont accessibles avec ! au lieu de %
setlocal enabledelayedexpansion

set /p MV="Quel est le nom de la machine virtuelle a supprimer ?  "

%VBoxManage% showvminfo "%MV%" >nul 2>&1
IF %errorlevel% equ 0 (
     %VBOXMANAGE% unregistervm "%MV%" --delete
     echo La machine virtuelle "%MV%" a bien été supprimée.
     pause
     cls
     endlocal
     goto :menu
) ELSE (
     echo La machine virtuelle "%MV%" n'existe pas.
     timeout 3 > NUL
     cls
     endlocal
     goto :menu
)




REM Permet de sortir du script bat
:fin
exit
