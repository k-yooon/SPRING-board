package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	@GetMapping("/uploadForm")		//uploadForm 화면으로 이동
	public void uploadForm() {
		log.info("uploadForm");
	}
	
	@PostMapping("/uploadFormAction")	//실제 업로드 처리 
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		String uploadFolder = "C:\\upload";
		for (MultipartFile multipartFile : uploadFile) {
			log.info("------------------------");
			log.info("upload file name : " + multipartFile.getOriginalFilename());
			log.info("upload file size : " + multipartFile.getSize());
			
			String uploadFileName = multipartFile.getOriginalFilename();
			//IE의 경우 경로를 제거하고 파일명만 저장
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name : " + uploadFileName);
			File saveFile = new File(uploadFolder, uploadFileName);
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
			
		}
	}
	
	@GetMapping("/uploadAjax")		//uploadAjax 화면으로 이동
	public void uploadAjax() {
		log.info("uploadAjax");
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/uploadAjaxAction") //Ajax 업로드 처리 
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "C:\\upload";
		//업로드 경로를 C:\\upload 폴더 밑에 연\월\일 폴더로 지정
		File uploadPath = new File(uploadFolder, getFolder());
		log.info(uploadPath);
		
		//uploadPath가 없으면 폴더 생성
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();		//연\월\일 폴더 한꺼번에 생성
		}
		
		for (MultipartFile multipartFile : uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO();
			log.info("------------------------");
			log.info("upload file name : " + multipartFile.getOriginalFilename());
			log.info("upload file size : " + multipartFile.getSize());
			
			String uploadFileName = multipartFile.getOriginalFilename();
			attachDTO.setFileName(uploadFileName);	//업로드 파일명 저장
			//IE의 경우 경로를 제거하고 파일명만 저장			
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name : " + uploadFileName);
			//파일명 중복 방지를 위한 UUID 적용
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			File saveFile = new File(uploadPath, uploadFileName);
			
			try {
				multipartFile.transferTo(saveFile);
				attachDTO.setUuid(uuid.toString());			//UUID 값 저장
				attachDTO.setUploadPath(getFolder());		//업로드 경로 저장
				//이미지 파일이면 섬네일 이미지 파일 생성
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					//가로 100*세로 100 섬네일 이미지 생성 
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					thumbnail.close();
				}
				list.add(attachDTO);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
			
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	//폴더명 생성 메서드 
	private String getFolder() {		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	//이미지 파일인지 판단하는 메서드
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	//섬네일 파일 전송
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("fileName : " + fileName);
		File file = new File("C:\\upload\\" + fileName);
		log.info("file : " + file);
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	//일반파일 다운로드
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
		log.info("download file : " + fileName);
		Resource resource = new FileSystemResource("C:\\upload\\" + fileName);
		log.info("resource : " + resource);
		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		ResponseEntity<Resource> result = null;
		String resourceName = resource.getFilename();
		//uuid 잘라내기
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		HttpHeaders header = new HttpHeaders();
		try {
			//인터넷 종류 별 처리
			String downloadName = null;
			if(userAgent.contains("Trident")) {
				log.info("IE");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");  //한글 깨짐 방지
			} else if(userAgent.contains("Edge")) {
				log.info("Edge");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");  //한글 깨짐 방지
			} else {
				log.info("Chrome");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");   //한글 깨짐 방지
			}
			header.add("Content-Disposition", "attachment; filename=" + downloadName);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
		
	}
	//파일 삭제
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		log.info("delete File : " + fileName);
		File file;
		try {
			file = new File("C:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			file.delete();
			if(type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("largeFileName : " + largeFileName);
				file = new File(largeFileName);
				file.delete();
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
	
}
