package org.zerock.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardControlller {
	private BoardService service;
	
	//게시물 등록화면 이동
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {}
	
	//전체 목록 가져오기
	/*
	 * @GetMapping("/list") public void list(Model model) { log.info("list");
	 * model.addAttribute("list", service.getList()); }
	 */
	
	//페이징 후 전체 목록 가져오기
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list : " + cri);
		model.addAttribute("list", service.getList(cri));
		//model.addAttribute("pageMaker", new PageDTO(cri, 1233));		//전체 데이터 수는 임의로 123 지정
		int total = service.getTotalCount(cri);
		log.info("total : " + total); 
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	//게시물 등록하기
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register : " + board);
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	
	//조회하기
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("get or modify: " + bno);
		model.addAttribute("board", service.get(bno));
	}
	
	//첨부파일 조회하기
	@GetMapping(value="/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		log.info("getAttachList " +  bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
		
	}
	
	//수정하기
	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify : " + board);
		if(service.modify(board)) {	//수정에 성공한 경우
			rttr.addFlashAttribute("result", "success");
		}
		//rttr.addAttribute("pageNum", cri.getPageNum());
		//rttr.addAttribute("amount", cri.getAmount());
		//rttr.addAttribute("type", cri.getType());
		//rttr.addAttribute("keyword", cri.getKeyword());
		return "redirect:/board/list" + cri.getListLink();
	}

	//파일 삭제
	public void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		log.info("delete file list : " + attachList);
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				Files.deleteIfExists(file);
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath() + "\\s_" + attach.getUuid() + "_" + attach.getFileName());
					Files.delete(thumbNail);
				}
			} catch (Exception e) {
				log.error("delete file error : " + e.getMessage());
			}
		});
	}
	
	//삭제하기
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr) {
		log.info("remove : " + bno);
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		if(service.remove(bno)) {	//삭제에 성공한 경우
			rttr.addFlashAttribute("result", "success");
		}
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		deleteFiles(attachList);
		return "redirect:/board/list" + cri.getListLink();
	}
	
}
