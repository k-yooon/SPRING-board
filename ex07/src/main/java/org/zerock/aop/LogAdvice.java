package org.zerock.aop;

import java.util.Arrays;
import java.util.Date;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {
	
	@Before("execution(* org.zerock.service.SampleService*.*(..))") //*org.zerock.service.SampleService* 클래스 이름 / *(..) 메서드 이름(모든 메서드) 
	public void logBefore() { 
		log.info("============================");
	}
	@Before("execution(* org.zerock.service.SampleService*.doAdd(String, String)) && args(str1, str2)") 
	public void logBeforeWithParam(String str1, String str2) {
		log.info(str1);
		log.info(str2);
	}
	@AfterThrowing(pointcut="execution(* org.zerock.service.SampleService*.*(..))", throwing="exception")
	public void logException(Exception exception) {
		log.info("Exception...!!!");
		log.info("exception : " + exception);
	}
	@Around("execution(* org.zerock.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint pjp) {
		long start = System.currentTimeMillis();
		log.info("Start : " + new Date(start).toLocaleString());
		log.info("Target : " + pjp.getTarget());
		log.info("Param : " + Arrays.toString(pjp.getArgs()));
		
		//invoke method
		Object result = null;
		try {
			Thread.sleep(1000);
			result = pjp.proceed();
		} catch (Throwable e) {
			e.printStackTrace();
		}
		long end = System.currentTimeMillis();
		log.info("End : " + new Date(end).toLocaleString());
		log.info("소요시간 : " + (end - start));
		return result;
	}
}
