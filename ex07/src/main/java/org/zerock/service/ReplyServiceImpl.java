package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service	//service를 구현받아서 쓰는 어노테이션
@Log4j		//잘 넘어가는지 log.info로 기록하기 위한 어노테이션
public class ReplyServiceImpl implements ReplyService {
	@Setter(onMethod_ = @Autowired)	//세터로 주입하려면 @Setter 생성자 통해서 주입하려면 @AllArgsConstructor 사용
	private ReplyMapper mapper;
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardmapper;

	@Transactional
	@Override
	public int register(ReplyVO vo) {
		log.info("register : " + vo);
		int result = mapper.insert(vo);
		//카운트 증가 업데이트
		boardmapper.updateReplyCnt(vo.getBno(), 1);
		return result;
	}

	@Override
	public ReplyVO get(Long rno) {
		log.info("get : " + rno);
		return mapper.read(rno);
	}

	@Transactional
	@Override
	public int remove(Long rno) {
		log.info("remove : " + rno);
		ReplyVO vo = mapper.read(rno);
		int result = mapper.delete(rno);
		boardmapper.updateReplyCnt(vo.getBno(), -1);
		return result;
	}

	@Override
	public int modify(ReplyVO reply) {
		log.info("modify : " + reply);
		return mapper.update(reply);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		log.info("getList : " + cri);
		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(cri, bno));
	}

}
