<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    CodeFile="Shift_Users.aspx.vb" Inherits="Admin_Setup_Payroll_Shift_Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.common.min.css") %>"
        rel="stylesheet" type="text/css" />
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.default.min.css") %>"
        rel="stylesheet" type="text/css" />
    <style type="text/css">
        .k-window {
            width: 50%;
        }

        .k-edit-form-container {
            width: 100%;
        }


        .k-edit-field {
            width:75%;
        }

        .k-edit-label {
            width:15%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">Employee's Shift Management</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContents" runat="Server">
    <div class="form-group">
        <div class="input-group">
            <span class="input-group-addon"><i class="fa fa-search"></i></span>
            <input type="text" id="txtSearch" class="form-control" placeholder="Search..." />
        </div>

    </div>
    <div id="grid">
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/bootbox/bootbox.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootbox.js") %>"></script>
    <script type="text/javascript">

        var wnd, detailsTemplate;
        $(document).ready(function () {
            dataSource = new kendo.data.DataSource({
                transport: {
                    read: {
                        url: "shift_users.ashx?action=1",
                        dataType: "json"
                    },
                    update: {
                        url: "shift_users.ashx?action=2",
                        dataType: "json"
                    },
                    destroy: {
                        url: "shift_users.ashx?action=4",
                        dataType: "json"
                    },
                    create: {
                        url: "shift_users.ashx?action=3",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation !== "read" && options.models) {
                            return { models: kendo.stringify(options.models) };
                        }
                    }
                },
                batch: true,
                //pageSize: 200000,
                requestEnd: function (e) {
                    if (e.type === "update") {
                        this.read();
                    }
                    if (e.type === "create") {
                        this.read();
                    }
                },
                error: error,
                schema: {
                    data: "datalist",
                    errors: "Errors",
                    model: {
                        id: "Shifts_UserID",
                        fields: {
                            Shifts_UserID: { editable: false, nullable: true },
                            ShiftID: { validation: { required: { message: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Shift is Required!" } } },
                            UserID: { validation: { required: { message: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Employee is Required!" } } },
                            //CreatedDate: { validation: { hidden: true } }
                        }
                    }
                }
            });

            $("#grid").kendoGrid({
                dataSource: dataSource,
                pageable: {
                    refresh: true,
                    pageSizes: true
                },
                sortable: true,
                reorderable: true,
                resizable: true,
                //filterable: true,
                //columnMenu: true,
                height: 550,
                toolbar: ["create"],
                columns: [
                    { field: "ShiftID", title: "Shift ", hidden: true },
                    { field: "ShiftTitle", title: "Shift " },
                    { field: "UserID", title: "Employee ", hidden: true },
                    { field: "EmployeeName", title: "Employee (Department) " },
                    //{ field: "CreatedDate", title: "Date ", template: "#= CreatedDate==null?'': kendo.toString(kendo.parseDate(CreatedDate, 'yyyy-MM-dd'), 'dd-MMM-yyyy') #" },
                    //{ command: ["edit", "destroy"], title: "&nbsp;", width: "180px"}],
                    {
                        command: [
                            { name: "edit" },
                            {
                                name: "Delete",
                                click: function (e) {
                                    var tr = $(e.target).closest("tr"); //get the row for deletion
                                    var data = this.dataItem(tr); //get the row data so it can be referred later
                                    bootbox.dialog({
                                        message: "Are you sure to delete user: " + data.EmployeeName + "?",
                                        title: "Confirm Delete",
                                        buttons: {
                                            danger: {
                                                label: "Delete",
                                                className: "btn-danger",
                                                callback: function () {
                                                    var grid = $("#grid").data("kendoGrid");
                                                    grid.dataSource.remove(data);
                                                    grid.dataSource.sync();
                                                    grid.refresh();
                                                }
                                            },
                                            main: {
                                                label: "Cancel",
                                                className: "btn-primary",
                                            }
                                        }
                                    });
                                }
                            }
                        ], title: "&nbsp;", width: "180px"
                    }],
                editable: "popup",
                requestEnd: function (e) {
                    $("#ShiftID").data('kendoDropDownList').select(1);
                    $("#UserID").data('kendoDropDownList').select(1);
                },
                edit: function (e) {
                    if (e.model.isNew()) {
                        e.container.kendoWindow("title", "Add Employee's Shift")
                    }


                    $("[name=CreatedDate]").hide();
                    $('label[for="CreatedDate"]').hide();

                    Shift = $("[name=ShiftID]");
                    $("[name=ShiftTitle]").hide();
                    $('label[for="ShiftTitle"]').hide();

                    $(Shift).width(400);
                    $(Shift).kendoDropDownList({
                        filter: "contains",
                        valuePrimitive: true,
                        dataTextField: "Title",
                        dataValueField: "ShiftID",
                        dataSource: ddlShift,
                        optionLabel: "-- Select Shift -",
                        index: 0,

                    });

                    Users = $("[name=UserID]");
                    $("[name=EmployeeName]").hide();
                    $('label[for="EmployeeName"]').hide();

                    $(Users).width(400);
                    $(Users).kendoDropDownList({
                        filter: "contains",
                        valuePrimitive: true,
                        dataTextField: "EmpName",
                        dataValueField: "EmployeeID",
                        dataSource: ddlUsers,
                        optionLabel: "-- Select Employee -",
                        index: 0,
                    });

                    
                    //$('.k-dropdown').css('width','400px');

                    CreatedDate = $("[name=CreatedDate]");
                    $(CreatedDate).kendoDatePicker({
                        start: "decade",
                        format: "dd-MMM-yyyy"
                    });
                },
            });




            ddlShift = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: "shift_users.ashx?action=5",
                    cache: false
                },
                schema: {
                    data: "datalist"
                }
            });


            ddlUsers = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: "shift_users.ashx?action=6",
                    cache: false
                },
                schema: {
                    data: "datalist"
                }
            });
        });
    </script>
    <script type="text/javascript">
        function error(args) {
            if (args.errors) {
                var grid = $("#grid").data("kendoGrid");
                grid.one("dataBinding", function (e) {
                    e.preventDefault();
                    bootbox.alert(args.errors);
                    grid.cancelChanges();
                });
            }
        }


    </script>

    <script type="text/javascript">
        $(function () {
            $("#txtSearch").keyup(function () {
                //$filter = new Array();
                var grid = $("#grid").data("kendoGrid");
                strSearch = $("#txtSearch").val();
                if (strSearch.trim() != "") {
                    //$filter.push({ field: "Product", operator: "contains", value: $strProduct });
                    //}
                    //grid.dataSource.filter($filter);
                    grid.dataSource.filter({
                        logic: "or",
                        filters: [
                            {
                                field: "ShiftTitle",
                                operator: "contains",
                                value: strSearch
                            },
                            {
                                field: "EmployeeName",
                                operator: "contains",
                                value: strSearch
                            }
                        ]
                    });
                }
                else {
                    grid.refresh();
                }
            });

        });
    </script>
</asp:Content>
