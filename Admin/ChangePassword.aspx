<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    CodeFile="ChangePassword.aspx.vb" Inherits="Admin_ChangePassword" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">
        Change Password</h1>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" runat="Server">
    <form class="form-horizontal fv-form fv-form-bootstrap" id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div class="panel">
        <div class="panel-body">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="form-group">
                        <asp:Label ID="lblStatus" runat="server" SkinID="lblRedText"></asp:Label>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            User Name:
                        </label>
                        <label class="col-sm-8 control-label" style="text-align: left;">
                            <asp:Label ID="lblUserName" runat="server" Font-Bold="True"></asp:Label>
                        </label>
                    </div>
                    <div class="form-group col-sm-6" runat="server" visible=false >
                        <label class="col-sm-4 control-label">
                            User Role:
                        </label>
                        <label class="col-sm-8 control-label" style="text-align: left;">
                            <asp:Label ID="lblUserRole" runat="server" Font-Bold="True"></asp:Label>
                        </label>
                    </div>
                    
                    <div class="clearfix">
                    </div>
                    <div class="row">
                        <hr />
                    </div>
                    <div class="clearfix">
                    </div>
                    <%--<div class="row" style="    margin-bottom: 10px;">
                        <h3>
                            Update Email Address</h3>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            Email Address:
                        </label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="txtEmailAddress" runat="server" Width="450px" MaxLength="150" CssClass="form-control"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="re1" runat="server" ControlToValidate="txtEmailAddress"
                                ErrorMessage="invalid!" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                ValidationGroup="eml" Display="Dynamic"></asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator ID="rv5" runat="server" ControlToValidate="txtEmailAddress"
                                ErrorMessage="required!" ForeColor="Red" ValidationGroup="eml" Display=Dynamic></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="row" style="text-align: center;">
                        <asp:Button ID="btnUpdateEmail" runat="server" Text="  Update Email Address" ValidationGroup="eml"
                            CssClass="btn btn-primary" />
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="row">
                        <hr />
                    </div>
                    <div class="clearfix">
                    </div>--%>
                    <%--<div class="row" style="    margin-bottom: 10px;">
                        <h3>
                            Change Password</h3>
                    </div>
                    <div class="clearfix">
                    </div>--%>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            New Password:
                        </label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="txtPassword" runat="server" Width="450px" TextMode="Password" MaxLength="20"
                                CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rv3" runat="server" ControlToValidate="txtPassword"
                                ErrorMessage="required!" ForeColor="Red" ValidationGroup="add" Display=Dynamic></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            Confirm Password:
                        </label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="txtConfirmPassword" runat="server" Width="450px" TextMode="Password"
                                MaxLength="20" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rv4" runat="server" ControlToValidate="txtConfirmPassword"
                                ErrorMessage="required!" ForeColor="Red" ValidationGroup="add" Display=Dynamic></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtPassword"
                                ControlToValidate="txtConfirmPassword" ErrorMessage="&lt;br&gt;Password does not match with confirm password!"
                                ForeColor="Red" ValidationGroup="add" Display=Dynamic></asp:CompareValidator>
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="row" style="text-align: center;">
                        <asp:Button ID="btnChangePassword" runat="server" Text="  Change Password  " ValidationGroup="add"
                            CssClass="btn btn-primary" />
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <%--<script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>--%>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/js/components/panel.js") %>"></script>
    <%--<script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/jquery-ui/jquery-ui.js") %>"></script>--%>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/bootstrap-datepicker/bootstrap-datepicker.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootstrap-datepicker.js") %>"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (args.get_isPartialLoad()) {

            }
        }
    </script>
</asp:Content>
