<%
Class cnGhostImage   
    Private ASO, FSO, m_IMGPath, m_IMGExsits   
    Private Sub Class_Initialize   
        m_IMGPath = ""  
    End Sub  
  
    Private Sub Class_Terminate   
        Set ASO=Nothing  
        Set FSO=Nothing  
    End Sub  
  
    Public Property Let Path(mValue)   
        m_IMGPath = mValue   
        If m_IMGPath = "" OR IsNull(m_IMGPath) Then  
            m_IMGExsits = False  
        Else  
            if not instr(m_IMGPath,":") > 0 then m_IMGPath = Server.MapPath(m_IMGPath)   
            Set FSO = Server.CreateObject("Scripting.FileSystemObject")    
            m_IMGExsits = FSO.FileExists(m_IMGPath)   
            If m_IMGExsits Then  
                Set ASO=Server.CreateObject("ADODB.Stream")   
                ASO.Mode=3   
                ASO.Type=1   
                ASO.Open   
            End If  
        End If  
    End Property  
  
    Private Function Bin2Str(Bin)   
        On Error Resume Next  
        Dim I, Str   
        For I=1 To LenB(Bin)   
            clow=MidB(Bin,I,1)   
            If ASCB(clow)<128 Then  
                Str = Str & Chr(ASCB(clow))   
            Else  
                I=I+1   
                If I <= LenB(Bin) Then Str = Str & Chr(ASCW(MidB(Bin,I,1)&clow))   
            End If  
        Next  
        Bin2Str = Str   
    End Function  
         
    Private Function Num2Str(Num,Base,Lens)   
        Dim Ret   
        Ret = ""  
        While(Num>=Base)   
            Ret = (Num Mod Base) & Ret   
            Num = (Num - Num Mod Base)/Base   
        Wend   
        Num2Str = Right(String(Lens,"0") & Num & Ret,Lens)   
    End Function  
  
    Private Function Str2Num(Str,Base)    
        Dim Ret,I   
        Ret = 0    
        For I=1 To Len(Str)    
            Ret = Ret *base + Cint(Mid(Str,I,1))    
        Next    
        Str2Num=Ret    
    End Function    
  
    Private Function BinVal(Bin)    
        On Error Resume Next  
        Dim Ret,I   
        Ret = 0    
        For I = LenB(Bin) To 1 Step -1    
            Ret = Ret *256 + AscB(MidB(Bin,I,1))    
        Next    
        BinVal=Ret    
    End Function    
  
    Private Function BinVal2(Bin)    
        Dim Ret,I   
        Ret = 0    
        For I = 1 To LenB(Bin)    
            Ret = Ret *256 + AscB(MidB(Bin,I,1))    
        Next    
        BinVal2=Ret    
    End Function    
  
    Private Function GetImageSize(filespec)   
        Dim bFlag   
        Dim Ret(3)    
        ASO.LoadFromFile(filespec)    
        bFlag=ASO.Read(3)    
        Select Case Hex(binVal(bFlag))    
            Case "4E5089":    
                ASO.Read(15)    
                ret(0)="PNG"    
                ret(1)=BinVal2(ASO.Read(2))    
                ASO.Read(2)    
                ret(2)=BinVal2(ASO.Read(2))    
            Case "464947":    
                ASO.read(3)    
                ret(0)="gif"    
                ret(1)=BinVal(ASO.Read(2))    
                ret(2)=BinVal(ASO.Read(2))    
            Case "535746":    
                ASO.read(5)    
                binData=ASO.Read(1)    
                sConv=Num2Str(ascb(binData),2 ,8)    
                nBits=Str2Num(left(sConv,5),2)    
                sConv=mid(sConv,6)    
                While(len(sConv)<nBits*4)    
                    binData=ASO.Read(1)    
                    sConv=sConv&Num2Str(AscB(binData),2 ,8)    
                Wend    
                ret(0)="SWF"    
                ret(1)=Int(Abs(Str2Num(Mid(sConv,1*nBits+1,nBits),2)-Str2Num(Mid(sConv,0*nBits+1,nBits),2))/20)    
                ret(2)=Int(Abs(Str2Num(Mid(sConv,3*nBits+1,nBits),2)-Str2Num(Mid(sConv,2*nBits+1,nBits),2))/20)    
            Case "FFD8FF":    
                dim p1   
                Do     
                Do: p1=binVal(ASO.Read(1)): Loop While p1=255 And Not ASO.EOS    
                    If p1>191 And p1<196 Then Exit Do Else ASO.read(binval2(ASO.Read(2))-2)    
                    Do:p1=binVal(ASO.Read(1)):Loop While p1<255 And Not ASO.EOS    
                Loop While True    
                ASO.Read(3)    
                ret(0)="JPG"    
                ret(2)=binval2(ASO.Read(2))    
                ret(1)=binval2(ASO.Read(2))    
            Case Else:    
                If left(Bin2Str(bFlag),2)="BM" Then    
                    ASO.Read(15)    
                    ret(0)="BMP"    
                    ret(1)=binval(ASO.Read(4))    
                    ret(2)=binval(ASO.Read(4))    
                Else    
                    ret(0)=""    
                End If    
        End Select    
       ' ret(3)="width=""" & ret(1) """ height=""" & ret(2) """"    
        getimagesize=ret    
    End Function    
  
    Public Function W()   
        if m_IMGPath <> "" then m_IMGPath = lcase(m_IMGPath)   
        If m_IMGExsits Then    
            Dim IMGFile,FileExt,Arr   
            Set IMGFile = FSO.GetFile(m_IMGPath)    
            FileExt=FSO.GetExtensionName(m_IMGPath)    
            Select Case FileExt    
                Case "gif","bmp","jpg","png":    
                    Arr=GetImageSize(IMGFile.Path)    
                    W = Arr(1)    
            End Select    
            Set IMGFile=Nothing    
        Else  
            W = 0   
        End If  
    End Function    
  
    Public Function H()   
        if m_IMGPath <> "" then m_IMGPath = lcase(m_IMGPath)   
        If m_IMGExsits Then    
            Dim IMGFile,FileExt,Arr   
            Set IMGFile = FSO.GetFile(m_IMGPath)    
            FileExt=FSO.GetExtensionName(m_IMGPath)    
            Select Case FileExt    
                Case "gif","bmp","jpg","png":    
                    Arr=getImageSize(IMGFile.Path)    
                    H = Arr(2)    
            End Select    
            Set IMGFile=Nothing    
        Else  
            H = 0    
        End If        
    End Function  
  
    Public Function S()   
        if m_IMGPath <> "" then m_IMGPath = lcase(m_IMGPath)   
        If m_IMGExsits Then    
            Dim IMGFile   
            Set IMGFile = FSO.GetFile(m_IMGPath)    
            S = IMGFile.Size   
            Set IMGFile=Nothing    
        Else  
            S = 0    
        End If        
    End Function  
  
    Public Function T()   
        if m_IMGPath <> "" then m_IMGPath = lcase(m_IMGPath)   
        If m_IMGExsits Then    
            Dim IMGFile   
            Set IMGFile = FSO.GetFile(m_IMGPath)    
            T = IMGFile.Type   
            Set IMGFile=Nothing    
        Else  
            T = "unknown"  
        End If        
    End Function  
End Class  
%>