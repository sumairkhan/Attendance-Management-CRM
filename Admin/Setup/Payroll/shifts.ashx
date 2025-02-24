<%@ WebHandler Language="VB" Class="shifts" %>

Imports System
Imports System.Web
Imports System.Web.SessionState
Imports Newtonsoft.Json
Imports System.Security.Principal

Public Class clsShifts
    Public Property ShiftID() As System.Nullable(Of Integer)
    Public Property TimingInHours() As Integer
    Public Property TimingInMinutes() As Integer
    Public Property TimingOutHours() As Integer
    Public Property TimingOutMinutes() As Integer
    Public Property GraceTimeMinutes() As Integer
    Public Property Title() As String
    Public Property IsDayChanged() As System.Nullable(Of Boolean)
End Class

Public Class clsHoliday
    Public Property HolidayID() As System.Nullable(Of Integer)
    Public Property Title() As String
    Public Property HolidayDate() As String
    Public Property InsertedBy() As System.Nullable(Of Integer)
    Public Property InsertedDate() As System.Nullable(Of DateTime)
    Public Property IsDeleted() As System.Nullable(Of Boolean)
    Public Property DeletedBy() As System.Nullable(Of Integer)
    Public Property DeletedDate() As System.Nullable(Of DateTime)
End Class


Public Class shifts : Implements IHttpHandler, IReadOnlySessionState
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
                    
                Case 5
                    getListHoliday(context)
                Case 6
                    Dim intID As Integer = context.Request.QueryString("id")
                    editHoliday(context, intID)
                Case 7
                    Dim intID As Integer = context.Request.QueryString("id")
                    addHoliday(context, intID)
                Case 8
                    Dim intID As Integer = context.Request.QueryString("id")
                    deleteHoliday(context, intID)
            End Select
        End If
    End Sub

    Private Sub getList(ByVal context As HttpContext)
        Try
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

            Using cntx As New PortalModel.PortalEntities
                Dim obj = (From b In cntx.Att_Shifts Where b.IsDeleted = False And b.CompanyID = intCompanyID Order By b.Title Select b.ShiftID, b.Title, TimingInHours = b.TimingIn.Value.Hours, TimingInMinutes = b.TimingIn.Value.Minutes, TimingOutHours = b.TimingOut.Value.Hours, TimingOutMinutes = b.TimingOut.Value.Minutes, b.GraceTimeMinutes, b.IsDayChanged).ToList

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
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

            Dim JsonStr = context.Request("models")
            Dim Shifts = JsonConvert.DeserializeObject(Of List(Of clsShifts))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim strName As String = Shifts(0).Title.Trim().ToLower()
                Dim shiftID As Integer = Shifts(0).ShiftID
                Dim obj = (From tbl In cntx.Att_Shifts Where tbl.CompanyID = intCompanyID AndAlso tbl.IsDeleted = False AndAlso tbl.ShiftID <> shiftID AndAlso tbl.Title.Trim().ToLower() = strName Select tbl).FirstOrDefault

                If obj Is Nothing Then
                    Dim objShift = cntx.Att_Shifts.Where(Function(f) f.ShiftID = shiftID).ToList().FirstOrDefault()
                    Dim objShiftOld = New PortalModel.PortalEntities().Att_Shifts.Where(Function(f) f.ShiftID = shiftID).ToList().FirstOrDefault()
                    cntx.Att_Shifts.Attach(objShift)
                    With objShift
                        .Title = Shifts(0).Title
                        .TimingIn = TimeSpan.Parse(Shifts(0).TimingInHours & ":" & Shifts(0).TimingInMinutes & ":00")
                        .TimingOut = TimeSpan.Parse(Shifts(0).TimingOutHours & ":" & Shifts(0).TimingOutMinutes & ":00")
                        .GraceTimeMinutes = Shifts(0).GraceTimeMinutes
                        '.IsDayChanged = Shifts(0).IsDayChanged
                    End With
                    cntx.SaveChanges()

                    Try
                        PortalUtilities.fnCompare(CType(objShiftOld, Object), CType(objShift, Object), objShift.ShiftID, lstEmployeeAndCompanyID(0))
                    Catch ex As Exception

                    End Try

                    context.Response.ContentType = "application/json; charset=utf-8"
                    context.Response.Write(JsonStr)
                Else
                    context.Response.ContentType = "application/json; charset=utf-8"
                    Dim objErr As New Newtonsoft.Json.Linq.JObject
                    objErr.Add("Errors", "Shift Name Already Exist!")
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
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

            Dim JsonStr = context.Request("models")
            Dim Shifts = JsonConvert.DeserializeObject(Of List(Of clsShifts))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim strName As String = Shifts(0).Title.Trim().ToLower()
                Dim obj = (From tbl In cntx.Att_Shifts Where tbl.CompanyID = intCompanyID AndAlso tbl.IsDeleted = False AndAlso tbl.Title.Trim().ToLower() = strName Select tbl).FirstOrDefault

                If obj Is Nothing Then
                    Dim objShift = New PortalModel.Att_Shifts
                    With objShift
                        .Title = Shifts(0).Title
                        .TimingIn = TimeSpan.Parse(Shifts(0).TimingInHours & ":" & Shifts(0).TimingInMinutes & ":00")
                        .TimingOut = TimeSpan.Parse(Shifts(0).TimingOutHours & ":" & Shifts(0).TimingOutMinutes & ":00")
                        .GraceTimeMinutes = Shifts(0).GraceTimeMinutes
                        '.IsDayChanged = Shifts(0).IsDayChanged
                        .IsDeleted = False
                        .CreatedDate = Date.Now.Date
                        .InsertedBy = lstEmployeeAndCompanyID(0)
                        .CompanyID = lstEmployeeAndCompanyID(1)
                    End With


                    cntx.Att_Shifts.AddObject(objShift)
                    cntx.SaveChanges()

                    context.Response.ContentType = "application/json; charset=utf-8"
                    context.Response.Write(JsonStr)

                Else
                    context.Response.ContentType = "application/json; charset=utf-8"
                    Dim objErr As New Newtonsoft.Json.Linq.JObject
                    objErr.Add("Errors", "Shift Name Already Exist!")
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
            Dim Shifts = JsonConvert.DeserializeObject(Of List(Of clsShifts))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim obj = New PortalModel.Att_Shifts With {.ShiftID = Shifts(0).ShiftID}
                cntx.Att_Shifts.Attach(obj)
                obj.IsDeleted = True
                obj.DeletedBy = lstEmployeeAndCompanyID(0)
                obj.DeletedDate = DateTime.Now

                'cntx.Brands.DeleteObject(objBrands)
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
    
    
    
    
    Private Sub getListHoliday(ByVal context As HttpContext)
        Try
            

            Using cntx As New PortalModel.PortalEntities
                Dim obj = cntx.Holidays.Where(Function(f) f.IsDeleted = False).ToList

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


    Private Sub editHoliday(ByVal context As HttpContext, ByVal intID As Integer)
        Dim output As String = ""
        Try
           

            Dim JsonStr = context.Request("models")
            Dim Holiday = JsonConvert.DeserializeObject(Of List(Of clsHoliday))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim strName As String = Holiday(0).Title.Trim().ToLower()
                Dim HolidayID As Integer = Holiday(0).HolidayID
                Dim dt As Date = Convert.ToDateTime(Holiday(0).HolidayDate).Date
                Dim obj = (From tbl In cntx.Holidays Where tbl.IsDeleted = False AndAlso tbl.HolidayID <> HolidayID AndAlso tbl.HolidayDate.Value = dt Select tbl).FirstOrDefault

                If obj Is Nothing Then
                    Dim objHoliday = cntx.Holidays.Where(Function(f) f.HolidayID = HolidayID).ToList().FirstOrDefault()
                    Dim objHolidayOld = New PortalModel.PortalEntities().Holidays.Where(Function(f) f.HolidayID = HolidayID).ToList().FirstOrDefault()
                    cntx.Holidays.Attach(objHoliday)
                    With objHoliday
                        .Title = Holiday(0).Title.Trim()
                        .HolidayDate = Holiday(0).HolidayDate
                    End With
                    cntx.SaveChanges()

                    Try
                        PortalUtilities.fnCompare(CType(objHolidayOld, Object), CType(objHoliday, Object), objHoliday.HolidayID, lstEmployeeAndCompanyID(0))
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

    Private Sub addHoliday(ByVal context As HttpContext, ByVal intID As Integer)
        Dim output As String = ""
        Try

            Dim JsonStr = context.Request("models")
            Dim Holiday = JsonConvert.DeserializeObject(Of List(Of clsHoliday))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim strName As String = Holiday(0).Title.Trim().ToLower()
                Dim dt As Date = Convert.ToDateTime(Holiday(0).HolidayDate).Date
                Dim obj = (From tbl In cntx.Holidays Where tbl.IsDeleted = False AndAlso tbl.HolidayDate.Value = dt Select tbl).FirstOrDefault

                If obj Is Nothing Then
                    Dim objHoliday = New PortalModel.Holidays
                    With objHoliday
                        .Title = Holiday(0).Title
                        .HolidayDate = Holiday(0).HolidayDate
                        .IsDeleted = False
                        .InsertedDate = Date.Now.Date
                        .InsertedBy = lstEmployeeAndCompanyID(0)
                    End With


                    cntx.Holidays.AddObject(objHoliday)
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

    Private Sub deleteHoliday(ByVal context As HttpContext, ByVal intID As Integer)
        Dim output As String = ""
        Try

            Dim JsonStr = context.Request("models")
            Dim Holiday = JsonConvert.DeserializeObject(Of List(Of clsHoliday))(JsonStr)

            Using cntx As New PortalModel.PortalEntities
                Dim obj = New PortalModel.Holidays With {.HolidayID = Holiday(0).HolidayID}
                cntx.Holidays.Attach(obj)
                obj.IsDeleted = True
                obj.DeletedBy = lstEmployeeAndCompanyID(0)
                obj.DeletedDate = DateTime.Now

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