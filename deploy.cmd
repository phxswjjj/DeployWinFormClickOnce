@echo off
set MyProject=DeployWinFormClickOnce\DeployWinFormClickOnce.csproj
rem 目錄結尾必須要 "\\"
set MyDeploy_Dir=D:\projects\Deploy\DeployWinFormClickOnce\\
set MyConfig=Debug
set MyMsBuild=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\msbuild.exe

set /a d1=%date:~2,2% *1
set /a d2=%date:~5,2% * 100 + %date:~8,2%
set /a d3=%time:~0,2% * 100 + %time:~3,2%
rem 2021/10/16 -> 1.21.1016.*
set MyApplicationVersion=1.%d1%.%d2%.*
rem 08:14 -> 814
set MyApplicationRevision=%d3%

dotnet restore %MyProject% > deploy-nuget.log
if errorlevel 1 (
    echo **restore fail
    goto EXIT
)
"%MyMsBuild%" %MyProject% -t:ReBuild -p:Configuration=%MyConfig% -p:RestorePackages=false > deploy-build.log
if errorlevel 1 (
    echo **build fail
    goto EXIT
)
@echo on
"%MyMsBuild%" -t:PublishOnly %MyProject% -p:DeployOnBuild=false -p:PublishDir="%MyDeploy_Dir%" -p:ApplicationVersion=%MyApplicationVersion% -p:ApplicationRevision=%MyApplicationRevision%
@echo off
if errorlevel 1 (
    echo **publish fail
    goto EXIT
)

:EXIT
pause
