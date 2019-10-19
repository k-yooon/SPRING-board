package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardMapper {
   //@Select("SELECT * from tbl_board where bno > 0")
   public List<BoardVO> getList();//getList() <- 이애가 위의 쿼리를 실행한다
   
   public void insert(BoardVO board);
   
   public void insertSelectKey(BoardVO board);
   
   public BoardVO read(Long bno);
   
   public int delete(Long bno);
   
   public int update(BoardVO board);
   
   public List<BoardVO> getListWithPaging(Criteria cri);
   
   public int getTotalCount(Criteria cri);
   
   public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}