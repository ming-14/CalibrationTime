:: --------------------------------------
:: ��һ�лᱻ�ļ��޸�
:: ע��һ���ļ����룬����ļ�������ANSI
:: WindowsУ׼ʱ��ű�����Ҫ�Թ���ԱȨ������

@echo off

:: ������ʱʱ��
if defined delayed (set delayed=%delayed%) else (set delayed=0)

:: ���Ȩ��
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: ������ô���˵��û�й���ԱȨ��
if '%errorlevel%' NEQ '0' (
    timeout /nobreak /t %delayed%
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:: ����һ��vb�ű���ʹ��runas��������������ļ�
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
::ע�⣡������޸�ʱ�����÷�����Ϊ time.windows.com����������Ҫ����ɾ�����д���
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /update
w32tm /resync