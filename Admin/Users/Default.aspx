<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="Admin_Users_Default" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <style type="text/css">
        .style2
        {
        }
        .style3
        {
            width: 193px;
            height: 20px;
        }
        .style4
        {
            height: 20px;
        }
        .txtRight
        {
            text-align:right !important;
        }
        .txtCenter
        {
            text-align:center !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">
        New User</h1>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" runat="Server">
<form class="form-horizontal fv-form fv-form-bootstrap" id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div class="panel">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
             <ContentTemplate>
             <asp:Label ID="lblStatus" runat="server"></asp:Label>
        <div class="panel-body">
            <div class="form-group">
                <label class="col-sm-2 control-label">
                    Group:</label>
                <div class="col-sm-10">
                        <asp:DropDownList runat="server" ID="ddlDept" CssClass="form-control" AutoPostBack="True"></asp:DropDownList>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">
                    Employee:</label>
                <div class="col-sm-10">
                        <asp:DropDownList runat="server" ID="ddlEmployee" CssClass="form-control"></asp:DropDownList>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">
                    Login Name:</label>
                <div class="col-sm-10">
                    <asp:TextBox ID="txtLoginName" name="txtLoginName" runat="server" data-fv-field="txtLoginName"
                        CssClass="form-control" MaxLength="20" ValidationGroup="Save"></asp:TextBox>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">
                    Password:</label>
                <div class="col-sm-10">
                    <asp:TextBox ID="txtPassword" name="txtPassword" runat="server" data-fv-field="txtPassword"
                        CssClass="form-control" MaxLength="20" ValidationGroup="Save" TextMode="Password"></asp:TextBox>
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">
                    Confirm Password:</label>
                <div class="col-sm-10">
                    <asp:TextBox ID="txtConfirmPassword" name="txtConfirmPassword" runat="server" data-fv-field="txtConfirmPassword"
                        CssClass="form-control" MaxLength="20" ValidationGroup="Save" TextMode="Password"></asp:TextBox>
                </div>
            </div>
            <div class="form-group text-right">

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ddlDept"
                    ErrorMessage="Department is required!..." ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator> 

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="ddlEmployee"
                    ErrorMessage="Employee is required!..." ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator> 

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtLoginName"
                    ErrorMessage="Login Name is required!..." ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator> 

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required!..." ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator> 

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtConfirmPassword"
                    ErrorMessage="Confirm Password is required!..." ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator> 

                    <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="Password does not match with confirm password..." ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword"></asp:CompareValidator>

                    <asp:Button ID="btnSave" runat="server" Text="Create User" 
                        ValidationGroup="Save" CssClass="btn btn-primary" 
                    ClientIDMode="Static" />
                </div>
        </div>
    </ContentTemplate>
            </asp:UpdatePanel>   
    </div>
    
    
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <%--<script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>--%>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/panel.js") %>"></script>
</asp:Content>





