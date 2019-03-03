VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "FastCGIHeader"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Implements IFastCGIRecord

Public ProtocolVersion As Byte
Public MessageType As Byte
Public RequestId As Integer
Public ContentLength As Integer
Public PaddingLength As Byte
Public Reserved As String


Private Sub Class_Initialize()
    Reserved = StringExtensions.Repeat(Chr(0), 1)
End Sub


Private Sub IFastCGIRecord_ReadFromTcpClient(client As TcpClient)
    Dim bytes As String
    bytes = client.ReceiveBytes(8)

    ProtocolVersion = Marshal.BytesToInt8(bytes)
    bytes = StringExtensions.Substring(bytes, 1)

    MessageType = Marshal.BytesToInt8(bytes)
    bytes = StringExtensions.Substring(bytes, 1)

    RequestId = Marshal.BytesToInt16(bytes)
    bytes = StringExtensions.Substring(bytes, 2)

    ContentLength = Marshal.BytesToInt16(bytes)
    bytes = StringExtensions.Substring(bytes, 2)

    PaddingLength = Marshal.BytesToInt8(bytes)
    bytes = StringExtensions.Substring(bytes, 1)

    Reserved = bytes
End Sub


Private Sub IFastCGIRecord_WriteToTcpClient(client As TcpClient)
    Dim bytes As String
    bytes = ""

    bytes = bytes & Marshal.Int8ToBytes(ProtocolVersion)
    bytes = bytes & Marshal.Int8ToBytes(MessageType)
    bytes = bytes & Marshal.Int16ToBytes(RequestId)
    bytes = bytes & Marshal.Int16ToBytes(ContentLength)
    bytes = bytes & Marshal.Int8ToBytes(PaddingLength)
    bytes = bytes & Reserved

    client.SendString bytes
End Sub