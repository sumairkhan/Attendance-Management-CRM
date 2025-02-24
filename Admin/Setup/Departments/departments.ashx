<%@ WebHandler Language="VB" Class="departments" %>

Imports System
Imports System.Web
Imports System.Web.SessionState
Imports Newtonsoft.Json

Public Class clsDepartments
    Public Property DepartmentID() As System.Nullable(Of Integer)
        Get
            Return m_DepartmentID
        End Get
        Set(ByVal value As System.Nullable(Of Integer))
            m_DepartmentID = value
        End Set
    End Property
    Private m_DepartmentID As System.Nullable(Of Integer)

    Public Property Title() As String
        Get
            Return m_Title
        End Get
        Set(ByVal value As String)
            m_Title = value
        End Set
    End Property
    Private m_Title As String
End Class


Public Class departments : Implements IHttpHandler
    Implements IReadOnlySessionState
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)


    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        If IsNumeric(context.Request.QueryString("action")) Then
            Dim intOption As Integer = context.Request.QueryString("action")
            Select Case intOption
                Case 1
                    getDeptList(context)
                Case 2
                    Dim intID As Integer = context.Request.QueryString("id")
                    editDept(context, intID)
                Case 3
                    Dim intID As Integer = context.Request.QueryString("id")
                    addDept(context, intID)
                Case 4
                    Dim intID As Integer = context.Request.QueryString("id")
                    deleteDept(context, intID)
            End Select
        End If
    End Sub

    Private Sub getDeptList(ByVal context As HttpContext)
        Try
            Using cntx As New PortalModel.PortalEntities
                Dim obj = (From b In cntx.Departments Where b.IsDeleted = False Order By b.Title Select b.DepartmentID, b.Title).ToList
                obj = obj.Where(Function(f) Not f.Title.ToLower().Trim().Equals("superadmin")).ToList()

                Dim JsonStr As String = JsonConvert.SerializeObject(New With {Key .deptlist = obj})
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


    Private Sub editDept(ByVal context As HttpContext, ByVal intID As Integer)
        Dim output As String = ""
        Try

            Dim JsonStr = context.Request("models")
            Dim Dept = JsonConvert.DeserializeObject(Of List(Of clsDepartments))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim strName As String = Dept(0).Title.Trim().ToLower()
                Dim deptID As Integer = Dept(0).DepartmentID
                Dim objDepartment = (From tbl In cntx.Departments Where tbl.IsActive = True AndAlso tbl.Title.Trim().ToLower() = strName AndAlso tbl.DepartmentID <> deptID Select tbl).FirstOrDefault

                If objDepartment Is Nothing Then

                    'Dim obj = New PortalModel.Departments With {.DepartmentID = Dept(0).DepartmentID}
                    Dim obj = cntx.Departments.Where(Function(f) f.DepartmentID = deptID).ToList().FirstOrDefault()
                    Dim objOld = New PortalModel.PortalEntities().Departments.Where(Function(f) f.DepartmentID = deptID).ToList().FirstOrDefault()
                    cntx.Departments.Attach(obj)
                    With obj
                        .Title = Dept(0).Title.Trim()
                    End With
                    cntx.SaveChanges()

                    Try
                        PortalUtilities.fnCompare(CType(objOld, Object), CType(obj, Object), obj.DepartmentID, lstEmployeeAndCompanyID(0))
                    Catch ex As Exception

                    End Try

                    context.Response.ContentType = "application/json; charset=utf-8"
                    context.Response.Write(JsonStr)
                Else
                    context.Response.ContentType = "application/json; charset=utf-8"
                    Dim objErr As New Newtonsoft.Json.Linq.JObject
                    objErr.Add("Errors", "Department Already Exist!")
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

    Private Sub addDept(ByVal context As HttpContext, ByVal intID As Integer)
        Dim output As String = ""
        Try

            Dim JsonStr = context.Request("models")
            Dim Dept = JsonConvert.DeserializeObject(Of List(Of clsDepartments))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim strName As String = Dept(0).Title.Trim().ToLower()
                Dim objDepartment = (From tbl In cntx.Departments Where tbl.IsActive = True AndAlso tbl.Title.Trim().ToLower() = strName Select tbl).FirstOrDefault

                If objDepartment Is Nothing Then
                    Dim obj = New PortalModel.Departments
                    With obj
                        .Title = Dept(0).Title.Trim()
                        .CompanyID = lstEmployeeAndCompanyID(1)
                        .IsActive = True
                        .CreateDate = DateTime.Now
                        .IsDeleted = False
                        .InsertedBy = lstEmployeeAndCompanyID(0)
                    End With


                    cntx.Departments.AddObject(obj)
                    cntx.SaveChanges()

                    context.Response.ContentType = "application/json; charset=utf-8"
                    context.Response.Write(JsonStr)

                Else
                    context.Response.ContentType = "application/json; charset=utf-8"
                    Dim objErr As New Newtonsoft.Json.Linq.JObject
                    objErr.Add("Errors", "Department Already Exist!")
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

    Private Sub deleteDept(ByVal context As HttpContext, ByVal intID As Integer)
        Dim output As String = ""
        Try

            Dim JsonStr = context.Request("models")
            Dim Dept = JsonConvert.DeserializeObject(Of List(Of clsDepartments))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim obj = New PortalModel.Departments With {.DepartmentID = Dept(0).DepartmentID}

                cntx.Departments.Attach(obj)
                'cntx.Departments.DeleteObject(obj)
                With obj
                    .IsDeleted = True
                    .DeletedBy = lstEmployeeAndCompanyID(0)
                End With
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

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class