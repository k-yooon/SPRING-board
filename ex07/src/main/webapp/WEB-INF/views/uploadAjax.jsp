<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>uploadAjax.jsp</title>
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
</head>
<body>
	<h3>UPLOAD WITH AJAX</h3>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	<button id="uploadBtn">upload</button>
	<!-- 섬네일 이미지 원본 표시 -->
	<div class="bigPictureWrapper">
		<div class="bigPicture"></div>
	</div>
	<!-- 파일 목록 -->
	<div class="uploadResult">
		<ul>
		</ul>
	</div>
<script
  src="https://code.jquery.com/jquery-3.3.1.min.js"
  integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
  crossorigin="anonymous">
</script>	
</body>
<script>
	$(function(){
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
		//업로드 후 input 초기화
		var cloneObj = $(".uploadDiv").clone();
		$("#uploadBtn").on("click", function(e){
			var formData = new FormData();
		});
		
		//아이디가 uploadBtn에게 클릭 이벤트 핸들러 등록
		$("#uploadBtn").on("click", function(e){
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
				data : formData,
				dataType: 'json',
				processData: false,
				contentType : false,
				success : function(result){
					console.log(result);
					showUploadedFile(result);
					$(".uploadDiv").html(cloneObj.html());
				}
			});
		});
		
		//파일 목록 출력
		var uploadResult = $(".uploadResult ul");
		function showUploadedFile(uploadResultArr){
			var str="";
			$(uploadResultArr).each(function(i, obj){
				if(!obj.image){
					var fileCallPath = encodeURIComponent(obj.uploadPath+ "/" + obj.uuid + "_" + obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					str += "<li><a href='/download?fileName="+fileCallPath+"'><img src='/resources/img/attach.png'>" + obj.fileName + "</a><span data-file=\'"+fileCallPath+"\'data-type='file'>X</span></li>";
				} else{
					//str += "<li>" + obj.fileName + "</li>";
					//파일명 인코딩 처리
					var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_" + obj.uuid + "_" + obj.fileName);
					var originPath = obj.uploadPath+"\\"+obj.uuid+"_"+obj.fileName;
					originPath = originPath.replace(new RegExp(/\\/g), "/");
					str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName=" +fileCallPath+ "'></a><span data-file=\'"+fileCallPath+"\'data-type='image'>X</span></li>"
				}
			});
			uploadResult.append(str);
		}
		//원본 이미지 숨기기 처리
		$(".bigPictureWrapper").on("click", function(e){
			$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
			/* setTimeout(() => {
				$(this).hide();
			}, 1000); */	//ES6의 화살표 함수는 IE11에서 제대로 동작하지 않음
			setTimeout(function(){		
				$(".bigPictureWrapper").hide();
			}, 1000)
		});
		//X 표시 이벤트 처리
		$(".uploadResult").on("click", "span", function(e){
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			console.log(targetFile);
			$.ajax({
				url : '/deleteFile', 
				data : {fileName: targetFile, type:type},
				dataType: 'text',
				type : 'POST',
				success : function(result){
					alert(result);
				}
			});
		});
		
	});
	function showImage(fileCallPath){
		//alert(fileCallPath);
		$(".bigPictureWrapper").css("display", "flex").show();
		$(".bigPicture").html("<img src='/display?fileName=" +encodeURI(fileCallPath)+"'>").animate({width:'100%', height:'100%'}, 1000);
	}
</script>
</html>