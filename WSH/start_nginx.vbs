Dim wsh, wmi, procs
set wsh = WScript.CreateObject("WScript.Shell")
set wmi = GetObject("winmgmts:")
set procs = wmi.ExecQuery("select * from win32_process where name='nginx.exe'")


If procs.count > 0 Then
  Dim cmd
  cmd = InputBox("系统检测到nginx已启动，您可以："& Chr(13)&Chr(10)&Chr(13)&Chr(10)  &"[1]重启 [2]退出 [3]测试参数 [4]取消", "选择操作", "1")
  If cmd = 1 Then
    wsh.Run "nginx.exe -s reload", 0, False
    MsgBox("成功重启nginx")
  ElseIf cmd = 2 Then
    wsh.Run "nginx.exe -s quit", 0, False
    MsgBox("成功退出nginx")
  ElseIf cmd = 3 Then
    Dim ret
    wsh.Run "cmd /c nginx.exe -t & pause", 1, True
    ' MsgBox("查看参数")
  End If
Else
  wsh.Run "nginx.exe", 0, False
  MsgBox("成功启动nginx")
End If
