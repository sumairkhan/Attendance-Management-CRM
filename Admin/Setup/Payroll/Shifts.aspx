<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    CodeFile="Shifts.aspx.vb" Inherits="Admin_Setup_Payroll_Shifts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.common.min.css") %>"
        rel="stylesheet" type="text/css" />
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.default.min.css") %>"
        rel="stylesheet" type="text/css" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">Shifts Managament</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContents" runat="Server">
    <div id="example">
        <div id="grid">
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/bootbox/bootbox.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootbox.js") %>"></script>
    <script type="text/javascript">
        var hours = [
            { value: "0", text: "0" },
            { value: "1", text: "1" },
            { value: "2", text: "2" },
            { value: "3", text: "3" },
            { value: "4", text: "4" },
            { value: "5", text: "5" },
            { value: "6", text: "6" },
            { value: "7", text: "7" },
            { value: "8", text: "8" },
            { value: "9", text: "9" },
            { value: "10", text: "10" },
            { value: "11", text: "11" },
            { value: "12", text: "12" },
            { value: "13", text: "13" },
            { value: "14", text: "14" },
            { value: "15", text: "15" },
            { value: "16", text: "16" },
            { value: "17", text: "17" },
            { value: "18", text: "18" },
            { value: "19", text: "19" },
            { value: "20", text: "20" },
            { value: "21", text: "21" },
            { value: "22", text: "22" },
            { value: "23", text: "23" }
        ];


        var minutes = [
            { value: "0", text: "0" },
            { value: "1", text: "1" },
            { value: "2", text: "2" },
            { value: "3", text: "3" },
            { value: "4", text: "4" },
            { value: "5", text: "5" },
            { value: "6", text: "6" },
            { value: "7", text: "7" },
            { value: "8", text: "8" },
            { value: "9", text: "9" },
            { value: "10", text: "10" },
            { value: "11", text: "11" },
            { value: "12", text: "12" },
            { value: "13", text: "13" },
            { value: "14", text: "14" },
            { value: "15", text: "15" },
            { value: "16", text: "16" },
            { value: "17", text: "17" },
            { value: "18", text: "18" },
            { value: "19", text: "19" },
            { value: "20", text: "20" },
            { value: "21", text: "21" },
            { value: "22", text: "22" },
            { value: "23", text: "23" },
            { value: "24", text: "24" },
            { value: "25", text: "25" },
            { value: "26", text: "26" },
            { value: "27", text: "27" },
            { value: "28", text: "28" },
            { value: "29", text: "29" },
            { value: "30", text: "30" },
            { value: "31", text: "31" },
            { value: "32", text: "32" },
            { value: "33", text: "33" },
            { value: "34", text: "34" },
            { value: "35", text: "35" },
            { value: "36", text: "36" },
            { value: "37", text: "37" },
            { value: "38", text: "38" },
            { value: "39", text: "39" },
            { value: "40", text: "40" },
            { value: "41", text: "41" },
            { value: "42", text: "42" },
            { value: "43", text: "43" },
            { value: "44", text: "44" },
            { value: "45", text: "45" },
            { value: "46", text: "46" },
            { value: "47", text: "47" },
            { value: "48", text: "48" },
            { value: "49", text: "49" },
            { value: "50", text: "50" },
            { value: "51", text: "51" },
            { value: "52", text: "52" },
            { value: "53", text: "53" },
            { value: "54", text: "54" },
            { value: "55", text: "55" },
            { value: "56", text: "56" },
            { value: "57", text: "57" },
            { value: "58", text: "58" },
            { value: "59", text: "59" }
        ];


        $(document).ready(function () {
            dataSource = new kendo.data.DataSource({
                transport: {
                    read: {
                        url: "shifts.ashx?action=1",
                        dataType: "json"
                    },
                    update: {
                        url: "shifts.ashx?action=2",
                        dataType: "json"
                    },
                    destroy: {
                        url: "shifts.ashx?action=4",
                        dataType: "json"
                    },
                    create: {
                        url: "shifts.ashx?action=3",
                        dataType: "json"
                    },
                    parameterMap: function (options, operation) {
                        if (operation !== "read" && options.models) {
                            return { models: kendo.stringify(options.models) };
                        }
                    }
                },
                batch: true,
                //pageSize: 20,
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
                    data: "list",
                    errors: "Errors",
                    model: {
                        id: "ShiftID",
                        fields: {
                            ShiftID: { editable: false, nullable: true },
                            Title: { validation: { required: { message: "Title is required." } } },
                            TimingInHours: { validation: { required: { message: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Timing In (Hours) is required." } } },
                            TimingInMinutes: { validation: { required: { message: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Timing In (Minutes) is required." } } },
                            TimingOutHours: { validation: { required: { message: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Timing Out (Hours) is required." } } },
                            TimingOutMinutes: { validation: { required: { message: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Timing Out (Minutes) is required." } } },
                            GraceTimeMinutes: { validation: { required: { message: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Grace Time (Minutes) is required." } } },
                            //IsDayChanged: { type: "boolean" }

                        }
                    }
                }
            });

            $("#grid").kendoGrid({
                dataSource: dataSource,
                sortable: true,
                reorderable: true,
                resizable: true,
                filterable: true,
                columnMenu: true,
                pageable: {
                    refresh: true,
                    pageSizes: true
                },
                height: 550,
                toolbar: ["create"],
                columns: [
                    { field: "Title", title: "Title" },
                    { field: "TimingInHours", title: "Timing In (Hours) ", width: "120px" },
                    { field: "TimingInMinutes", title: "Timing In (Minutes) ", width: "120px" },
                    { field: "TimingOutHours", title: "Timing Out (Hours) ", width: "120px" },
                    { field: "TimingOutMinutes", title: "Timing Out (Minutes) ", width: "120px" },
                    { field: "GraceTimeMinutes", title: "Grace Time (Minutes) ", width: "120px" },
                    //{ field: "IsDayChanged", title: "Is Changed Day?", width: "150px", template: "#= IsDayChanged ? 'Yes' : 'No' #" },
                    //{ command: ["edit", "destroy"], title: "&nbsp;", width: "250px"}],
                    {
                        command: [
                            { name: "edit", text: { edit: "Edit", update: "Save", cancel: "Cancel" } },
                            {
                                name: "Delete",
                                //text: "Erase",
                                click: function (e) {
                                    var tr = $(e.target).closest("tr"); //get the row for deletion
                                    var data = this.dataItem(tr); //get the row data so it can be referred later
                                    bootbox.dialog({
                                        message: "Are you sure to delete shift: " + data.Title + "?",
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

                },
                edit: function (e) {
                    if (e.model.isNew()) {
                        e.container.kendoWindow("title", "Add")
                    }

                    TimingInHours = $("[name=TimingInHours]");

                    $(TimingInHours).kendoDropDownList({
                        valuePrimitive: true,
                        dataTextField: "text",
                        dataValueField: "value",
                        dataSource: hours,
                        optionLabel: "-- Select --",
                        index: 0,

                    });

                    TimingInMinutes = $("[name=TimingInMinutes]");

                    $(TimingInMinutes).kendoDropDownList({
                        valuePrimitive: true,
                        dataTextField: "text",
                        dataValueField: "value",
                        dataSource: minutes,
                        optionLabel: "-- Select --",
                        index: 0,

                    });

                    TimingOutHours = $("[name=TimingOutHours]");

                    $(TimingOutHours).kendoDropDownList({
                        valuePrimitive: true,
                        dataTextField: "text",
                        dataValueField: "value",
                        dataSource: hours,
                        optionLabel: "-- Select --",
                        index: 0,

                    });

                    TimingOutMinutes = $("[name=TimingOutMinutes]");

                    $(TimingOutMinutes).kendoDropDownList({
                        valuePrimitive: true,
                        dataTextField: "text",
                        dataValueField: "value",
                        dataSource: minutes,
                        optionLabel: "-- Select --",
                        index: 0,

                    });

                    GraceTimeMinutes = $("[name=GraceTimeMinutes]");

                    $(GraceTimeMinutes).kendoDropDownList({
                        valuePrimitive: true,
                        dataTextField: "text",
                        dataValueField: "value",
                        dataSource: minutes,
                        optionLabel: "-- Select --",
                        index: 0,

                    });

                },
            });
        });
    </script>
    <script type="text/javascript">
        function error(args) {
            if (args.errors) {
                var grid = $("#grid").data("kendoGrid");
                grid.one("dataBinding", function (ev) {
                    ev.preventDefault();
                    bootbox.alert(args.errors);
                    grid.cancelChanges();
                });
            }
        }


    </script>
</asp:Content>
