VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FileSystemWebController"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Implements WebController

Private m_directory As String


Private Sub Class_Initialize()
    m_directory = ActiveWorkbook.Path
End Sub


Public Property Get Directory() As String
    Directory = m_directory
End Property


Public Property Let Directory(val As String)
    val = TrimRight(val, "/")
    val = TrimLeft(val, "\")
    
    m_directory = val
End Property


Private Property Get WebController_UrlPattern() As String
    WebController_UrlPattern = "*"
End Property


Private Function WebController_ProcessRequest(request As HttpRequest) As HttpResponse
    Dim response As HttpResponse
    Set response = New HttpResponse
    
    Dim filename As String
    filename = ResolveFile(request.url)
    
    Dim file As FileInfo
    Set file = New FileInfo
    
    file.Initialize filename
    
    If file.Exists Then
        response.StatusCode = 200
        response.Headers.AddHeader "Content-Type", file.MimeType
        response.Body = file.ReadString
    Else
        response.StatusCode = 404
    End If
    
    Set WebController_ProcessRequest = response
End Function


Private Function ResolveFile(file As String) As String
    file = TrimLeft(file, "/")
    file = TrimLeft(file, "\")
    
    ResolveFile = m_directory & "\" & file
End Function


Private Function TrimLeft(text As String, c As String) As String
    Dim textLength As Long
    textLength = Len(text)
    
    Do While textLength > 0
        Dim firstCharacter As String
        firstCharacter = Left(text, 1)
        
        If firstCharacter <> c Then
            Exit Do
        End If
        
        text = Right(text, textLength - 1)
        textLength = Len(text)
    Loop
    
    TrimLeft = text
End Function


Private Function TrimRight(text As String, c As String) As String
    Dim textLength As Long
    textLength = Len(text)
    
    Do While textLength > 0
        Dim lastCharacter As String
        lastCharacter = Left(text, 1)
        
        If lastCharacter <> c Then
            Exit Do
        End If
        
        text = Left(text, textLength - 1)
        textLength = Len(text)
    Loop
    
    TrimRight = text
End Function