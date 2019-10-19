package org.zerock.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean image;		//이미지 파일 여부
}
