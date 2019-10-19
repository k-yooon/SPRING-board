package org.zerock.task;


import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	@Setter(onMethod_ = {@Autowired})
	private BoardAttachMapper attachMapper;
	
	//어제 날짜 폴더의 문자열 가지고 오기
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String str = sdf.format(cal.getTime());
		return str.replace("-", File.separator);
	}
	
	@Scheduled(cron="0 0 13 * * *")	//매일 13시에 실행	//cron="0 * * * * *" 초 분 시 일 월  주 (년)
	public void sheckfiles() throws Exception{
		Date now = new Date();
		log.warn("file check Task run........" + now.toLocaleString());
		log.warn("===========================");
		//tbl_attach 테이블에서 어제 날짜의 첨부파일 가져오기
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		//C:\\upload 폴더의 파일들을 목록으로 만들기
		List<Path> fileListPaths = fileList.stream().map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid()+"_"+vo.getFileName()))
				.collect(Collectors.toList());
		
		//섬네일 이미지가 있는 경우에는 첨부파일 목록에 추가 
		fileList.stream().filter(vo -> vo.isFileType() == true).map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid()+"_"+vo.getFileName()))
		.forEach(p -> fileListPaths.add(p));
		
		//C:\\upload 폴더의 실제 파일 가져오기
		File targetDir = Paths.get("c:\\upload", getFolderYesterDay()).toFile();
		
		//tbl_attach 테이블 첨부파일 목록에 파일을 삭제 대상 배열에 추가
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		//삭제 대상 배열의 파일들 삭제
		for (File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
	}

}
