<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>   
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>    
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
						<input class="form-control" name="title" readonly="readonly"  value="${board.title}"></div>		
					<div class="form-group">
						<label>Text area</label>
						<textarea rows="3" class="form-control" name="content" readonly="readonly">${board.content }</textarea></div>			
					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name="writer" readonly="readonly"  value="${board.writer}"></div>	
					<sec:authentication property="principal" var="pinfo"/>
						<sec:authorize access="isAuthenticated()">
							<c:if test="${pinfo.username eq board.writer }">
								<button data-oper="modify" class="btn btn-default">Modify</button>	<!-- 수정 페이지 이동 -->
							</c:if>
						</sec:authorize>
					<button data-oper='list' class="btn btn-info">List</button>			<!-- 목록 페이지 이동 -->
					
					
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

<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
</div>

  <!-- 첨부파일  -->
    <div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">File</div>
				<div class="panel-body">
                    <div class="uploadResult">
						<ul>
						</ul>
					</div>
                 </div> <!-- end panel-body -->
             </div> <!-- end panel -->
      </div> <!-- end col-lg-6 -->
   </div>     <!-- end row -->     
 
 <!-- 댓글 목록 -->
 <div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>Reply 
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
					<input class="form-control" name='replyer' value='replyer'>
				</div>
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name='replyDate' value='2019-06-17 12:13'>
				</div>
             </div><!-- END modal-body -->
             
             <div class="modal-footer">
                 <button type="button" class="btn btn-warning" id='modalModBtn'>Modify</button>
                 <button type="button" class="btn btn-danger" id='modalRemoveBtn'>Remove</button>
                 <button type="button" class="btn btn-primary" id='modalRegisterBtn'>Register</button>
                 <button type="button" class="btn btn-default" data-dismiss="modal" id="modalCloseBtn">Close</button>
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
	//첨부파일 가져오기
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
					str += "<img src='/display?fileName=" +fileCallPath+ "'>";
					str += "</div>";
					str + "</li>";
				} else{
					str += "<li data-path='"+attach.uploadPath+"' data-filename='"+attach.fileName+"' data-uuid='"+attach.uuid+"' data-type='"+attach.fileType+"'><div>"
					str += "<span> "+attach.fileName+"</span><br>";
					str += "<img src='/resources/img/attach.png'></a>";
					str += "</div>";
					str + "</li>";
				}
			});
			$(".uploadResult ul").html(str);
		});
	})();
	
	//첨부파일 클릭 시 이벤트 처리
	$(".uploadResult").on("click", "li", function(e){
		console.log("view image");
		var liObj = $(this);
		var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
		if(liObj.data("type")){		//이미지 파일이면 쇼이미지 호출
			showImage(path.replace(new RegExp(/\\/g), "/"));
		} else{						//이미지 파일 아니면 다운로드
			//download
			self.location = "/download?fileName=" + path;
		}
	});
	//이미지 클릭하면 크게 보여주기
	function showImage(fileCallPath){
		$(".bigPictureWrapper").css("display", "flex").show();
		$(".bigPicture").html("<img src='/display?fileName=" +fileCallPath+"'>").animate({width:'100%', height:'100%'}, 1000);
	}
	
	//원본 이미지 숨기기 처리
	$(".bigPictureWrapper").on("click", function(e){
		$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
		setTimeout(function(){		
			$(".bigPictureWrapper").hide();
		}, 1000)
	});
	
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
	
	var replyer = null;
	<sec:authorize access = "isAuthenticated()">
	replyer = '<sec:authentication property="principal.username"/>';
	</sec:authorize>
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";

	//ajax 전송 시 CSRF 토큰 전송 처리
	$(document).ajaxSend(function(e, xhr, options){
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	//댓글 삭제 버튼 이벤트 처리
	modalRemoveBtn.on('click', function(e){
		//글쓴이만 댓글 삭제하도록
		var rno = modal.data("rno");
		console.log("RNO : " + rno);
		console.log("REPLYER : " + replyer);
		
		if(!replyer){
			alert("로그인 후 삭제가 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		var originalReplyer = modalInputReplyer.val();	
		
		console.log("originalReplyer : " + originalReplyer); //댓글의 원래 작성자
		
		if(replyer != originalReplyer){
			alert("자신이 작성한 댓글만 삭제가 가능합니다");
			modal.modal("hide");
			return;
		}
		
		replyService.remove(rno, originalReplyer, function(result){
			alert(result);
			modal.modal("hide");
			showList(pageNum);
		});	
	});
	
	//댓글 수정 버튼 이벤트 처리
	modalModBtn.on('click', function(e){
		
	var originalReplyer = modalInputReplyer.val();
		
		var reply = {
				rno:modal.data("rno"),
				reply: modalInputReply.val(),
				replyer: originalReplyer
		};
		
		if(!replyer){
			alert("로그인 후 수정이 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		console.log("originalReplyer : " + originalReplyer);
		
		if(replyer != originalReplyer){
			alert("자신이 작성한 댓글만 수정이 가능합니다");
			modal.modal("hide");
			return;
		}
		
		replyService.update(reply, function(result){
			alert(result);
			modal.modal("hide");
			showList(pageNum);
		});
		
		/* replyService.update(
			{ 	rno   : modal.data('rno'), 
				bno	  : bnoValue, 
				reply : modalInputReply.val() }, 
			function(result){		//수정 성공
				console.log('update result : ' + result);
			
				if(result === 'success') { alert("Updated!"); }
				
				modal.modal('hide');//모달창 닫고
//				showList(1);		//신규 댓글 목록 가져오기
				showList(pageNum);
			},
			function(err){	alert("error!");	}
		);//END remove() 호출 */
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
	
	$('#addReplyBtn').on('click', function(e){
		modal.find('input').val("");	//입력 양식 초기화
		modal.find("input[name='replyer']").val(replyer);
		
		//댓글 등록과 관계없는 요소들 안보이게 처리
		modalInputReplyDate.closest('div').hide();	
		modal.find("button[id != 'modalCloseBtn']").hide();
		//modalInputReplyer.removeAttr('readonly');	
		modalRegisterBtn.show();	//등록버튼은 보이게
		modal.modal('show');		//모달창 보이기
	});
	
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
});
</script>
<%@ include file="../includes/footer.jsp" %>















