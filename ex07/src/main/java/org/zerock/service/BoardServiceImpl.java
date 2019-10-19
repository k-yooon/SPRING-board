package org.zerock.service;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService{
	
	private BoardMapper mapper;
	private BoardAttachMapper attachMapper;

	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("register.... : " + board);
		mapper.insertSelectKey(board);
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {	//첨부파일이 없는 경우
			return;
		} 
		//첨부파일이 있는 경우 
		board.getAttachList().forEach(attach ->{
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		BoardVO board = mapper.read(bno);
		return board;
	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		attachMapper.deleteAll(board.getBno());
		boolean modifyResult = mapper.update(board) == 1;
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach ->{
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		attachMapper.deleteAll(bno);
		int i = mapper.delete(bno);
		boolean result = i == 1? true : false;
		return result;
	}

	/*
	 * @Override public List<BoardVO> getList() { List<BoardVO> bList =
	 * mapper.getList(); return bList; }
	 */
	
	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("get List with criteria : " + cri);
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotalCount(Criteria cri) {
		//get total count를 로그로 기록
		//BoadMapper 클래스의 getTotalCount()를 호출하여 반환
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}
	//첨부파일 가져오기
	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("getAttachList : " + bno);
		return attachMapper.findByBno(bno);
	}


}
