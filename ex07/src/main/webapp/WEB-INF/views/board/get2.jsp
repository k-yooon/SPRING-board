<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>   
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>     
<%@ taglib prefix="sec" 
		   uri="http://www.springframework.org/security/tags"%>      
<%@ include file="../includes/header.jsp" %>
<style>
.uploadResult { width:100%;	background-color:gray; }
.uploadResult ul { 	display:flex; 	justify-content:center;
					flex-flow:row;	align-items: center; }	
.uploadResult ul li { list-style: none;		padding:10px; }						
.uploadResult ul li img { width:100px; }

.uploadResult ul li span { color: white; }
.bigPictureWrapper {	position:absolute;	justify-content: center;		
						display: none;		align-items:center;
						top: 0%;			z-index: 100;
						width:100%;			height:100%;
						background-color: lightgray; 
						background:rgba(255 255 255 0.5);}
.bigPicture {	position: relative;			display: flex;
				justify-content: center;	align-items: center;}						 
.bigPicture img { width: 600px; }	
</style>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">
        	<!-- Board Register -->
        	Board Read Page</h1>
    </div>  <!-- /.col-lg-12 -->
</div>		<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                <!-- DataTables Advanced Tables -->
                <!-- Board Register -->
                Board Read Page
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
				<!-- 게시물 등록 폼 -->	
				<!-- <form role="form" method="post" action="/board/register"> -->
					<div class="form-group">
						<label>Title</label>
						<input class="form-control" name="title"
							   readonly="readonly"  value="${board.title}"></div>		
					<div class="form-group">
						<label>Text area</label>
						<textarea rows="3" class="form-control" 
								  name="content" 
								  readonly="readonly">${board.content }</textarea></div>			
					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name="writer"
							   readonly="readonly"  value="${board.writer}"></div>	
							   
					<!-- 로그인한 사용자가 작성한 글에만 수정 버튼 표시 -->	
					<sec:authentication property="principal" var="pinfo"/>	   
					<!-- 로그인 여부 확인 -->
					<sec:authorize access="isAuthenticated()">
						<!-- 로그인한 사용자가 작성자인지 확인 -->
						<c:if test="${pinfo.username == board.writer }">
							<button data-oper="modify" class="btn btn-default">
								Modify</button>	<!-- 수정 페이지 이동 -->
						</c:if>
					</sec:authorize>
						
					<button data-oper='list' class="btn btn-info">
						List</button>	<!-- 목록 페이지 이동 -->
					<!-- 폼 태그 추가 -->
					<form id="operForm" action="/board/modify">
						<input type="hidden" id="bno" 
							   name="bno" value="${board.bno }">
						<!-- 페이지 번호와 페이지 당 표시 개수 파라미터 추가 -->
						<input type="hidden"  
							   name="pageNum" value="${cri.pageNum }">
						<input type="hidden"  
							   name="amount" value="${cri.amount }">	
						<!-- 검색 조건과 키워드 파라미터 추가 -->   
						<input type="hidden"  
							   name="type" value="${cri.type }">
						<input type="hidden"  
							   name="keyword" value="${cri.keyword }">
					</form>
				<!-- </form> -->
				<!-- END 게시물 등록 폼 -->			
            </div>	<!-- /.panel-body -->
        </div>      <!-- /.panel -->
    </div>   		<!-- /.col-lg-6 -->
</div>				<!-- /.row -->
 
 <!-- 첨부파일 표시 영역 -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Files</div><!-- /.panel-heading -->
            
            <div class="panel-body">
				<!-- 섬네일 이미지 원본 표시 -->
				<div class="bigPictureWrapper">
					<div class="bigPicture">
					</div>	
				</div>
				<!-- END 섬네일 이미지 원본 표시 -->
				
				<!-- 업로드 결과 출력 -->
				<div class="uploadResult">
					<ul>
					</ul>
				</div>	
				<!-- END 업로드 결과 출력 -->
            </div><!-- /.panel-body -->
        </div> <!-- /.panel -->
    </div><!-- /.col-lg-6 -->
</div><!-- /.row -->
 <!-- END 첨부파일 표시 영역 -->
 
 <!-- 댓글 목록 -->
 <div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>Reply 
				
				<!-- 로그인 여부 확인 - 로그인한 경우에만 댓글 작성 가능 -->
				<sec:authorize access="isAuthenticated()">
					<button id='addReplyBtn'
							class='btn btn-primary btn-xs pull-right'>
						New Reply		
					</button>
				</sec:authorize>
            </div><!-- /.panel-heading -->
            
            <div class="panel-body">
				<ul class="chat">
				</ul>		
            </div>	<!-- /.panel-body -->
            
            <!-- 댓글 목록 페이징 -->
            <div class="panel-footer">
            </div>
            <!-- END 댓글 목록 페이징 -->
        </div>      <!-- /.panel -->
    </div>   		<!-- /.col-lg-6 -->
</div>				<!-- /.row -->
 <!-- END 댓글 목록 -->
 
 <!-- 댓글 추가 모달 창 -->
 <!-- Modal -->
 <div class="modal fade" id="myModal" tabindex="-1" 
 	  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
     <div class="modal-dialog">
         <div class="modal-content">
             <div class="modal-header">
                 <button type="button" class="close" 
                 		 data-dismiss="modal" aria-hidden="true">&times;</button>
                 <h4 class="modal-title" id="myModalLabel">
                 	REPLY MODAL</h4>
             </div><!-- END modal-header -->
             
             <div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name='reply' value='New Reply!!'>
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" name='replyer' value='replyer' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name='replyDate' value='2019-06-17 12:13'>
				</div>
             </div><!-- END modal-body -->
             
             <div class="modal-footer">
                 <button type="button" class="btn btn-warning"
                 		 id='modalModBtn'>Modify</button>
                 <button type="button" class="btn btn-danger"
                 		 id='modalRemoveBtn'>Remove</button>
                 <button type="button" class="btn btn-primary"
                 		 id='modalRegisterBtn'>Register</button>
                 <button type="button" class="btn btn-default" 
                 	     data-dismiss="modal"
                 	     id="modalCloseBtn">Close</button>
             </div><!-- END modal-footer -->
         </div>       <!-- /.modal-content -->
     </div>     <!-- /.modal-dialog -->
 </div> <!-- /.modal -->
 <!-- END 댓글 추가 모달 창 -->
 
 
<script src="/resources/js/reply.js"></script>
<script>
$(function(){
	console.log(replyService);
	
	var bnoValue = "${board.bno }";	//현재 게시물 번호
	var replyUl = $('.chat');
	
	showList(1);
	
	function showList(page){	//댓글 목록 <li> 구성 출력
		//replyService의 getList() - 댓글 목록 가져오기
		replyService.getList(
			{ bno:bnoValue, page:page || 1}, //페이지 번호가 없으면 1로 설정
//			function(list){
			function(replyCnt, list){//댓글 갯수 + 목록
				console.log("replyCnt : " + replyCnt);
				console.log("list : " + list);

				//page 번호가 -1인 경우
				if(page == -1){
					pageNum = Math.ceil(replyCnt/10.0);
					showList(pageNum);
					return;
				}
				
				if(list == null || list.length == 0){	//댓글 목록이 없으면 중단
				//	replyUl.html("");
					return;
				}
				
				//댓글 목록이 있으면   <ul>에 <li>로 댓글 추가
				var str = "";
				for(var i=0, len=list.length || 0 ; i<len; i++){
				//	console.log(list[i]);
					str += "<li class='left clearfix' data-rno='" + list[i].rno +"'>" +
						   "	<div><div class='header'>" +
						   " 	        <strong class='primary-font'>" + 
						   			    	list[i].replyer + "</strong>" +  
						   " 			<small class='pull-right text-muted'>" +
						   	/* 				list[i].replyDate + "</small></div>" + */
			 /*  replyService.displayTime(list[i].replyDate) + "</small></div>"+ */
				                displayTime(list[i].replyDate) + "</small></div>"+
						   " 		 <p>" + list[i].reply + "</p></div></li>";
				}
				replyUl.html(str);
				
				showReplyPage(replyCnt);  //페이징 함수 호출
			} 
		);//END getList() 호출
	}//END showList()
	
	//댓글 목록 페이징
	var pageNum = 1;
	var replyPageFooter = $('.panel-footer');
	
	function showReplyPage(replyCnt){
		var endNum = Math.ceil(pageNum / 10.0) * 10;
		var startNum = endNum - 9;
		var prev = startNum != 1;
		var next = false;
		
		if(endNum * 10 >= replyCnt){	
			endNum = Math.ceil(replyCnt / 10.0);
		}
		
		if(endNum * 10 < replyCnt){
			next = true;
		}
		
		var str = "<ul class='pagination pull-right'>";
		if(prev) {	//previous link
			str += "<li class='page-item'>" + 
				   "    <a class='page-link' href='" + (startNum -1) + "'>"+
				   "         Previous</a></li>";
		}
		
		//페이지 번호 출력 및 링크 처리
		for(var i=startNum ; i<= endNum ; i++){	
			var active = pageNum == i ? "active" : "";
			str += "<li class='page-item " + active + " '>" +
				   "    <a class='page-link' href='" + i + "'>" +
				   			i + "</a></li>";
		}
		
		if(next){	//next link
			str += "<li class='page-item'>" +
			 	   "    <a class='page-link' href='" + (endNum + 1) + "'>"+
			 	   "         Next</a></li>";
		}
		
		str += "</ul>";
		console.log(str);
		replyPageFooter.html(str);
	}//END showReplyPage()
	
	//댓글 페이지 번호 클릭 시 지정된 댓글 목록 가져오기
	replyPageFooter.on('click', 'li a', function(e){
		e.preventDefault();
		
		var targetPageNum = $(this).attr("href");
		pageNum = targetPageNum;
		showList(pageNum);
	});
	
	//모달 창 처리
	var modal = $('.modal');
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	var modalModBtn = $('#modalModBtn');
	var modalRemoveBtn = $('#modalRemoveBtn');
	var modalRegisterBtn = $('#modalRegisterBtn');

	var replyer = null; //username 저장 변수
	<sec:authorize access="isAuthenticated()">
		replyer = '<sec:authentication property="principal.username"/>';
	</sec:authorize>
	
	//CSRF 처리
	var csrfHeaderName = "${_csrf.headerName }";
	var csrfTokenValue = "${_csrf.token }";
	
	$('#addReplyBtn').on('click', function(e){
		modal.find('input').val("");	//입력 양식 초기화
		modal.find("input[name='replyer']").val(replyer);	//폼에 작성자 추가
		//댓글 등록과 관계없는 요소들 안보이게 처리
		modalInputReplyDate.closest('div').hide();	
		modal.find("button[id != 'modalCloseBtn']").hide();
		modalInputReplyer.removeAttr('readonly');	
		modalRegisterBtn.show();	//등록버튼은 보이게
		modal.modal('show');		//모달창 보이기
	});
	
	//ajax 전송 시 CSRF 토큰 전송 처리
	$(document).ajaxSend(function(e, xhr, options){
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	//댓글 삭제 버튼 이벤트 처리
	modalRemoveBtn.on('click', function(e){
		//로그인 여부 확인
		if(!replyer){
			alert("로그인 후 삭제 가능합니다.");
			modal.modal('hide');
			return;
		}
		
		//작성자 확인
		var originalReplyer = modalInputReplyer.val();
		if(originalReplyer != replyer){
			alert("자신이 작성한 댓글만 삭제 가능합니다.");
			modal.modal('hide');
			return;
		}
		
		replyService.remove(
			modal.data('rno'), originalReplyer,
			function(result){	//삭제 성공
				console.log('remove result : ' + result);
				if(result === 'success') { alert("REMOVED!"); }

				modal.modal('hide');//모달창 닫고
//				showList(1);		//신규 댓글 목록 가져오기
				showList(pageNum);
			},
			function(err){	alert("error!");	}
		);//END remove() 호출
	});
	
	//댓글 수정 버튼 이벤트 처리
	modalModBtn.on('click', function(e){
		
		//로그인 여부 확인
		if(!replyer){
			alert("로그인 후 수정이 가능합니다.");
			modal.modal('hide');
			return;
		}
		
		//작성자 확인
		var originalReplyer = modalInputReplyer.val();
		if(replyer != originalReplyer){
			alert("자신이 작성한 댓글만 수정이 가능합니다.");
			modal.modal('hide');
			return;
		}
		
		replyService.update(
			{ 	rno   : modal.data('rno'), 
				bno	  : bnoValue, 
				replyer : originalReplyer,
				reply : modalInputReply.val() }, 
			function(result){		//수정 성공
				console.log('update result : ' + result);
			
				if(result === 'success') { alert("Updated!"); }
				
				modal.modal('hide');//모달창 닫고
//				showList(1);		//신규 댓글 목록 가져오기
				showList(pageNum);
			},
			function(err){	alert("error!");	}
		);//END remove() 호출
	});
	
	//댓글 클릭 이벤트 처리
	$('.chat').on('click', 'li', function(e){
		var rno = $(this).data('rno');
		
		replyService.get(rno, 
			function(data){	//댓글 가져오기 성공
				modalInputReply.val(data.reply);	//모달 창에 값 출력
				modalInputReplyer.val(data.replyer).attr('readonly', 'readonly');	 
				modalInputReplyDate.val(displayTime(data.replyDate))
								   .attr('readonly', 'readonly'); 
				modal.data('rno', data.rno);		//댓글 번호 추가
				
				//불필요한 요소들 숨기기
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				modal.modal('show');				//모달창 보이기
				console.log('get result : ' + data);
			},
			function(err){	alert("error!");	}
		);//END remove() 호출
	});//END 댓글 클릭 이벤트 처리
	
	//댓글 등록 버튼 이벤트 처리
	modalRegisterBtn.on('click', function(e){
		replyService.add(	//전송할 데이터들
			{ bno	  : bnoValue, 
			  reply   : modalInputReply.val(), 
			  replyer : modalInputReplyer.val() },
			function(result){	//댓글 등록에 성공하면
				alert("RESULT : " + result);
				modal.find('input').val("");	//입력양식 비우고	
				modal.modal('hide');			//모달창 닫고
				
//				showList(1);	//신규 댓글 목록 가져오기
				showList(-1);	
			}
		);//END add() 호출 
	});//END 댓글 등록 버튼 이벤트 처리
});
</script>
<script>
function displayTime(timeValue){
	var today = new Date();
	var dateObj = new Date(timeValue);
	var str = "";
	
	//댓글 등록일이 오늘이면  '시:분:초' 표시
	if(today.getDate() === dateObj.getDate()){
		 var hh = dateObj.getHours() ;
		 var mi = dateObj.getMinutes();
		 var ss = dateObj.getSeconds();
		 
		 return [ (hh > 9 ? '' : '0') + hh, ":" ,
			 	  (mi > 9 ? '' : '0') + mi, ":" ,
			 	  (ss > 9 ? '' : '0') + ss ].join('');
	} else { //그렇지 않으면 '연/월/일' 표시
		var yy = dateObj.getFullYear();
		var mm = dateObj.getMonth() + 1;
		var dd = dateObj.getDate();
		
		return [ yy, '/', 
				 (mm > 9 ? '' : '0') + mm, '/',
				 (dd > 9 ? '' : '0') + dd].join('');			
	}
}; //END displayTime()

$(function(){
	var operForm = $("#operForm");
	
	//수정 버튼 이벤트 처리
	$('button[data-oper="modify"]').on("click", function(e){
		operForm.attr("action", "/board/modify")
		        .submit();
	});	

	//목록 버튼 이벤트 처리
	$('button[data-oper="list"]').on("click", function(e){
		operForm.find("#bno").remove();
		operForm.attr("action", "/board/list");
		operForm.submit();
	});	
});//END $

(function(){	//첨부파일 목록 가져오기
	var bno = '<c:out value="${board.bno}"/>';
	$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
		console.log('getAttachList----------------');
		console.log(arr);	
		
		//첨부파일 목록
		if(!arr || arr.length == 0){
			return;
		}

		var uploadUL = $('.uploadResult ul');
		var str = "";
		$(arr).each(function(i, obj){
			//업로드 파일명 <li>추가
			if(obj.fileType){	//이미지인 경우
				var fileCallPath = encodeURIComponent(obj.uploadPath + 
												      "/s_" + obj.uuid  + "_" +
												      obj.fileName);

			str += "<li data-path='" + obj.uploadPath + "' " 			+
					   "data-uuid='" + obj.uuid + "' " 					+
					   "data-filename='" + obj.fileName + "'" 			+
					   "data-type='" + obj.fileType + "'>" 				+ 
				       "<div><img src='/display?fileName="+ fileCallPath + "'>" +
				       "    </div></li>";
			} else {		//이미지가 아닌 경우
				var fileCallPath 
				= encodeURIComponent(obj.uploadPath + 
									 "/" + obj.uuid  + "_" +
									 obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");			
				str += "<li data-path='" + obj.uploadPath + "' " 	+
					   "    data-uuid='" + obj.uuid + "' " 			+
					   "    data-filename='" + obj.fileName + "'" 	+
					   "    data-type='" + obj.fileType + "'>" 		+ 
					   "    <div><span>" + obj.fileName + "</span><br>"	+  
					   "    <img src='/resources/img/attach.png'></div></li>";
			}
		});
		uploadUL.append(str);
	});//END getJSON()
})();//END 첨부파일 목록 가져오기

//첨부파일 클릭 이벤트 처리
$('.uploadResult').on('click', 'li', function(e){
	console.log('uploadResult click');
	
	var obj = $(this);
	var path = encodeURIComponent(obj.data('path') + 
								  "/" + obj.data('uuid')  + "_" +
						 		  obj.data('filename'));
	if(obj.data('type')) { //이미지이면 
		//showImage() 호출
		console.log('path : ' + path);
		showImage(path);
	} else {	//이미지가 아니면
		//다운로드 처리
		self.location = "/download?fileName=" + path;		
	}
});//END 첨부파일 클릭 이벤트 처리

//원본 이미지 표시 함수
function showImage(fileCallPath){
	$('.bigPictureWrapper').css('display', 'flex').show();
	
	//이미지 및 효과 추가
	$('.bigPicture').html("<img src='/display?fileName=" + 
							fileCallPath + "'>")
					.animate( { width:'100%', height:'100%'}, 1000);
}//END showImage()

//원본 이미지 숨기기 처리
$('.bigPictureWrapper').on('click', function(e){
	$(".bigPicture").animate({ width:'0%', height:'0%'}, 1000);
//	setTimeout(()=>{ $(this).hide(); }, 1000);
	setTimeout(function(){ $('.bigPictureWrapper').hide(); }, 1000);
});//END 원본 이미지 숨기기 처리
</script>
<%@ include file="../includes/footer.jsp" %>















