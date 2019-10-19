package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	private int startPage;
	private int endPage;
	private boolean prev, next;
	private int total;
	private Criteria cri;
	
	public PageDTO(Criteria cri, int total) {
		this.cri = cri;
		this.total = total;
		
		this.endPage = (int) (Math.ceil(cri.getPageNum()/10.0)) * 10;		//끝 페이지 계싼
		this.startPage = this.endPage - 9;									//시작 페이지 계산
		
		int realEnd = (int) (Math.ceil((total*1.0) / cri.getAmount()));	//전체 데이터 수를 반영한 실제 끝 페이지 계산
		
		if(realEnd < this.endPage) {		//끝페이지가 실제 페이지보다 큰 경우
			this.endPage = realEnd;
		}
		this.prev = this.startPage > 1;
		this.next = this.endPage < realEnd;
	}
}
