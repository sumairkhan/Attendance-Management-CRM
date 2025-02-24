Imports System.ServiceModel
Imports System.ServiceModel.Web

' NOTE: You can use the "Rename" command on the context menu to change the interface name "IService" in both code and config file together.
<ServiceContract()>
Public Interface IService

    <OperationContract()>
    <WebInvoke(Method:="GET")>
    Function DoWork(ByVal str As String) As String

    <OperationContract()>
    <DataContractFormat()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Function Save(ByVal crmid As String, ByVal un As String, ByVal comp As String, ByVal cp As String, ByVal adr As String, ByVal ct As String, ByVal m As String, ByVal e As String, ByVal p As String) As String

End Interface
