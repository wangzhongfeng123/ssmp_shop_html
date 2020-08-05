<%--
  Created by IntelliJ IDEA.
  User: 王忠峰
  Date: 2020/7/25
  Time: 20:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<!-- 引入bootstrap css文件 -->
<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="../bootstrap/css/bootstrap.dropdown.hack.css" rel="stylesheet" />
<!-- 引入bootstrap js文件(JQuery) -->
<script src="../bootstrap/js/jquery-3.3.1.min.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>
<!-- 引入datatables表格插件的css文件和js文件 -->
<link href="../js/DataTables/css/dataTables.bootstrap.min.css" rel="stylesheet" />
<script src="../js/DataTables/js/jquery.dataTables.min.js"></script>
<script src="../js/DataTables/js/dataTables.bootstrap.min.js"></script>
<!-- 引入bootbox相关js -->
<script src="../js/bootbox/bootbox.locales.min.js" type="text/javascript"></script>
<script src="../js/bootbox/bootbox.min.js" type="text/javascript"></script>
<%--  fileinput 插件--%>
<script src="../js/bootstrap-fileinput/js/fileinput.js"></script>
<link rel="stylesheet" href="../js/bootstrap-fileinput/css/fileinput.css">
<link href="../js/bootstrap-datetimepicker/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
<script src="../js/bootstrap-datetimepicker/js/moment-with-locales.js"></script>
<script src="../js/bootstrap-datetimepicker/js/bootstrap-datetimepicker.min.js"></script>
<%--ztree--%>
<%--<link rel="stylesheet" href="/js/zTree-zTree_v3-master/css/demo.css">--%>
<link rel="stylesheet" href="../js/zTree-zTree_v3-master/css/zTreeStyle/zTreeStyle.css">
<script rel="stylesheet" src="../js/zTree-zTree_v3-master/js/jquery.ztree.all.min.js"></script>
<!-- 引入datatables表格插件的css文件和js文件 -->
<link href="../js/DataTables/css/dataTables.bootstrap.min.css" rel="stylesheet" />
<script src="../js/DataTables/js/jquery.dataTables.min.js"></script>
<script src="../js/DataTables/js/dataTables.bootstrap.min.js"></script>

<%--引入validate插件--%>
<link href="../js/bootstrapvalidator-v0.5.2-0/dist/css/bootstrapValidator.css" rel="stylesheet" type="text/css">
<script src="../js/bootstrapvalidator-v0.5.2-0/dist/js/bootstrapValidator.js"></script>

<head>
    <title>Title</title>
</head>
<body>

<div class="panel panel-primary">
    <div class="panel-heading">视频列表</div>
    <div class="panel-body">
        <div style="margin-bottom:10px">
        </div>
        <table id="dataTable" class="table table-striped table-bordered">
            <thead>
            <tr>
                <th>
                    <input  id="checkAll" onclick="checkedAll()" type="checkbox" />
                </th>
                <th>用户名</th>
                <th>手机号</th>
                <th>地区</th>
                <th>图片</th>
                <th>注册时间</th>
                <th>操作</th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<div id="updateDiv" style="display:none;">
    <form id="updateCarWzfForm" class="form-horizontal" role="form">
        <input name="imagePath" id="id" type="hidden">
        <div class="form-group">
            <label class="col-md-2 control-label">用户名</label>
            <div class="col-md-6">
                <input id="updatevipName" class="form-control">
            </div>
        </div>
        <div class="form-group">
            <label class="col-md-2 control-label">手机号</label>
            <div class="col-md-6">
                <input id="updatevipPhone" class="form-control">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-md-2">地区</label>
            <div class="col-md-8">
                <select class="form-control" id="updateArea1" onchange="showCity()">
                    <option value="-1">请选择</option>
                </select>
                <select class="form-control" id="updateArea2" onclick="showCounty()">
                    <option value="-1">请选择</option>
                </select>
                <select class="form-control" id="updateArea3" >
                    <option value="-1">请选择</option>
                </select>
            </div>
        </div>


        <div class="form-group">
            <label class="col-md-2 control-label">图片</label>
            <div class="col-md-6">
                <img id="img" width="50">
                <input name="imagePath" id="upImagePath" type="hidden">
                <input name="image" type="file" id="upCarImgUrl">
            </div>
        </div>
    </form>
</div>
</body>

<script>
    
    $(function () {
        updateCarWzfDivHtml=  $("#updateDiv").html();
        initTableVip();
        selectCarWzf();
    })
    function search() {
        initTable.ajax.reload();
    }


    function initUpdateFileIput(){
        $("#updateCarWzfForm #upCarImgUrl").fileinput({
            language:"zh",
            previewFileType:"text,image",//设置需要预览的文件类型
            uploadClass:"btn btn-danger",//上传按钮的样式
            allowedFileTypes:["image","text"],////允许上传文件的类型
            allowedFileExtensions:["jpg","gif","txt","pdf"],//允许上传文件的后缀名
            maxFileSize:1024*20, //单位为kb 如果为0则不限制文件大小
            maxFileCount:5, //最大上传文件的数量限制
            uploadUrl:"/ShopController/uploadFile.do",
        })
    }

    function showUpdateCarDiv(vipId){
        initUpdateFileIput();
        selectCarWzf();
        var imgpath;
        //用于文件上传结果处理的回调函数，没上传一个文件就会调用一下这个函数
        $("#updateCarWzfForm #carImgUrl").on("fileuploaded",function(event,data,previewId,index){
            var result = data.response;
            if(result.status){
                $("#updateCarWzfForm #upImagePath").val(result.imgPath);
                imgpath=result.imgPath;
            }else {
                alert(result.message);
            }
        });
        $.post({
            data:{"vipId":vipId},
            dataType:"json",
            url:"/vip/selectVipShowById.do",
            async:false,
            success:function (re) {
                dat = re.data;
                console.log(dat)
                $("#updateCarWzfForm #id").val(dat.vipId);
                $("#updateCarWzfForm #updatevipName").val(dat.vipName);
                $("#updateCarWzfForm #updatevipPhone").val(dat.vipPhone);
                var cat=","+dat.area+",";
                debugger;
                for (var i = 0; i <car.length ; i++) {
                    if (car[i].pid==1){
                        if ((","+car[i].areaId+",").indexOf(cat)){
                            $("#updateCarWzfForm #updateArea1").append("<option selected value='"+car[i].areaId+"'>"+car[i].name+"</option>");
                            for (var j = 0; j <car.length ; j++) {
                                if (car[j].pid==car[i].areaId){
                                    if ((","+car[j].areaId+",").indexOf(cat)){
                                        $("#updateCarWzfForm #updateArea2").append("<option selected value='"+car[j].areaId+"'>"+car[j].name+"</option>");
                                        for (var k = 0; k <car.length ; k++) {
                                            if (car[k].pid==car[j].areaId){
                                                if ((","+car[k].areaId+",").indexOf(cat)){
                                                    $("#updateCarWzfForm #updateArea3").append("<option selected value='"+car[k].areaId+"'>"+car[k].name+"</option>");
                                                } else{
                                                    $("#updateCarWzfForm #updateArea3").append("<option  value='"+car[k].areaId+"'>"+car[k].name+"</option>");
                                                }
                                            }
                                        }
                                    }else {
                                        $("#updateCarWzfForm #updateArea2").append("<option  value='"+car[j].areaId+"'>"+car[j].name+"</option>");
                                    }
                                }
                            }
                        } else {
                            $("#updateCarWzfForm #updateArea1").append("<option  value='"+car[i].areaId+"'>"+car[i].name+"</option>");
                         }
                    }
                }
                $("#updateCarWzfForm #img").prop("src",dat.vipPath);
            },
            error:function () {
                alert("查询失败")
            }
        })
        bootbox.confirm({
            title: "修改",
            message:$("#updateDiv #updateCarWzfForm"),
            size: "lg",
            buttons: {
                confirm: {
                    label: "确认",
                    className: "btn btn-success",
                },
                cancel: {
                    label: "取消",
                    className: "btn btn-danger",
                }
            },
            callback:function (result) {
                if (result){
                    var param = {};
                    param.vipId = $("#updateCarWzfForm #id").val();
                    param.vipName = $("#updateCarWzfForm #updatevipName").val();
                    param.vipPhone = $("#updateCarWzfForm #updatevipPhone").val();
                    var s1 = $("#updateCarWzfForm #updateArea1").val();
                    var s2 =$("#updateCarWzfForm #updateArea2").val();
                    var  s3 = $("#updateCarWzfForm #updateArea3").val();
                    param.area =s1 +","+ s2 +","+ s3;
                    param.vipPath=$("#updateCarWzfForm #imagePath").val();
                    $.post({
                        data:param,
                        dataType:"json",
                        url:"/vip/updateVip.do",
                        success:function (data) {
                            alert("修改成功");
                            search();
                        },
                        error:function () {
                            alert("修改失败");
                        }
                    })
                }
                $("#updateDiv").html(updateCarWzfDivHtml);
            }
        })

    }




    var initTable;
    function initTableVip() {
        initTable = $("#dataTable").DataTable({
            ajax:{
                url:"/vip/selectVip.do",
                type: "POST",
                dataType:"json",
                dataSrc:"data",
            },
            serverSide:false,
            language:chineseLanguage,
            searching: true,
            ordering:  false,
            columns:[
                {"data":"vipId",
                    "render":function (data) {

                        return "<input type='checkbox' id='checkAll' name=\"plsc\" value='"+data+"'/>"
                    }
                },
                {"data":"vipName"},
                {"data":"vipPhone"},

                {data:"area",
                    render:function(data) {
                        var name = "";
                        var id = "," + data + ",";
                        for (var i = 0; i < car.length; i++) {
                            if (id.indexOf("," + car[i].areaId + ",") != -1) {
                                name += car[i].name + ",";
                            }
                            var carNames = name.substr(0, name.lastIndexOf(","));
                        }
                        return carNames;
                    }

                },

                {data:"vipPath",
                    render:function(data,type,row){
                        return "<img width='100px' src='"+data+"'/>";
                    }
                },

                {"data":"creaDate"},

                {"data":"vipId",
                    "render":function(data){
                        var buttonHtml = '';

                        buttonHtml += '<div class="btn-group btn-group-xs">';
                        buttonHtml += '<button type="button" onclick="showUpdateCarDiv('+data+')" class="btn btn-primary">';
                        buttonHtml += '<span class="glyphicon glyphicon-pencil"></span>&nbsp;修改';
                        buttonHtml += '</button>';

                        buttonHtml == '</div>';
                        return buttonHtml;
                    }
                }
            ]
        })
    }

    var car;
    function selectCarWzf() {
        $.post({
            url:"/vip/selectVipArea.do",
            dataType:"json",
            success:function (data) {
                car=data.data;
            },
            error:function () {
                alert("查詢失敗")
            }

        })
    }
    function showCity() {
        $("#updateCarWzfForm #updateArea3").html("<option value='-1'>请选择</option>")
        var  id = $("#updateCarWzfForm #updateArea1").val();
        alert(id);
        var htmls1 = "<option value='-1'>请选择</option>";
        for (var i = 0; i <car.length ; i++) {
            if (car[i].pid==id){
                htmls1+="<option value='"+car[i].areaId+"'>"+car[i].name+"</option>"
            }
        }
        $("#updateCarWzfForm #updateArea2").html(htmls1);
    }
    function showCounty() {
        var  id = $("#updateCarWzfForm #updateArea2").val();
        var htmls2 = "<option value='-1'>请选择</option> ";
        for (var i = 0; i <car.length ; i++) {
            if (car[i].pid==id){
                htmls2+="<option value='"+car[i].areaId+"'>"+car[i].name+"</option>"
            }
        }
        $("#updateCarWzfForm #updateArea3").html(htmls2);
    }
    var chineseLanguage = {
        "sProcessing": "处理中...",
        "sLengthMenu": "显示 _MENU_ 项结果",
        "sZeroRecords": "没有匹配结果",
        "sInfo": "显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项",
        "sInfoEmpty": "显示第 0 至 0 项结果，共 0 项",
        "sInfoFiltered": "(由 _MAX_ 项结果过滤)",
        "sInfoPostFix": "",
        "sSearch": "搜索:",
        "sUrl": "",
        "sEmptyTable": "表中数据为空",
        "sLoadingRecords": "载入中...",
        "sInfoThousands": ",",
        "oPaginate": {
            "sFirst": "首页",
            "sPrevious": "上页",
            "sNext": "下页",
            "sLast": "末页"
        },
        "oAria": {
            "sSortAscending": ": 以升序排列此列",
            "sSortDescending": ": 以降序排列此列"
        }
    };
</script>

</html>
