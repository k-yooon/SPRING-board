package org.zerock.domain;

import lombok.Data;

@Data
public class BoardAttachVO {
	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean fileType;		//이미지 파일 여부
	private Long bno;
}
