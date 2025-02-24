<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false" CodeFile="ListUsers.aspx.vb" Inherits="Admin_Users_ListUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" Runat="Server">
    <h1 class="page-title">
        List Users</h1>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" Runat="Server">
    <form id="form1" runat="server" class="form-horizontal fv-form fv-form-bootstrap">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
             <ContentTemplate>
    <div class="panel">
        <div class="panel-body">
            <asp:Label ID="lblStatus" runat="server" SkinID="lblRedText"></asp:Label>
            <div class="form-group">
                <label class="col-sm-3 control-label">
                    Select Group:</label>
                <div class="col-sm-9">
                    <asp:DropDownList runat="server" ID="ddlDept" CssClass="form-control" 
                        AutoPostBack="True"></asp:DropDownList>
                </div>
            </div>
            
        </div>
    </div>

    <div class="panel" id="pnlDetails" runat="server" visible="False">
        <div class="panel-body">
                <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False" 
                    CellPadding="5" CssClass="table table-hover table-striped table-bordered" 
                    DataKeyNames="EmployeeID" Width="100%">
                    <AlternatingRowStyle CssClass="grdAltRow" />
                    <Columns>
                        <asp:BoundField DataField="UserName" HeaderText="User Name">
                        <HeaderStyle HorizontalAlign="Left" />
                        <ItemStyle HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="EmpName" HeaderText="Employee">
                        <HeaderStyle HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:TemplateField ShowHeader="False" HeaderText="Status">
                    <ItemTemplate>
                        <asp:ImageButton ID="imgStatus" runat="server" CausesValidation="False" 
                            CommandName="chngStatus" CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>'
                            ImageUrl="~/Admin/images/icoactive.png"
                            OnClientClick="javascript:return confirm('Are you sure you want to block / unblock user?');" />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="imgPwd" runat="server" CausesValidation="False" 
                            CommandName="chngPwd" CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>'
                            ImageUrl="~/Admin/images/changepwd.png" 
                            OnClientClick="javascript:return confirm('Are you sure you want to reset the password?');" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="100px" />
                    </asp:TemplateField>
                    <%--<asp:TemplateField ShowHeader="False">
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButton2" runat="server" CausesValidation="False" 
                                CommandName="Delete" ImageUrl="~/Admin/images/delete.gif" 
                                OnClientClick="javascript:return confirm('Are you sure you want to delete this User?');" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="100px" />
                    </asp:TemplateField>--%>
                      
                    </Columns>
                    <HeaderStyle CssClass="grdHead" />
                </asp:GridView>
        </div>
    </div>
    </ContentTemplate>
            </asp:UpdatePanel>
</form>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="FooterScriptContents" Runat="Server">
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>
<script src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/formvalidation/formValidation.min.js") %>"></script>
  <script src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/formvalidation/framework/bootstrap.min.js") %>"></script>

</asp:Content>




