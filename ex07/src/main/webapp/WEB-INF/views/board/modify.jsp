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
		width: 70%;
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
                    <h1 class="page-header">Board Modify</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board Modify Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                         	<form role="form" action="/board/modify" method="post">
                         	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                         	<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                         	<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                         	<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
                         	<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
                          	<div class="form-group">
                          		<label>Bno</label>
                          		<input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly">
                          	</div>
                          	<div class="form-group">
                          		<label>Title</label>
                          		<input class="form-control" name="title" value='<c:out value="${board.title}"/>'></textarea>
                          	</div>
                          	<div class="form-group">
                          		<label>Text area</label>
                          		<textarea class="form-control" row="3" name='content'><c:out value="${board.content}"/></textarea>
                          	</div>
                          	<div class="form-group">
                          		<label>Writer</label>
                          		<input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly">
                          	</div>
                          	<input type="hidden" name="regdate" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${board.regDate}" />">
                          	<input type="hidden" name="regdate" value="<fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}" />">
                          	<sec:authentication property="principal" var="pinfo"/>
                          	<sec:authorize access="isAuthenticated()">
                          		<c:if test="${pinfo.username eq board.writer}">
		                          	<button type="submit" data-oper='modify' class="btn btn-default">Modify</button>
		                          	<button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
		                          	<button type="submit" data-oper='list' class="btn btn-info">List</button>
		                        </c:if>  	
                          	</sec:authorize>
      					</form>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-6 -->
            </div>
            <!-- /.row -->
<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
</div>

  <!-- 첨부파일  -->
    <div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">File</div>
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
               
<script>
	$(function(){
		//첨부파일 조회
		(function(){
			var bno = '<c:out value="${board.bno}"/>';
			$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
				console.log(arr);
				var str ="";
				$(arr).each(function(i, attach){
					//image 타입
					if(attach.fileType){
						var fileCallPath = encodeURIComponent(attach.uploadPath+ "/s_" + attach.uuid + "_" + attach.fileName);
						str += "<li data-path='"+attach.uploadPath+"' data-filename='"+attach.fileName+"' data-uuid='"+attach.uuid+"' data-type='"+attach.fileType+"'><div>";
						str += "<span> "+attach.fileName+"</span>";
						str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'"+fileCallPath+"\' data-type='image'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/display?fileName=" +fileCallPath+ "'>";
						str += "</div>";
						str + "</li>";
					} else{
						str += "<li data-path='"+attach.uploadPath+"' data-filename='"+attach.fileName+"' data-uuid='"+attach.uuid+"' data-type='"+attach.fileType+"'><div>"
						str += "<span> "+attach.fileName+"</span>";
						str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'"+fileCallPath+"\' data-type='file'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/resources/img/attach.png'></a>";
						str += "</div>";
						str + "</li>";
					}
				});
				$(".uploadResult ul").html(str);
			});
		})();
		
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
			if(confirm("Remove this file? ")){
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
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
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		//첨부파일 상태 변화 이벤트 핸들러 등록
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
				beforeSend:function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				data: formData,
				success : function(result){
					console.log(result);
					showUploadResult(result);
				}
			});
			
		});
		
		//modify 클릭
		var formObj = $("form");
		$("button").on("click", function(e){
			e.preventDefault();		//폼 전송하는 기본 동작 막기
			var operation = $(this).data("oper");
			console.log(operation);
			
			if(operation === 'remove'){
				formObj.attr("action", "/board/remove");
			} else if(operation === 'list'){  
				//self.location ="/board/list" return;
				formObj.attr("action", "/board/list").attr("method", "get");
				//formObj 지우기 전에 페이지 번호와 개수 태그 복사 후 저장
				var PageNumTag = $("input[name='pageNum']").clone();	//.clone()은 선택한 요소를 복사
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
				formObj.empty();
				formObj.append(PageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
			} else if(operation === 'modify'){
				console.log("submit click");
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
			}
			formObj.submit();
		});
	});
</script>            
<%@ include file="../includes/footer.jsp" %>
