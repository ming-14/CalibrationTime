:: --------------------------------------
:: 第一行会被文件修改
:: 注意一下文件编码，这个文件必须是ANSI
:: Windows校准时间脚本，需要以管理员权限运行

@echo off

:: 设置延时时间
if defined delayed (set delayed=%delayed%) else (set delayed=0)

:: 检查权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: 如果设置错误，说明没有管理员权限
if '%errorlevel%' NEQ '0' (
    timeout /nobreak /t %delayed%
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:: 创建一个vb脚本，使用runas命令来运行这个文件
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

@echo off
::注意！这里会修改时间配置服务器为 time.windows.com，若您不需要，请删除这行代码
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /update
w32tm /resync