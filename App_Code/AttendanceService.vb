Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Web.Script.Services
Imports PortalModel

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
<ScriptService()>
Public Class AttendanceService
    Inherits System.Web.Services.WebService

    Private Const SecretToken As String = "gZM0UST8wfhxEAT7kzhCuTSLz1MDh7RozDxCKLlO1srSvPUgtXcvS0eW0FTRtHqI"

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Function SubmitAttendance(ByVal empCode As Integer, ByVal attendanceTime As Date) As String
        Try

            'Get token from HTTP headers
            Dim token As String = HttpContext.Current.Request.Headers("Authorization")

            ' Check if token is valid
            'If String.IsNullOrEmpty(token) OrElse token <> SecretToken Then
            '    Return "{""status"":""error"", ""message"":""Unauthorized Access!""}"
            'End If

            Dim AttendanceType As Integer = 1
            Dim attendanceDate As Date = attendanceTime.Date ' Extract only the date part
            Using db As New PortalEntities()

                If Not db.HR_Att_Logs.Any(Function(x) x.EmpCode = empCode AndAlso
                               x.AttendanceTime.HasValue AndAlso
                               x.AttendanceTime.Value.Year = attendanceTime.Year AndAlso
                               x.AttendanceTime.Value.Month = attendanceTime.Month AndAlso
                               x.AttendanceTime.Value.Day = attendanceTime.Day) Then
                    AttendanceType = 0
                End If


                Dim ShiftId = db.Att_Shifts_Users.FirstOrDefault(Function(x) x.UserID = empCode).ShiftID
                Dim newAttendance As New HR_Att_Logs With {
                    .EmpCode = empCode,
                    .AttendanceTime = attendanceTime,
                    .AttendanceType = AttendanceType,
                    .VerifyType = 4,
                    .DeviceID = 1,
                    .InsertedDateTime = DateTime.Now
                }
                db.HR_Att_Logs.AddObject(newAttendance)
                db.SaveChanges()

                Dim Attendance As New HR_Att_Records With {
                    .EmpCode = empCode,
                    .EmpID = empCode,
                    .AttendanceDateTime = attendanceTime,
                    .AttendanceType = AttendanceType,
                    .VerifyType = 4,
                    .DeviceID = 1,
                    .ShiftID = ShiftId,
                    .InsertedDateTime = DateTime.Now
                }
                db.HR_Att_Records.AddObject(Attendance)
                db.SaveChanges()

            End Using
            Return "{""status"":""success"", ""message"":""Attendance recorded successfully!""}"
        Catch ex As Exception
            Return "{""status"":""error"", ""message"":""" & ex.Message & """}"
        End Try
    End Function

End Class