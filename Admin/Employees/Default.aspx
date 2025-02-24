<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="Admin_Employees_Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <link rel="stylesheet" href="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.css") %>" />
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.css") %>"
        rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style2 {
        }

        .style3 {
            width: 193px;
            height: 20px;
        }

        .style4 {
            height: 20px;
        }

        .txtRight {
            text-align: right !important;
        }

        .txtCenter {
            text-align: center !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="Server">
    <asp:Label class="page-title h1" runat="server" ID="lblHeading">
        New Employee</asp:Label>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" runat="Server">
    <form class="form-horizontal fv-form fv-form-bootstrap" id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="panel">
            <div class="panel-body">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:Label ID="lblStatus" runat="server"></asp:Label>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">
                                Name: <span style="color: Red;">*</span></label>
                            <div class="col-sm-4 control-label" style="text-align: left;">
                                <asp:Label ID="lblFirstName" runat="server" Font-Bold="True"></asp:Label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="100"
                                    ValidationGroup="Save"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtFirstName"
                                    ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <label class="col-sm-2 control-label">
                                CNIC: <span style="color: Red;">*</span></label>
                            <div class="col-sm-4 control-label" style="text-align: left;">
                                <asp:Label ID="lblCNIC" runat="server" Font-Bold="True"></asp:Label>
                                <asp:TextBox ID="txtCNIC" runat="server" CssClass="form-control" MaxLength="100"
                                    ValidationGroup="Save"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCNIC"
                                    ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">
                                Department: <span style="color: Red;">*</span></label>
                            <div class="col-sm-4 control-label" style="text-align: left;">
                                <asp:Label ID="lblDept" runat="server" Font-Bold="True"></asp:Label>
                                <asp:DropDownList runat="server" ID="ddlDept" CssClass="form-control">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="ddlDept"
                                    ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <label class="col-sm-2 control-label">
                                Code: <span style="color: Red;">*</span>
                            </label>
                            <div class="col-sm-4 control-label" style="text-align: left;">
                                <asp:Label ID="lblEmpCode" runat="server" Font-Bold="True"></asp:Label>
                                <asp:TextBox ID="txtEmpCode" runat="server" CssClass="form-control" MaxLength="100"
                                    ValidationGroup="Save"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtEmpCode"
                                    ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">
                                Designation:
                            </label>
                            <div class="col-sm-4 control-label" style="text-align: left;">
                                <asp:Label ID="lblDesignation" runat="server" Font-Bold="True"></asp:Label>
                                <asp:DropDownList runat="server" ID="ddlDesignation" CssClass="form-control">
                                </asp:DropDownList>
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ddlDesignation"
                                ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                            </div>
                            <label class="col-sm-2 control-label">
                                Scale:
                            </label>
                            <div class="col-sm-4 control-label" style="text-align: left;">
                                <asp:Label ID="lblScale" runat="server" Font-Bold="True"></asp:Label>
                                <asp:DropDownList runat="server" ID="ddlScale" CssClass="form-control">
                                </asp:DropDownList>
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="ddlScale"
                                ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>--%>
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">
                                Gender: <span style="color: Red;">*</span></label>
                            <div class="col-sm-4 control-label" style="text-align: left;">
                                <asp:Label ID="lblGender" runat="server" Font-Bold="True"></asp:Label>
                                <asp:DropDownList runat="server" ID="ddlGender" CssClass="form-control">
                                    <asp:ListItem Value="" Text="-- Select --"></asp:ListItem>
                                    <asp:ListItem Value="Male" Text="Male"></asp:ListItem>
                                    <asp:ListItem Value="Female" Text="Female"></asp:ListItem>
                                    <asp:ListItem Value="Other" Text="Other"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="ddlGender"
                                    ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-sm-4 control-label" style="text-align: left;">
                                <div class="checkbox-custom checkbox-primary" id="divChkExempt" runat="server">
                                    <asp:CheckBox ID="chkIsExempt" runat="server" ClientIDMode="Static" Checked="false" />
                                    <label for="chkIsExempt">
                                        Is Attendance Exempt?</label>
                                </div>
                                <asp:Label ID="lblIsExempt" runat="server" Font-Bold="true" />
                            </div>
                        </div>
                        <div class="clearfix">
                            <div class="form-group">
                                <div class="col-sm-2 control-label">
                                    <div class="checkbox-custom checkbox-primary" id="divRetired" runat="server">
                                        <asp:CheckBox ID="chkIsRetired" runat="server" ClientIDMode="Static" Checked="false" />
                                        <label for="chkIsRetired">
                                            Is Retired?</label>
                                    </div>
                                    <asp:Label ID="lblIsRetired" runat="server" Font-Bold="true" />
                                </div>

                                <div class="col-sm-4"></div>

                                <label class="col-sm-2 control-label">
                                    Remarks:
                                </label>
                                <div class="col-sm-4 control-label" style="text-align: left;">
                                    <asp:Label ID="lblRemarks" runat="server" Font-Bold="True"></asp:Label>
                                    <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" MaxLength="200" TextMode="MultiLine" Rows="3"
                                        ValidationGroup="Save"></asp:TextBox>
                                </div>

                            </div>
                        </div>
                        <div class="clearfix">
                        </div>
                        <div class="form-group" id="divImg" runat="server" visible="false">
                            <div class="col-sm-6 text-right">
                                <asp:Image ID="imgBio" runat="server" Width="90" Height="90" Visible="false" />
                            </div>
                            <div class="col-sm-6">
                                <asp:Image ID="imgCam" runat="server" Width="90" Height="90" Visible="false" />
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>
                        <div class="form-group text-center">
                            <asp:HiddenField ID="hdnEmployeeID" runat="server" Value="0" />
                            <asp:Button ID="btnSave" runat="server" Text="Save Employee" ValidationGroup="Save"
                                CssClass="btn btn-primary" ClientIDMode="Static" Style="margin: 10px; margin-right: 30px;" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/panel.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootstrap-datepicker.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.js") %>"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            jQuery("#<%=ddlDept.ClientID %>").select2();
            jQuery("#<%=ddlDesignation.ClientID %>").select2();
            jQuery("#<%=ddlScale.ClientID %>").select2();
            if (args.get_isPartialLoad()) {
                jQuery("#<%=ddlDept.ClientID %>").select2();
                jQuery("#<%=ddlDesignation.ClientID %>").select2();
                jQuery("#<%=ddlScale.ClientID %>").select2();
            }
        }
    </script>
</asp:Content>
