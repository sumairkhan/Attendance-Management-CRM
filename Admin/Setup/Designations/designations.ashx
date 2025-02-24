<%@ WebHandler Language="VB" Class="designations" %>

Imports System
Imports System.Web
Imports System.Web.SessionState
Imports Newtonsoft.Json

Public Class clsDesignations
    Public Property DesignationID() As System.Nullable(Of Integer)

    Public Property Title() As String
End Class


Public Class designations : Implements IHttpHandler
    Implements IReadOnlySessionState
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)


    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        If IsNumeric(context.Request.QueryString("action")) Then
            Dim intOption As Integer = context.Request.QueryString("action")
            Select Case intOption
                Case 1
                    getList(context)
                Case 2
                    Dim intID As Integer = context.Request.QueryString("id")
                    edit(context, intID)
                Case 3
                    Dim intID As Integer = context.Request.QueryString("id")
                    add(context, intID)
                Case 4
                    Dim intID As Integer = context.Request.QueryString("id")
                    delete(context, intID)
            End Select
        End If
    End Sub

    Private Sub getList(ByVal context As HttpContext)
        Try
            Using cntx As New PortalModel.PortalEntities
                Dim obj = (From b In cntx.HR_Designations Where b.IsDeleted = False Order By b.Title Select b.DesignationID, b.Title).ToList

                Dim JsonStr As String = JsonConvert.SerializeObject(New With {Key .list = obj})
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


    Private Sub edit(ByVal context As HttpContext, ByVal intID As Integer)
        Dim output As String = ""
        Try

            Dim JsonStr = context.Request("models")
            Dim objTbl = JsonConvert.DeserializeObject(Of List(Of clsDesignations))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim strName As String = objTbl(0).Title.Trim().ToLower()
                Dim intObjID As Integer = objTbl(0).DesignationID
                Dim objTblExist = (From tbl In cntx.HR_Designations Where tbl.IsDeleted = False AndAlso tbl.Title.Trim().ToLower() = strName AndAlso tbl.DesignationID <> intObjID Select tbl).FirstOrDefault

                If objTblExist Is Nothing Then
                    Dim obj = cntx.HR_Designations.Where(Function(f) f.DesignationID = intObjID).ToList().FirstOrDefault()
                    Dim objOld = New PortalModel.PortalEntities().HR_Designations.Where(Function(f) f.DesignationID = intObjID).ToList().FirstOrDefault()
                    cntx.HR_Designations.Attach(obj)
                    With obj
                        .Title = objTbl(0).Title.Trim()
                    End With
                    cntx.SaveChanges()

                    Try
                        PortalUtilities.fnCompare(CType(objOld, Object), CType(obj, Object), obj.DesignationID, lstEmployeeAndCompanyID(0))
                    Catch ex As Exception

                    End Try

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

    Private Sub add(ByVal context As HttpContext, ByVal intID As Integer)
        Dim output As String = ""
        Try

            Dim JsonStr = context.Request("models")
            Dim objTbl = JsonConvert.DeserializeObject(Of List(Of clsDesignations))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim strName As String = objTbl(0).Title.Trim().ToLower()
                Dim objDesignation = (From tbl In cntx.HR_Designations Where tbl.IsDeleted = False AndAlso tbl.Title.Trim().ToLower() = strName Select tbl).FirstOrDefault

                If objDesignation Is Nothing Then
                    Dim obj = New PortalModel.HR_Designations
                    With obj
                        .Title = objTbl(0).Title.Trim()
                        .InsertedDateTime = DateTime.Now
                        .IsDeleted = False
                        .InsertedBy = lstEmployeeAndCompanyID(0)
                    End With


                    cntx.HR_Designations.AddObject(obj)
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

    Private Sub delete(ByVal context As HttpContext, ByVal intID As Integer)
        Dim output As String = ""
        Try

            Dim JsonStr = context.Request("models")
            Dim Dept = JsonConvert.DeserializeObject(Of List(Of clsDesignations))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim obj = New PortalModel.HR_Designations With {.DesignationID = Dept(0).DesignationID}

                cntx.HR_Designations.Attach(obj)
                'cntx.Designations.DeleteObject(obj)
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