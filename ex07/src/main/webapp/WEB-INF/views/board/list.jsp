<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Tables</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board List Page
                            <button id="regBtn" type="button" class="btn btn-xs pull-right">
                            	Register New Board
                            </button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                           <table class="table table-stripped table-bordered tabla-hover">
                                <thead>
                                    <tr>
                                        <th>#번호</th>
                                        <th>제목</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                        <th>수정일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                	<!-- Model 데이터 출력 -->
                                	<c:forEach items="${list}" var="board">
                                		<tr>
                                			<td><c:out value="${board.bno}"/></td>
                                			<td><a class="move" href='<c:out value="${board.bno}"/>'>
                                				<c:out value="${board.title}"/> [<c:out value="${board.replyCnt}"/>]</a></td>
                                			<td><c:out value="${board.writer}"/></td>
                            				<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regDate}" /></td>
                                			<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}" /></td> 
                                		</tr>
                                	</c:forEach>
                                </tbody>
                            </table>
                            <!-- /.table-responsive -->
                            
                            <!-- 검색창 - 검색 조건 및 키워드 입력 영역 -->
                            <form id="searchForm" action="/board/list" method="get">
                            	<select name="type">
                            	<!-- 검색 조건이 없을 경우 selected 표시 -->
                            		<option value="" <c:out value="${pageMaker.cri.type == null? 'selected':''}"/>>--</option>
                            	<!-- ${pageMaker.cri.type}이 value와 일치하면 selected 표시 -->	
                            			<option value="T" <c:out value="${pageMaker.cri.type eq 'T'? 'selected':''}"/>>제목</option>
                            			<option value="C" <c:out value="${pageMaker.cri.type eq 'C'? 'selected':''}"/>>내용</option>
                            			<option value="W" <c:out value="${pageMaker.cri.type eq 'W'? 'selected':''}"/>>작성자</option>
                            			<option value="TC" <c:out value="${pageMaker.cri.type eq 'TC'? 'selected':''}"/>>제목 or 내용</option>
                            			<option value="TW" <c:out value="${pageMaker.cri.type eq 'TW'? 'selected':''}"/>>제목 or 작성자</option>
                            			<option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC'? 'selected':''}"/>>제목 or 내용 or 작성자</option>
                            	</select>
                            	<input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'/>
                            	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                            	<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                            	<button class="btn btn-default">Search</button>
                            </form>
                            <!-- END 검색창 - 검색 조건 및 키워드 입력 영역 -->
                            
                            <!-- 페이지 번호 출력 -->
                            <div class="pull-right">
								<ul class="pagination">
									<!-- previous 버튼 표시 -->
									<c:if test="${pageMaker.prev}">	
										<li class="paginate_button previous"><a href="${pageMaker.startPage -1}">Previous</a></li>
									</c:if>
									<!-- 페이지 번호 표시 -->
									<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
										<li class="paginate_button ${pageMaker.cri.pageNum == num ? "active":""}"><a href="${num}">${num}</a></li>
									</c:forEach>	
									<!-- next 버튼 표시 -->
									<c:if test="${pageMaker.next}">
										<li class="paginate_button next"><a href="${pageMaker.endPage +1}">Next</a></li>
									</c:if>
								</ul>                            
                            </div>
                            <!-- a태그 대신 pageNum과 amount 파라미터로 전송 -->
                            <form id="actionForm" action="/board/list" method="get">
                            	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
                            	<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                            	<input type="hidden" name="type" value="${pageMaker.cri.type}">
                            	<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
                            </form>
                            <!-- end pagination -->
                            
                            <!-- Modal -->
                            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                            <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                                        </div>
                                        <div class="modal-body">처리가 완료되었습니다.</div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            <button type="button" class="btn btn-primary">Save changes</button>
                                        </div>
                                    </div>
                                    <!-- /.modal-content -->
                                </div>
                                <!-- /.modal-dialog -->
                            </div>
                            <!-- /.modal -->
                            
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-6 -->
            </div>
            <!-- /.row -->
<script>
	$(function(){  //Register New Board 버튼을 클릭하면 게시물 등록 화면 표시
		var result = '${result}'; 	//result 속성의 bno 값
		checkModal(result);
		
		history.replaceState({},null,null);		//뒤로가기 시에 모당창 재출력 X 처리
		function checkModal(result){
			if(result === '' || history.state){
				return
			}
			if(parseInt(result) > 0){
				$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.") 
			}	
			$("#myModal").modal("show");
		}
	
		$("#regBtn").on("click", function(){
			self.location = "/board/register";
		});
		//페이지 버튼 클릭
		var actionForm = $("#actionForm");
		$(".paginate_button a").on("click", function(e){
			e.preventDefault();	
			console.log("click");
			//pageNum의 값을 클릭된 a의 href로 변경
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
		});
		
		$(".move").on("click", function(e){
			e.preventDefault();		//a태그 기본 동작 막기
			actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
			actionForm.attr("action", "/board/get");
			actionForm.submit();
		});
		
		//검색 버튼 처리
		var searchForm = $("#searchForm");
		$("#searchForm button").on("click", function(e){
			if(!searchForm.find("option:selected").val()){	//검색 조건을 지정하지 않은 경우
				alert("검색 종류를 선택하세요");
				return false;
			}
			if(!searchForm.find("input[name='keyword']").val()){	//검색어를 입력하지 않은 경우
				alert("키워드를 입력하세요");
				return false;
			}
			searchForm.find("input[name='pageNum']").val("1");	//검색 시 페이지 번호는 1이 되도록 처리
			e.preventDefault();
			searchForm.submit();
		});
	});
</script>            
<%@ include file="../includes/footer.jsp" %>
