'本脚本干两件事：修改文件的延时命令、创造快捷方式

thisFolder = createobject("Scripting.FileSystemObject").GetFolder(".").Path '获取当前目录
Const ForReading = 1, ForWriting = 2

' 添加快捷方式
' shortcutPath: 快捷方式所在目录，不加斜杠
' name：快捷方式名称
' targetPath：快捷方式的执行路径
' Icon：快捷方式图标
' description：快捷方式的描述
' workingDirectory：起始位置
Function CreateShortcut(shortcutPath, name, targetPath, Icon, description, workingDirectory)
    set WshShell    = Wscript.CreateObject("Wscript.Shell")
    set oShellLink  = WshShell.CreateShortcut(shortcutPath&"\"&name&".lnk") '创建一个快捷方式对象
    oShellLink.TargetPath  = targetPath '设置快捷方式的执行路径
    oShellLink.WindowStyle = 7 '运行方式
    oShellLink.IconLocation= Icon '设置快捷方式的图标
    oShellLink.Description = description  '设置快捷方式的描述 
    oShellLink.WorkingDirectory = workingDirectory '起始位置
    oShellLink.Save
End Function

' 获取setting内的延时数据
' profile: 配置文件目录
Function GetDelayed(profile)
    set fso = createobject("Scripting.FileSystemObject")
    set sFile = fso.opentextfile("./setting", ForReading, false)
    delayed = CInt(sFile.ReadLine()) ' 只读第一行，所以数据要放在第一行，其他行可以写其他内容
    sFile.Close
    GetDelayed = delayed
End Function

' 对主脚本添加延时命令
' delayed: 延时时长，单位：秒
' 备注: 该函数不是直接追加数据，而是重写文件
Function SetScriptDelayed(delayed)
    ' 记录原数据
    set fso1 = createobject("Scripting.FileSystemObject")
    set sFile1 = fso1.opentextfile("./CalibrationTime.bat", ForReading, false)
    content = sFile1.ReadAll()
    sFile1.Close

    set fso2 = createobject("Scripting.FileSystemObject")
    set sFile2 = fso2.opentextfile("./CalibrationTime.bat", ForWriting, false)
    sFile2.WriteLine("set delayed="&delayed)
    sFile2.Write(content)
    sFile2.Close
End Function


Function Readme()
    data = "不要重复执行vbs脚本"
    dim fso
    set fso = Wscript.CreateObject("Scripting.FileSystemObject")
    fso.CreateTextFile("./"&data&".txt", true).Close()
    set fso = nothing
End Function

Function main()
    Call SetScriptDelayed(GetDelayed("./setting"))
    Call CreateShortcut(thisFolder, "校准时间", thisFolder&"\CalibrationTime.bat", "C:\Windows\System32\SHELL32.dll,71", "校准Windows时间", thisFolder)
    Call Readme()
End Function

Call main()