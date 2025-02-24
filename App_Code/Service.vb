' NOTE: You can use the "Rename" command on the context menu to change the class name "Service" in code, svc and config file together.
Public Class Service
    Implements IService

    Dim lstEmployeeAndCompanyID As List(Of Integer)

    Public Function Save(ByVal crmid As String, ByVal un As String, ByVal comp As String, ByVal cp As String, ByVal adr As String, ByVal ct As String, ByVal m As String, ByVal e As String, ByVal p As String) As String Implements IService.Save
        Dim str As String = String.Empty


        Return str.Replace(";;", ";")

    End Function


    Public Function DoWork(ByVal str As String) As String Implements IService.DoWork
        Return "Hello: " & str
    End Function



End Class
