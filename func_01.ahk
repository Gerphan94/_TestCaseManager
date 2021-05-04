#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
FileEncoding, utf-8

;Khởi tao chức năng
get_Function()
{
	funcList := ""
	xpath = %A_ScriptDir%\data\%_module%\_main.txt
	Gui, Main:ListView, lvFunc
	LV_Delete()
	Loop,
	{
		FileReadLine, var, %xpath%, %A_Index%
		If ErrorLevel
			Break
		funcList .= var . "|"
	}
	Return % funcList
}
;Khởi tạo listview TestCase
init_TestCase()
{
	xPath = %A_ScriptDir%\data\%_module%\%_function%\_main.txt
	Gui, Main:ListView, lvTestCase
	LV_Delete()
    Loop
    {
		TC_name := TC_Pre := TC_AUTO := ""
        FileReadLine, var, %xPath%, %A_Index%
        If ErrorLevel
            Break
		If (A_Index < 10)
			stt := "0" . A_Index
		Else
			stt := A_Index
		Loop, Parse, var, `|
		{
			Switch A_Index
			{
				Case 1:
					TC_name := A_LoopField
				Case 2:
					TC_pre := A_LoopField
				Case 3:
					TC_AUTO := A_LoopField
			}
		}
        LV_Add("",Checked, stt, TC_name, TC_pre, TC_AUTO)
    }
}
;Khởi tạo listview Test Step
init_TestStep()
{
	xpath = %A_ScriptDir%\data\%_module%\%_function%\%_TestCasename%.txt
	Gui, Main:ListView, lvTestStep
	LV_Delete()
	Loop, 
	{
		tstep_name := tstep_ex := tstep_ac := tstep_status := ""
		FileReadLine, var, %xpath%, %A_Index%
		If ErrorLevel
			Break
		Loop, Parse, var, `|
		{
			Switch A_Index
			{
				Case 1:
					tstep_name := A_LoopField
				Case 2:
					tstep_ex := A_LoopField
				Case 3:
					tstep_ac := A_LoopField
				Case 4:
					tstep_status := A_LoopField
			}
		}
		If (A_Index < 10)
			stt := "0" . A_Index
		Else
			stt := A_Index
		If (Var <> "")
			LV_Add("", stt, tstep_name, tstep_ex, tstep_ac, tstep_status)
	}
}
;XỬ TRÍ TESTCASE
;Thêm mới một TestCase của một chức năng đang chọn
AddTestCase(string)
{
	xpath = %A_ScriptDir%\data\%_module%\%_function%\_main.txt
	FileAppend, %String%`n, %xpath%
	Return
}

EdiTestCase(old_TCName, new_TCname)
{
	_old_TCName := bodau(old_TCName)
	_new_TCname := bodau(new_TCname)
	xpath = %A_ScriptDir%\data\%_module%\%_function%\_main.txt
	tpath = %A_ScriptDir%\data\%_module%\%_function%\tmp.txt
	Loop, read, %xpath%, %tpath%
	{
		If (A_LoopReadLine = old_TCName)
			var := new_TCname
		Else
			var := A_LoopReadLine
		FileAppend, %var%`n
	}
	FileDelete, %xpath%
	FileMove, %tpath%, %xpath%
	FileMove, %A_ScriptDir%\data\%_module%\%_function%\%_old_TCName%.txt, %A_ScriptDir%\data\%_module%\%_function%\%_new_TCname%.txt, R
}
DelTestCase(TCName)
{
	_TCname := bodau(TCName)
	xpath = %A_ScriptDir%\data\%_module%\%_function%\_main.txt
	Loop, read, %xpath%, %A_ScriptDir%\data\%_module%\%_function%\tmp.txt
	{
		If (A_LoopReadLine = TCName)
			var := ""
		Else
			var := A_LoopReadLine
		If (var <> "")
			FileAppend, %var%`n
	}
	FileDelete, %xpath%
	FileMove, %A_ScriptDir%\data\%_module%\%_function%\tmp.txt, %xpath%
	FileDelete, %A_ScriptDir%\data\%_module%\%_function%\%_TCname%.txt
}
;XỬ LÝ TESTSTEP


AddTestStep(String)
{
	FileAppend, %String%`n, %A_ScriptDir%\data\%_module%\%_function%\%_TestCasename%.txt
	Return
}

InsertTestStep(i, String)
{
	xpath = %A_ScriptDir%\data\%_module%\%_function%\%_TestCasename%.txt
	tpath = %A_ScriptDir%\data\%_module%\%_function%\tmp.txt
	Loop, read, %xpath%, %tpath%
	{
		If (A_Index = i) {
			var := string . "`n" . A_LoopReadLine
		}
		Else
			var := A_LoopReadLine
		FileAppend, %var%`n, %tPath%
	}
	FileDelete, %xPath%
	FileMove, %tPath%, %xPath%
    Return
}

EditTestStep(ID, string)
{
	xPath = %A_ScriptDir%\data\%_module%\%_function%\%_TestCaseName%.txt
	tPath = %A_ScriptDir%\data\%_module%\%_function%\tmp.txt
	Loop, Read, %xPath%, %tPath%
	{
		If (A_Index = ID)
			var := string
		Else
			var := A_LoopReadLine
		FileAppend, %var%`n, %tPath%
	}
	FileDelete, %xPath%
	FileMove, %tPath%, %xPath%
	Return
}
DelTestStep(TSID)
{
	xPath = %A_ScriptDir%\data\%_module%\%_function%\%_TestCaseName%.txt
	tPath = %A_ScriptDir%\data\%_module%\%_function%\tmp.txt
	Loop, Read, %xPath%, %tPath%
	{
		If (A_Index = TSID)
			var := ""
		Else
			var := A_LoopReadLine
		If (var <> "")
			FileAppend, %var%`n, %tPath%
	}
	FileDelete, %xPath%
	FileMove, %tPath%, %xPath%
    Return
}

CheckDup(string)
{
	Loop
	{
		FileReadLine, var, %A_ScriptDir%\data\%_module%\%_function%\_main.txt, %A_Index%
		If ErrorLevel
			Break
		If (var = string)
			Return True
	}
	Return false
}

SortFile(xpath)
{
	FileRead, datalist, %xpath%
	Sort, datalist, Alpha
    FileDelete, %xpath%
	FileAppend, %datalist%, %xpath%
	Return
}
autoTrimString(string)
{
	newString := Trim(String)
	iString := ""
	Loop, Parse, newString, %A_Space%
	{
		If (A_LoopField <> "")
			iString .= A_LoopField . " "
	}
	return, % Trim(iString)
}

Bodau(myString)
{    
    N_String := ""    
    Loop, % StrLen(myString)    
    {        
        temp := SubStr(myString, A_Index, 1)        
        Switch Asc(temp)       
        {            
            Case 273:                
                N_String .= "d"            
            Case 272:                
                N_String .= "D"            
            Case 224, 225, 226, 227, 259, 7841, 7843, 7845, 7847, 7849, 7851, 7853, 7855, 7857, 7859, 7861, 7863:                
                N_String .= "a"            
            Case 192, 193, 194, 195, 258, 7840, 7842, 7844, 7846, 7848, 7850, 7852, 7854, 7856, 7858, 7860, 7862:                
                N_String .= "A"            
            Case 232, 233, 234, 7865, 7867, 7869, 7871, 7873, 7875, 7877, 7879:                
                N_String .= "e"            
            Case 200, 201, 202, 7864, 7866, 7868, 7870, 7872, 7874, 7876, 7878:                
                N_String .= "E"            
            Case 236, 237, 297, 7881, 7883:                
                N_String .= "i"            
            Case 204, 205, 296, 7880, 7882:                
                N_String .= "I"            
            Case 242, 243, 244, 245, 417, 7885, 7887, 7889, 7891, 7893, 7895, 7897, 7899, 7901, 7903, 7905, 7907:                  
                N_String .= "o"            
            Case 210, 211, 212, 213, 416, 7884, 7886, 7888, 7890, 7892, 7894, 7896, 7898, 7900, 7902, 7904, 7906:                
                N_String .= "O"            
            Case 249, 250, 361, 432, 7909, 7911, 7913, 7915, 7917, 7919, 7921:                
                N_String .= "u"            
            Case 217, 218, 360, 431, 7908, 7910, 7912, 7914, 7916, 7918, 7920:                
                N_String .= "U"            
            Case 253, 7923, 7925, 7927, 7929:                
                N_String .= "y"            
            Case 221, 7922, 7924, 7926, 7928:                
                N_String .= "Y"
            Case 32:
                N_String .= " "         
            Default:                
                N_String .= temp        
        }    
    }    
    Return %N_String%
}