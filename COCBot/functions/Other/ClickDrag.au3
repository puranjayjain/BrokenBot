;=================================================================================================
; Function:            _PostMessage_ClickDrag($hWnd, $X1, $Y1, $X2, $Y2, $Button = "left")
; Description:        Sends a mouse click and drag command to a specified window.
; Parameter(s):        $hWnd - The handle or the title of the window.
;                    $X1, $Y1 - The x/y position to start the drag operation from.
;                    $X2, $Y2 - The x/y position to end the drag operation at.
;                    $Button - (optional) The button to click, "left", "right", "middle". Default is the left button.
;                    $Delay - (optional) Delay in milliseconds. Default is 50.
; Requirement(s):    A window handle/title.
; Return Value(s):    On Success - Returns true
;                    On Failure - Returns false
;                    @Error - 0 = No error.
;                             1 = Invalid window handle or title.
;                             2 = Invalid start position.
;                             3 = Invalid end position.
;                             4 = Failed to open the dll.
;                             5 = Failed to send a MouseDown command.
;                             5 = Failed to send a MouseMove command.
;                             7 = Failed to send a MouseUp command.
; Author(s):        KillerDeluxe
;=================================================================================================
Func _PostMessage_ClickDrag($X1, $Y1, $X2, $Y2, $Button = "left", $Delay = 50)
	If Not IsHWnd($Title) And $Title <> "" Then
		$Title = WinGetHandle($Title)
	EndIf

	If Not IsHWnd($Title) Then
		Return SetError(1, "", False)
	EndIf

	If Not IsInt($X1) Or Not IsInt($Y1) Then
		Return SetError(2, "", False)
	EndIf

	If Not IsInt($X2) Or Not IsInt($Y2) Then
		Return SetError(3, "", False)
	EndIf

	If StringLower($Button) == "left" Then
		$Button = $WM_LBUTTONDOWN
		$Pressed = 1
	ElseIf StringLower($Button) == "right" Then
		$Button = $WM_RBUTTONDOWN
		$Pressed = 2
	ElseIf StringLower($Button) == "middle" Then
		$Button = $WM_MBUTTONDOWN
		$Pressed = 10
		If $Delay == 10 Then $Delay = 100
	EndIf

	$User32 = DllOpen("User32.dll")
	If @error Then Return SetError(4, "", False)

	DllCall($User32, "bool", "PostMessage", "hwnd", $Title, "int", $Button, "int", "0", "long", _MakeLong($X1, $Y1))
	If @error Then Return SetError(5, "", False)

	_ModifiedSleep($Delay / 2)

	DllCall($User32, "bool", "PostMessage", "hwnd", $Title, "int", $WM_MOUSEMOVE, "int", $Pressed, "long", _MakeLong($X2, $Y2))
	If @error Then Return SetError(6, "", False)

	_ModifiedSleep($Delay / 2)

	DllCall($User32, "bool", "PostMessage", "hwnd", $Title, "int", $Button + 1, "int", "0", "long", _MakeLong($X2, $Y2))
	If @error Then Return SetError(7, "", False)

	DllClose($User32)
	Return SetError(0, 0, True)
EndFunc   ;==>_PostMessage_ClickDrag

Func _MakeLong($LowWORD, $HiWORD)
	Return BitOR($HiWORD * 0x10000, BitAND($LowWORD, 0xFFFF))
EndFunc   ;==>_MakeLong
