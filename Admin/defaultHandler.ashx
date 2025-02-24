<%@ WebHandler Language="VB" Class="defaultHandler" %>

Imports System
Imports System.Web
Imports System.Web.SessionState
Imports Newtonsoft.Json
Imports System.Security.Principal



Public Class defaultHandler : Implements IHttpHandler
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
    
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        If IsNumeric(context.Request.QueryString("action")) Then
            Dim intOption As Integer = context.Request.QueryString("action")
            Select Case intOption
                Case 1
                    'getIRByDays(context)
                Case 2
                    
                Case 3
                    
                Case 4
                    
            End Select
        End If
    End Sub
    
    'Private Sub getIRByDays(ByVal context As HttpContext)
    '    Try
    '        Using cntx As New PortalModel.PortalEntities
    '            Dim dateTo As Date = DateTime.Today
    '            Dim dateFrom As Date = DateTime.Today.AddDays(-15)
    '            Dim empID As Integer = lstEmployeeAndCompanyID(0)
    '            Dim companyID As Integer = lstEmployeeAndCompanyID(1)
    '            Dim deptID As Integer = lstEmployeeAndCompanyID(2)
    '            Dim objIRByDays = cntx.sp_DashboardGetAllIR(dateFrom, dateTo, companyID, Nothing, Nothing).Where(Function(f) f.Type = 1 OrElse f.Type = 2 OrElse f.Type = 3 OrElse f.Type = 4).ToList()
                
    '            Dim objEmpRights = cntx.sp_GetPageRightsByEmpAndMenuLinkID(empID, PortalUtilities.MenuLinks.ListIR).Where(Function(f) f.EmpRightID > 0).ToList()
    '            Dim lstInnerRights = objEmpRights.Select(Function(f) f.Title).ToList()

    '            If objEmpRights IsNot Nothing AndAlso objEmpRights.Count > 0 Then
    '                If lstInnerRights.Contains("View Other Departments") Then

    '                ElseIf lstInnerRights.Contains("View Others") Then
    '                    objIRByDays = cntx.sp_DashboardGetAllIR(dateFrom, dateTo, companyID, deptID, Nothing).Where(Function(f) f.Type = 5 OrElse f.Type = 6 OrElse f.Type = 7).ToList()
    '                Else
    '                    objIRByDays = cntx.sp_DashboardGetAllIR(dateFrom, dateTo, companyID, Nothing, empID).Where(Function(f) f.Type = 5 OrElse f.Type = 6 OrElse f.Type = 7).ToList()
    '                End If
    '            Else
    '                objIRByDays = cntx.sp_DashboardGetAllIR(dateFrom, dateTo, companyID, Nothing, empID).Where(Function(f) f.Type = 5 OrElse f.Type = 6 OrElse f.Type = 7).ToList()
    '            End If
                
    '            'Dim objEmp = cntx.Employees.Where(Function(f) f.EmployeeID = empID).ToList().FirstOrDefault()
                
    '            'If objEmp.IsHOD IsNot Nothing AndAlso objEmp.IsHOD AndAlso (objEmp.IsBOD Is Nothing OrElse Not objEmp.IsBOD) Then
    '            '    objIRByDays = cntx.sp_DashboardGetAllIR(dateFrom, dateTo, companyID, deptID, Nothing).Where(Function(f) f.Type = 5 OrElse f.Type = 6 OrElse f.Type = 7).ToList()
    '            'ElseIf (objEmp.IsHOD Is Nothing OrElse Not objEmp.IsHOD) AndAlso (objEmp.IsBOD Is Nothing OrElse Not objEmp.IsBOD) Then
    '            '    objIRByDays = cntx.sp_DashboardGetAllIR(dateFrom, dateTo, companyID, Nothing, empID).Where(Function(f) f.Type = 5 OrElse f.Type = 6 OrElse f.Type = 7).ToList()
    '            'End If
                
    '            Dim JsonStr As String = JsonConvert.SerializeObject(New With {Key .List = objIRByDays})
    '            context.Response.ContentType = "application/json; charset=utf-8"
    '            context.Response.Write(JsonStr)

    '        End Using
    '    Catch ex As Exception
    '        context.Response.ContentType = "application/json; charset=utf-8"
    '        Dim objErr As New Newtonsoft.Json.Linq.JObject
    '        objErr.Add("Errors", ex.Message)
    '        context.Response.Write(objErr.ToString)
    '    End Try
           
    'End Sub
    
    
    
    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class