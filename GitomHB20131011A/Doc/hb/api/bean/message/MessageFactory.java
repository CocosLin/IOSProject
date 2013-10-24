package com.gitom.hb.api.bean.message;

import com.alibaba.fastjson.JSON;

public class MessageFactory {
	private static String version = "1.0.0";
	
	public static Message createMessageException(String cause) {
		Message message = new Message();
		
		Head head = new Head();
		head.setVersion(version);
		head.setSuccess(false);
		head.setCause(cause);
		message.setHead(head);
		
		Body body = new Body();
		body.setSuccess(false);
		message.setBody(body);
		
		return message;
	}
	
	public static Message createMessageSuccess(Object data, String note) {
		Message message = new Message();
		
		Head head = new Head();
		head.setVersion(version);
		head.setSuccess(true);
		message.setHead(head);
		
		Body body = new Body();
		body.setSuccess(true);
		body.setData(JSON.toJSONString(data));
		if (null != note) {
			body.setNote(note);
		}
		message.setBody(body);
		
		return message;
	}
	
	public static Message createMessageSuccess(Object data) {
		return createMessageSuccess(data, null);
	}
	
	public static Message createMessageFailed(String warning) {
		Message message = new Message();
		
		Head head = new Head();
		head.setVersion(version);
		head.setSuccess(true);
		message.setHead(head);
		
		Body body = new Body();
		body.setSuccess(false);
		body.setWarning(warning);
		message.setBody(body);
		
		return message;
	}
	
	
	
}
