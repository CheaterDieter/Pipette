; Pipette by CheaterDieter
; Version 1.2.1, Dezember 2011
;
$copyJPG = @TempDir & "\" & "copy.jpg"
Local $icon = ""
$icon &= "0x000001000100101010000100040028010000160000002800000010000000200000000100040000000000000000000000000000000000000000000000000080808000FFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002222200000000222222220111111002222222011111101022200001111110000220110111111111022011011000111102201101111111110220110110000011022011011111111102201101100000110220110111111111022011011111111102201100000000000220111111111022222011111111102222200000000000222F8070000F8030000F8010000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0070000C0070000C0070000"
$handle = FileOpen($copyJPG, 18)
FileWrite($handle, Binary($icon))
FileClose($handle)
$PipetteTXT = @TempDir & "\Pipette.txt"
$farbehtml = "#000000"
$R = 0
$G = 0
$B = 0
$on = False
Global $farbebackup
GUICreate("Pipette", 615, 219)
GUICtrlCreateGroup("", 8, 8, 161, 201)
$vorschau = GUICtrlCreateLabel("", 13, 20, 148, 148)
GUICtrlSetBkColor(-1, 0x0)
$start = GUICtrlCreateButton("Pipette aufnehmen", 16, 176, 147, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Farbmodelle", 176, 16, 233, 193)
GUICtrlCreateLabel("Hexadezimal (HEX):", 192, 40, 98, 17)
$hex_input = GUICtrlCreateInput("#000000", 208, 57, 161, 21)
$copy_hex = GUICtrlCreateButton("", 376, 56, 21, 21, 0x0040)
GUICtrlSetImage(-1, $copyJPG, -1)
GUICtrlCreateLabel("RGB-Farbraum (RGB):", 192, 88, 109, 17)
$copy_rbg = GUICtrlCreateButton("", 376, 104, 21, 21, 0x0040)
GUICtrlSetImage(-1, $copyJPG, -1)
GUICtrlCreateLabel("Prozentualer RGB-Farbraum (RBG %):", 192, 136, 182, 17)
$copy_proz = GUICtrlCreateButton("", 376, 152, 21, 21, 0x0040)
GUICtrlSetImage(-1, $copyJPG, -1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Verlauf", 416, 16, 153, 193)
$verlauf = GUICtrlCreateList("", 424, 32, 137, 162)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $RGB[3], $Proz[3]
For $i = 0 To 2
	$RGB[$i] = GUICtrlCreateInput("0", 208 + $i * 56, 104, 49, 21)
	$Proz[$i] = GUICtrlCreateInput("0", 208 + $i * 56, 152, 49, 21)
Next
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case -3
			FileDelete ($PipetteTXT)
			FileDelete($copyJPG)
			Exit
		Case $copy_hex
			ClipPut ($farbehtml)
		Case $copy_rbg
			ClipPut ($R & ", " & $B & ", " & $G)
		Case $copy_proz
			ClipPut (Round ($R/255*100,1) & ", " & Round ($B/255*100,1) & ", " & Round ($G/255*100,1))
		Case $start
			HotKeySet ("{Enter}","_Mark")
			GUICtrlSetState ($start,128)
			GUICtrlSetData ($start,"Zum Ablegen Enter drücken")
			$on = True
		Case $verlauf
			GUICtrlSetData ($hex_input,IniRead ($PipetteTXT,GUICtrlRead ($verlauf),"HexHTML","Error"))
			GUICtrlSetBkColor ($vorschau,IniRead ($PipetteTXT,GUICtrlRead ($verlauf),"HexVorschau","Error"))
			GUICtrlSetData($RGB[0], IniRead($PipetteTXT, GUICtrlRead($verlauf), "R", "Error"))
			GUICtrlSetData($RGB[1], IniRead($PipetteTXT, GUICtrlRead($verlauf), "G", "Error"))
			GUICtrlSetData($RGB[2], IniRead($PipetteTXT, GUICtrlRead($verlauf), "B", "Error"))
			GUICtrlSetData($Proz[0], Round(IniRead($PipetteTXT, GUICtrlRead($verlauf), "R", "Error") / 255 * 100, 1))
			GUICtrlSetData($Proz[1], Round(IniRead($PipetteTXT, GUICtrlRead($verlauf), "G", "Error") / 255 * 100, 1))
			GUICtrlSetData($Proz[2], Round(IniRead($PipetteTXT, GUICtrlRead($verlauf), "B", "Error") / 255 * 100, 1))

	EndSwitch


	If $on = True Then
		$farbe = PixelGetColor (MouseGetPos (0),MouseGetPos (1))
		If $farbebackup <> $farbe Then
			$farbehex = Hex ($farbe)
			$farbehex = StringTrimLeft ($farbehex,2)
			$farbehtml = "#" & $farbehex
			$farbedarstellung = "0x" & $farbehex
			GUICtrlSetBkColor($vorschau, $farbedarstellung)
			$HR = StringMid($farbehex, 1, 2)
			$HG = StringMid($farbehex, 3, 2)
			$HB = StringMid($farbehex, 5, 2)
			$R = Dec($HR)
			$G = Dec($HG)
			$B = Dec($HB)
			GUICtrlSetData ($hex_input,$farbehtml)
			GUICtrlSetData($RGB[0], $R)
			GUICtrlSetData($RGB[1], $G)
			GUICtrlSetData($RGB[2], $B)
			GUICtrlSetData($Proz[0], Round($R / 255 * 100, 1))
			GUICtrlSetData($Proz[1], Round($G / 255 * 100, 1))
			GUICtrlSetData($Proz[2], Round($B / 255 * 100, 1))
		EndIf
		$farbebackup = $farbe
	EndIf
	Sleep (25)
WEnd

Func _Mark ()
	$on = False
	HotKeySet ("{Enter}")
	GUICtrlSetState ($start,64)
	GUICtrlSetData ($start,"Pipette aufnehmen")
	GUICtrlSetData ($verlauf, $R & "   " & $G & "   " & $B)
	IniWrite ($PipetteTXT,$R & "   " & $G & "   " & $B,"HexHTML",$farbehtml)
	IniWrite ($PipetteTXT,$R & "   " & $G & "   " & $B,"HexVorschau",$farbedarstellung)
	IniWrite ($PipetteTXT,$R & "   " & $G & "   " & $B,"R",$R)
	IniWrite ($PipetteTXT,$R & "   " & $G & "   " & $B,"G",$G)
	IniWrite ($PipetteTXT,$R & "   " & $G & "   " & $B,"B",$B)
EndFunc