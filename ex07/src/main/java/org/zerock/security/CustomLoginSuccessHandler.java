package org.zerock.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler{

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
		log.warn("Login Success");
		List<String> roleNames = new ArrayList<>();
		auth.getAuthorities().forEach(authority -> {
			//사용자 권한을 모두 리스트에 저장
			roleNames.add(authority.getAuthority());
		});
		log.warn("Role names : " + roleNames);
		//ROLE_ADMIN이면 /sample/admin 이동
		//ROLE_MEMBER /sample/member 이동
		//위 두가지가 아니면 /로 이동
		if(roleNames.contains("ROLE_ADMIN")) {
			response.sendRedirect("/sample/admin");
			return;
		}
		if(roleNames.contains("ROLE_MEMBER")) {
			response.sendRedirect("/sample/member");
			return;
		}
		response.sendRedirect("/");	
	}
}
