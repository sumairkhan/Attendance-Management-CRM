<%@ WebHandler Language="VB" Class="shift_users" %>

Imports System
Imports System.Web
Imports System.Web.SessionState
Imports Newtonsoft.Json

Public Class clsShiftUsers
    Public Property Shifts_UserID() As System.Nullable(Of Integer)
    Public Property ShiftID() As System.Nullable(Of Integer)
    Public Property UserID() As System.Nullable(Of Integer)
End Class

Public Class clsShiftUsersAddEdit
    Public Property Shifts_UserID() As System.Nullable(Of Integer)
    Public Property ShiftID() As System.Nullable(Of Integer)
    Public Property UserID() As System.Nullable(Of Integer)
    Public Property ShiftTitle() As String
    Public Property EmployeeName() As String
    Public Property CreatedDate() As String
End Class

'Public Class clsCustomers
'    Public Property CustomerID() As System.Nullable(Of Integer)
'    Public Property CompanyName() As String
'End Class

Public Class shift_users : Implements IHttpHandler, IReadOnlySessionState
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        If IsNumeric(context.Request.QueryString("action")) Then
            Dim intOption As Integer = context.Request.QueryString("action")
            Select Case intOption
                Case 1
                    getData(context)
                Case 2
                    editData(context)
                Case 3
                    addData(context)
                Case 4
                    deleteData(context)
                Case 5
                    getShifts(context)
                Case 6
                    getEmployees(context)
            End Select
        End If
    End Sub

    Private Sub getData(ByVal context As HttpContext)
        Try
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

            Using cntx As New PortalModel.PortalEntities
                Dim obj = (From tbl In cntx.sp_GetAllShiftUserswithShiftsAndEmployees
                           Where tbl.CompanyID = intCompanyID
                           Select tbl.Shifts_UserID, tbl.ShiftID, tbl.UserID, tbl.CreatedDate, tbl.ShiftTitle, tbl.EmployeeName, tbl.DepartmentID, tbl.DeptTitle).ToList()


                'Dim intDeptID As Integer = lstEmployeeAndCompanyID(2)
                'Dim intEmpID As Integer = lstEmployeeAndCompanyID(0)
                'Dim objEmpRights = cntx.sp_GetPageRightsByEmpAndMenuLinkID(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Employee_Shifts).Where(Function(f) f.EmpRightID > 0).ToList()


                'Dim lstInnerRights = objEmpRights.Select(Function(f) f.Title).ToList()

                'If Not lstInnerRights.Contains("View Other Departments") AndAlso Not lstInnerRights.Contains("View Others") Then
                '    obj = obj.Where(Function(f) f.UserID = intEmpID).ToList()
                'ElseIf Not lstInnerRights.Contains("View Other Departments") AndAlso lstInnerRights.Contains("View Others") Then
                '    obj = obj.Where(Function(f) f.DepartmentID = intDeptID).ToList()
                'End If

                obj = obj.Where(Function(f) Not f.DeptTitle.ToLower().Trim().Equals("superadmin")).ToList()

                Dim JsonStr As String = JsonConvert.SerializeObject(New With {Key .datalist = obj})
                context.Response.ContentType = "application/json; charset=utf-8"
                context.Response.Write(JsonStr)

            End Using
        Catch ex As Exception
            context.Response.ContentType = "application/json; charset=utf-8"
            Dim objErr As New Newtonsoft.Json.Linq.JObject
            objErr.Add("Errors", ex.Message)
            context.Response.Write(objErr.ToString)
        End Try

    End Sub


    Private Sub editData(ByVal context As HttpContext)
        Dim output As String = ""
        Try
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

            Dim JsonStr = context.Request("models")
            Dim Data = JsonConvert.DeserializeObject(Of List(Of clsShiftUsers))(JsonStr)
            Dim intID As Integer = Data(0).Shifts_UserID
            Dim intShiftEmpID As Integer = Data(0).UserID
            Using cntx As New PortalModel.PortalEntities

                Dim objTemp = cntx.Att_Shifts_Users.Where(Function(f) f.IsDeleted = False AndAlso f.CompanyID = intCompanyID AndAlso f.UserID = intShiftEmpID AndAlso f.Shifts_UserID <> intID).ToList().FirstOrDefault()

                If objTemp Is Nothing Then

                    Dim obj = cntx.Att_Shifts_Users.Where(Function(f) f.Shifts_UserID = intID).ToList().FirstOrDefault()
                    Dim objOld = New PortalModel.PortalEntities().Att_Shifts_Users.Where(Function(f) f.Shifts_UserID = intID).ToList().FirstOrDefault()
                    cntx.Att_Shifts_Users.Attach(obj)
                    With obj
                        .ShiftID = Data(0).ShiftID
                        .UserID = Data(0).UserID
                    End With
                    cntx.SaveChanges()

                    Try
                        PortalUtilities.fnCompare(CType(objOld, Object), CType(obj, Object), obj.Shifts_UserID, lstEmployeeAndCompanyID(0))
                    Catch ex As Exception

                    End Try


                    Dim intEmpID As Integer = lstEmployeeAndCompanyID(0)
                    Dim objEmp = cntx.Employees.Where(Function(f) f.EmployeeID = intEmpID).ToList().FirstOrDefault()
                    objEmp.CurrentShiftID = obj.ShiftID

                    context.Response.ContentType = "application/json; charset=utf-8"
                    context.Response.Write(JsonStr)
                Else
                    context.Response.ContentType = "application/json; charset=utf-8"
                    Dim objErr As New Newtonsoft.Json.Linq.JObject
                    objErr.Add("Errors", "Already Exist!")
                    context.Response.Write(objErr.ToString)
                End If
            End Using

        Catch ex As Exception
            context.Response.ContentType = "application/json; charset=utf-8"
            Dim objErr As New Newtonsoft.Json.Linq.JObject
            objErr.Add("Errors", ex.Message)
            context.Response.Write(objErr.ToString)
        End Try
    End Sub

    Private Sub addData(ByVal context As HttpContext)
        Dim output As String = ""
        Try
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

            Dim JsonStr = context.Request("models")
            Dim Data = JsonConvert.DeserializeObject(Of List(Of clsShiftUsers))(JsonStr)

            Dim intShiftEmpID As Integer = Data(0).UserID

            Using cntx As New PortalModel.PortalEntities
                Dim objTemp = cntx.Att_Shifts_Users.Where(Function(f) f.IsDeleted = False AndAlso f.CompanyID = intCompanyID AndAlso f.UserID = intShiftEmpID).ToList().FirstOrDefault()

                If objTemp Is Nothing Then

                    Dim obj = New PortalModel.Att_Shifts_Users
                    With obj
                        .ShiftID = Data(0).ShiftID
                        .UserID = Data(0).UserID
                        .IsDeleted = False
                        .InsertedBy = lstEmployeeAndCompanyID(0)
                        .CompanyID = lstEmployeeAndCompanyID(1)
                        .CreatedDate = DateTime.Now
                    End With

                    cntx.Att_Shifts_Users.AddObject(obj)
                    cntx.SaveChanges()

                    Dim intEmpID As Integer = obj.UserID
                    Dim objEmp = cntx.Employees.Where(Function(f) f.EmployeeID = intEmpID).ToList().FirstOrDefault()
                    objEmp.CurrentShiftID = obj.ShiftID
                    cntx.SaveChanges()



                    context.Response.ContentType = "application/json; charset=utf-8"
                    context.Response.Write(JsonStr)
                Else
                    context.Response.ContentType = "application/json; charset=utf-8"
                    Dim objErr As New Newtonsoft.Json.Linq.JObject
                    objErr.Add("Errors", "Already Exist!")
                    context.Response.Write(objErr.ToString)
                End If
            End Using



        Catch ex As Exception
            context.Response.ContentType = "application/json; charset=utf-8"
            Dim objErr As New Newtonsoft.Json.Linq.JObject
            objErr.Add("Errors", ex.Message)
            context.Response.Write(objErr.ToString)
        End Try
    End Sub

    Private Sub deleteData(ByVal context As HttpContext)
        Dim output As String = ""
        Try
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)


            Dim JsonStr = context.Request("models")
            Dim Data = JsonConvert.DeserializeObject(Of List(Of clsShiftUsers))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim obj = New PortalModel.Att_Shifts_Users With {.Shifts_UserID = Data(0).Shifts_UserID}
                cntx.Att_Shifts_Users.Attach(obj)
                'cntx.Projects.DeleteObject(obj)
                obj.IsDeleted = True
                obj.DeletedBy = lstEmployeeAndCompanyID(0)


                Dim intEmpID As Integer = lstEmployeeAndCompanyID(0)
                Dim objEmp = cntx.Employees.Where(Function(f) f.EmployeeID = intEmpID).ToList().FirstOrDefault()
                If objEmp.CurrentShiftID IsNot Nothing AndAlso objEmp.CurrentShiftID = obj.ShiftID Then
                    objEmp.CurrentShiftID = Nothing
                End If



                cntx.SaveChanges()
            End Using


            context.Response.ContentType = "application/json; charset=utf-8"
            context.Response.Write(JsonStr)
        Catch ex As Exception
            context.Response.ContentType = "application/json; charset=utf-8"
            Dim objErr As New Newtonsoft.Json.Linq.JObject
            objErr.Add("Errors", ex.Message)
            context.Response.Write(objErr.ToString)
        End Try
    End Sub


    Private Sub getShifts(ByVal context As HttpContext)
        Try
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

            Using cntx As New PortalModel.PortalEntities
                Dim obj = (From tbl In cntx.Att_Shifts
                           Where tbl.IsDeleted = False AndAlso tbl.CompanyID = intCompanyID
                           Order By tbl.Title
                           Select tbl.ShiftID, tbl.Title)

                Dim JsonStr As String = JsonConvert.SerializeObject(New With {Key .datalist = obj})
                context.Response.ContentType = "application/json; charset=utf-8"
                context.Response.Write(JsonStr)

            End Using
        Catch ex As Exception
            context.Response.ContentType = "application/json; charset=utf-8"
            Dim objErr As New Newtonsoft.Json.Linq.JObject
            objErr.Add("Errors", ex.Message)
            context.Response.Write(objErr.ToString)
        End Try

    End Sub

    Private Sub getEmployees(ByVal context As HttpContext)
        Try
            Using cntx As New PortalModel.PortalEntities
                lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
                Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

                Dim objTemp = (From emp In cntx.Employees
                               Join d In cntx.Departments On emp.DepartmentID Equals d.DepartmentID
                               Where emp.IsDeleted = False Or emp.IsDeleted Is Nothing
                               Order By emp.FirstName, emp.LastName
                               Select emp.EmployeeID, EmpName = emp.FirstName & " " & emp.LastName, DeptTitle = d.Title, d.DepartmentID).ToList()


                'Dim intDeptID As Integer = lstEmployeeAndCompanyID(2)
                'Dim intEmpID As Integer = lstEmployeeAndCompanyID(0)
                'Dim objEmpRights = cntx.sp_GetPageRightsByEmpAndMenuLinkID(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Employee_Shifts).Where(Function(f) f.EmpRightID > 0).ToList()


                'Dim lstInnerRights = objEmpRights.Select(Function(f) f.Title).ToList()

                'If Not lstInnerRights.Contains("View Other Departments") AndAlso Not lstInnerRights.Contains("View Others") Then
                '    objTemp = objTemp.Where(Function(f) f.EmployeeID = intEmpID).ToList()
                'ElseIf Not lstInnerRights.Contains("View Other Departments") AndAlso lstInnerRights.Contains("View Others") Then
                '    objTemp = objTemp.Where(Function(f) f.DepartmentID = intDeptID).ToList()
                'End If

                objTemp = objTemp.Where(Function(f) Not f.DeptTitle.ToLower().Trim().Equals("superadmin")).ToList()
                Dim obj = (From emp In objTemp Select emp.EmployeeID, EmpName = emp.EmpName & " (" & emp.DeptTitle & ")").ToList()


                Dim JsonStr As String = JsonConvert.SerializeObject(New With {Key .datalist = obj})
                context.Response.ContentType = "application/json; charset=utf-8"
                context.Response.Write(JsonStr)

            End Using
        Catch ex As Exception
            context.Response.ContentType = "application/json; charset=utf-8"
            Dim objErr As New Newtonsoft.Json.Linq.JObject
            objErr.Add("Errors", ex.Message)
            context.Response.Write(objErr.ToString)
        End Try

    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class