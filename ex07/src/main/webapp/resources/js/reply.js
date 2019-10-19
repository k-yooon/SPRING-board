console.log("reply module ... reply.js");

//즉시 실행 함수 저장 
var replyService = ( function(){
	//댓글 등록
	function add(reply, callback, error){
		console.log("reply.js - add()");
		
		$.ajax({
			type : 'post',
			url : '/replies/new',
			data : JSON.stringify(reply),		//데이터를 json화 시킴
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},error : function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		})	
	}
	//댓글 목록 가져오기
	function getList(param, callback, error){
		console.log("reply.js - getList()");
		var bno = param.bno;
		var page = param.page || 1;
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",function(data){
				if(callback){
					//callback(data);		//댓글 목록만 가져오는 경우
					callback(data.replyCnt, data.list);		//댓글 숫자와 목록을 가져오는 경우
				}
			}).fail(function(xhr, status, err){
				if(error){
					error();
				}
			});
	}
	//댓글 삭제
	function remove(rno, replyer, callback, error){
		$.ajax({
			type : 'delete',
			url : '/replies/' + rno,
			data: JSON.stringify({rno:rno, replyer:replyer}),
			contentType: "application/json; charset=utf-8",
			success : function(deleteResult, status, xhr){
				if(callback){
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	//댓글 수정
	function update(reply, callback, error){
		console.log("RNO : " + reply.rno);
		$.ajax({
			type : 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),		//데이터를 json화 시킴
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error : function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	//댓글 하나 가져오기
	function get(rno, callback, error){
		console.log("reply.js - get()");
		$.get(
			"/replies/" + rno + ".json",
			function(result){
				if(callback){ callback(result); }
			}
		).fail(
			function(xhr, status, er){
				if(error){ 	error(er); }
		    }
		);
	}//END get()
	
	return { get: get,
			 update: update,
			 add : add,
			 getList : getList, 
			 remove : remove };
})(); 