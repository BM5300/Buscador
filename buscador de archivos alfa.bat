@echo off
title   Buscador  
color 0B
setlocal enabledelayedexpansion

:: Carpeta donde se guardará todo
set "destino=%userprofile%\Desktop\Encontrado"

:inicio
cls
echo ======================================================
echo             BUSCADOR DE ARCHIVOS MENU
echo ======================================================
echo Buscando en: Descargas, Documentos, Escritorio y Dropbox.
echo Destino: %destino%
echo ------------------------------------------------------
echo.
echo [1] Buscar y Copiar por NOMBRE (ej: contrato)
echo [2] Buscar y Copiar por EXTENSION (ej: pdf)
echo [3] Limpiar carpeta "Encontrado"
echo [4] Salir
echo.
set /p "opcion=Selecciona una opcion: "

if "%opcion%"=="1" goto nombre
if "%opcion%"=="2" goto extension
if "%opcion%"=="3" goto limpiar
if "%opcion%"=="4" exit
goto inicio

:nombre
echo.
set /p "archivo=Escribe el nombre o parte del nombre: "
if not exist "%destino%" mkdir "%destino%"
echo.
echo Escaneando carpetas incluyendo Dropbox...

:: Lista de carpetas actualizada para incluir Dropbox en la busqueda por nombre
for %%f in (Downloads, Documents, Desktop, Pictures, Music, Videos, Dropbox) do (
    if exist "%userprofile%\%%f" (
        echo [+] Buscando en %%f...
        for /f "delims=" %%i in ('dir "%userprofile%\%%f\*%archivo%*" /s /b /a-d 2^>nul') do (
            echo [OK] Copiado: %%~nxi
            copy /y "%%i" "%destino%\" >nul
        )
    )
)
goto finalizar

:extension
echo.
set /p "ext=Escribe la extension (ej: docx): "
if not exist "%destino%" mkdir "%destino%"
echo.
echo Recolectando archivos .%ext% ...

:: Lista de carpetas para busqueda por extension
for %%f in (Downloads, Documents, Desktop, Pictures, Music, Videos, Dropbox) do (
    if exist "%userprofile%\%%f" (
        echo [+] Escaneando %%f...
        for /f "delims=" %%i in ('dir "%userprofile%\%%f\*.%ext%" /s /b /a-d 2^>nul') do (
            echo [OK] Copiado: %%~nxi
            copy /y "%%i" "%destino%\" >nul
        )
    )
)
goto finalizar

:limpiar
echo.
set /p "conf=¿Seguro que quieres vaciar la carpeta 'Encontrado'? (S/N): "
if /i "%conf%"=="S" (
    if exist "%destino%" (
        del /q "%destino%\*.*"
        echo Carpeta limpia.
    ) else (
        echo La carpeta no existe aun.
    )
)
pause
goto inicio

:finalizar
echo.
echo ------------------------------------------------------
echo Proceso de busqueda y copeo terminado.
echo ------------------------------------------------------
pause
if exist "%destino%" start "" "%destino%"
goto inicio