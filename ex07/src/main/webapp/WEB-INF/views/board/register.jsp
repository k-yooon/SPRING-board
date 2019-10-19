<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ include file="../includes/header.jsp" %>
<style>
	.uploadResult{
		width:100%; background-color:gray;
	}
	.uploadResult ul{
		display:flex;
		flex-flow:row;
		justify-content:center;
		align-items: center;
	}
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
	}
	.uploadResult ul li img{
		width: 100px;
	}
	.uploadResult ul li span{
		color:white;
	}
	.bigPictureWrapper{
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background:rgba(255,255,255,0.5);
	}
	.bigPicture{
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.bigPicture img{
		width: 600px;
	}
</style>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Register</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board Register
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                          <form role="form" action="/board/register" method="post">
                          	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                          	<div class="form-group">
                          		<label>Title</label>
                          		<input class="form-control" name="title">
                          	</div>
                          		<div class="form-group">
                          		<label>Text area</label>
                          		<textarea class="form-control" row="3" name='content'></textarea>
                          	</div>
                          	<div class="form-group">
                          		<label>Writer</label>
                          		<input class="form-control" name="writer" value='<sec:authentication property="principal.username"/>' readonly="readonly">
                          	</div>
                          	<button type="submit" class="btn btn-default">Submit</button>
                          	<button type="reset" class="btn btn-default">Reset</button>
                          </form>
                    
  
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-6 -->
            </div>
            <!-- /.row -->
    <!-- 첨부파일  -->
    <div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">File Attach</div>
				<div class="panel-body">
					<div class="form-group uploadDiv">
						<input type="file" name="uploadFile" multiple>
                    </div>
                    <div class="uploadResult">
						<ul>
						</ul>
					</div>
                 </div> <!-- end panel-body -->
             </div> <!-- end panel -->
      </div> <!-- end col-lg-6 -->
   </div>     <!-- end row -->            
<%@ include file="../includes/footer.jsp" %>
<script>
	$(function(){
		//submit 버튼 이벤트 처리
		var formObj = $("form[role='form']");
		$("button[type='submit']").on("click", function(e){
			e.preventDefault();
			console.log("submit");
			//첨부 파일 정보 hidden 태그로 추가
			var str="";
			$(".uploadResult ul li").each(function(i, obj){
				var jobj = $(obj);
				console.dir(jobj);
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
			});
			formObj.append(str).submit();
		});
		//확장자 및 파일 크기 확인  함수 만들기
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");	//확장자 제한 정규 표현식
		var maxSize = 5242880;								//파일 업로드 크기 제한 5MB
		
		function checkExtension(fileName, fileSize){
			//파일 크기 확인 /크기 초과하면 알림 메세지 출력 /return false
			if(fileSize > maxSize){
				alert("파일 사이즈 크기 초과");
				return false;
			}
			//확장자 확인 /제한 확장자인 경우 알림 메세지 출력 /return false
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드할 수 없습니다");
				return false;
			}
			//파일 크기 및 확장자 문제가 없는 경우 /return true
			return true;
		}
		//첨부파일 상태 변화 이벤트 핸들러 등록
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		$("input[type='file']").change(function(e){
			var formData = new FormData();	//가상의 <form> 태그
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			console.log(files);
			
			//formData 객체에 선택한 파일 추가
			for(var i=0; i<files.length; i++){
				//확장자 및 파일 크기 확인 
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			$.ajax({
				type : 'POST',
				url : '/uploadAjaxAction', 
				dataType: 'json',
				processData: false,
				contentType : false,
				beforeSend: function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				data: formData,
				success : function(result){
					console.log(result);
					showUploadResult(result);		//업로드 결과 처리 함수
				}
			});
			
		});
		//파일 목록 출력
		function showUploadResult(uploadResultArr){
			var uploadUL = $(".uploadResult ul");
			var str="";
			$(uploadResultArr).each(function(i, obj){
				if(obj.image){
					var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_" + obj.uuid + "_" + obj.fileName);
					var originPath = obj.uploadPath+"\\"+obj.uuid+"_"+obj.fileName;
					originPath = originPath.replace(new RegExp(/\\/g), "/");
					str += "<li data-path='"+obj.uploadPath+"' data-filename='"+obj.fileName+"' data-uuid='"+obj.uuid+"' data-type='"+obj.image+"'><div>";
					str += "<span> "+obj.fileName+"</span>";
					str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'"+fileCallPath+"\' data-type='image'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName=" +fileCallPath+ "'>";
					str += "</div>";
					str + "</li>";
				} else{
					var fileCallPath = encodeURIComponent(obj.uploadPath+ "/" + obj.uuid + "_" + obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					str += "<li data-path='"+obj.uploadPath+"' data-filename='"+obj.fileName+"' data-uuid='"+obj.uuid+"' data-type='"+obj.image+"'><div>"
					str += "<span> "+obj.fileName+"</span>";
					str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'"+fileCallPath+"\' data-type='file'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/attach.png'></a>";
					str += "</div>";
					str + "</li>";
				}
			});
			uploadUL.append(str);
		}
		//X버튼 이벤트 처리
		$(".uploadResult").on("click", "button", function(e){
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			var targetLi = $(this).closest("li")
			console.log(targetFile);
			$.ajax({
				url : '/deleteFile', 
				data : {fileName: targetFile, type:type},
				beforeSend: function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				dataType: 'text',
				type : 'POST',
				success : function(result){
					alert(result);
					targetLi.remove();
				}
			});
		});
		
	});
</script>
