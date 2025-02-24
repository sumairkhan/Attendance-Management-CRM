<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta content="" name="description" />
    <meta content="themes-lab" name="author" />
    <link rel="shortcut icon" href="assets/img/favicon.png">
    <link href="Styles/style.css" rel="stylesheet">
    <link href="Styles/ui.css" rel="stylesheet">
    <link href="Styles/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="Styles/line-icons.css" rel="stylesheet" type="text/css" />
    <link href="Styles/simple-line-icons.css" rel="stylesheet" type="text/css" />
    <%--<link href="assets/plugins/bootstrap-loading/lada.min.css" rel="stylesheet">--%>
</head>
<body class="account2" data-page="login">
    <form id="form1" runat="server" class="form-signin" role="form">
    <!-- BEGIN LOGIN BOX -->
    <div class="container" id="login-block">
        <i class="user-img icons-faces-users-03"></i>
        <div class="account-info" style="text-align: center;">
            <img src="logo-white.png" width="60" height="60" style="background-color: white;" />
            <%--<a href="#" class="logo"></a> --%>
            <%--<h4>Welcome to Smart System</h4>--%>
            <ul>
                <li><i class="icon-arrow-right"></i>Automated Solution</li>
                <li><i class="icon-arrow-right"></i>Intregated Modules</li>
                <li><i class="icon-arrow-right"></i>User Friendly Interface</li>
                <li><i class="icon-arrow-right"></i>Responsive Layout</li>
                <%--<li><i class="icon-drop"></i> Colors options</li>--%>
            </ul>
        </div>
        <div class="account-form">
            <%--<form class="form-signin" role="form">--%>
            <asp:Login ID="LoginUser" runat="server" EnableViewState="false" DestinationPageUrl="~/Admin/"
                FailureText="">
                <LayoutTemplate>
                    <h3>
                        <strong>Sign in</strong> to your account</h3>
                    <div class="append-icon">
                        <asp:TextBox ID="UserName" runat="server" CssClass="form-control form-white username"
                            placeholder="Username" required></asp:TextBox>
                        <%--<input type="text" name="name" id="name" class="form-control form-white username" placeholder="Username" required>--%>
                        <i class="icon-user"></i>
                    </div>
                    <div class="append-icon m-b-20">
                        <asp:TextBox ID="password" runat="server" CssClass="form-control form-white password"
                            placeholder="Password" required TextMode="Password"></asp:TextBox>
                        <%--<input type="password" name="password" class="form-control form-white password" placeholder="Password" required>--%>
                        <i class="icon-lock"></i>
                    </div>
                    <asp:Button runat="server" type="submit" ID="btnsubmit" class="btn btn-lg btn-dark btn-rounded ladda-button"
                        CommandName="Login" Text="Sign In" />
                    <span class="col-lg-12" style="padding-top: 20px;">
                        <asp:Label runat="server" ID="lblErr" Visible="false" Text="Invalid User Name or Password"
                            ForeColor="Red"></asp:Label></span>
                    <%--<span class="forgot-password"><a id="password" href="account-forgot-password.html">Invalid User Name or Password</a></span>--%>
                </LayoutTemplate>
            </asp:Login>
            <div class="form-footer">
                <div class="clearfix">
                    <p class="new-here">
                        <a href="user-signup-v2.html"></a>
                    </p>
                </div>
            </div>
        </div>
    </div>
    <p class="account-copyright">
        <span>Copyright ©
            <%= DateTime.Now.Year %>
            GCS (Pvt) Ltd. </span><span></span><span>All rights reserved.</span>
    </p>
    <%--        <script src="assets/plugins/jquery/jquery-1.11.1.min.js"></script>
        <script src="assets/plugins/jquery/jquery-migrate-1.2.1.min.js"></script>
        <script src="assets/plugins/gsap/main-gsap.min.js"></script>
        <script src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/plugins/backstretch/backstretch.min.js"></script>
        <script src="assets/plugins/bootstrap-loading/lada.min.js"></script>
    --%>
    <%--<script src="assets/js/pages/login-v2.js"></script>--%>
    </form>
</body>
</html>
