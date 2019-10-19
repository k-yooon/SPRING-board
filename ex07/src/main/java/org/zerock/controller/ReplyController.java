package org.zerock.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")
@RestController		//서비스를 주입받기 위해서 Controller 어노테이션 사용
@Log4j
@AllArgsConstructor
public class ReplyController {
	private ReplyService service;
	
	//댓글 등록
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/new", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})	//json으로 들어온 데이터를 @RequestBody 어노테이션으로 vo 객체로 바꿔줌
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){ //@RequestBody는 json으로 들어오는 데이터를 자바 형식으로 변환 @ResponseBody는 자바 형식 데이터를 json 형식으로 변환
		log.info(vo);
		int insertcount = service.register(vo);
		log.info("insertcount : " + insertcount);
		//insertcount가 1이면 등록 성공 /성공이면 HttpStatus 200 반환 / 실패하면 HttpStatus 500 반환
		return insertcount == 1? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	//댓글 조회
	@GetMapping(value = "/pages/{bno}/{page}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno){
		log.info("getList..........");
		Criteria cri = new Criteria(page, 10);
		log.info(cri);
		return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
	}
	//특정 댓글 조회
	@GetMapping(value = "/{rno}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		log.info("get : " + rno);
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}
	//댓글 삭제
	@PreAuthorize("principal.username == #vo.replyer")
	@DeleteMapping("/{rno}")
	public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno){
		log.info("remove : " + rno);
		log.info("replyer : " + vo.getReplyer());
		return service.remove(rno) == 1? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	//댓글 수정
	@PreAuthorize("principal.username == #vo.replyer")
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH}, value = "/{rno}", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno){
		vo.setRno(rno);
		log.info("rno : " + rno);
		log.info("modify : " + vo);
		return service.modify(vo) == 1? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}	
	
	
