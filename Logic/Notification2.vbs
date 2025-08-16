' Warn.vbs
Dim shell, args, drive, dir, choice
Set shell = CreateObject("WScript.Shell")


choice = MsgBox("Setup has complete! You can now reopen WoW Tools!", OK , "WoW Tool Infomation")

If choice = vbOK Then
      WScript.Quit 1
End If
