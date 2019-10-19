<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>uploadForm.jsp</title>
</head>
<body>
	<h3>FILE UPLOAD FORM</h3>
	<form action="uploadFormAction" method="post" enctype="multipart/form-data">
		<input type="file" name="uploadFile" multiple>	<!-- multiple은 파일 복수 선택 가능 -->
		<button>submit</button>
	</form>
</body>
</html>