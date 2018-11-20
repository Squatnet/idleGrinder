extends Node

var RPCResponse = preload("rpcresponse.gd")

var _host = "http://squatnet.co.uk" # override with new()
var _port = 80
var _error = ""
var _headers = {}

var client = HTTPClient.new()

# override default new()
func _init(host = "http://squatnet.co.uk", port = 80):
	_host = host
	_port = port
	_headers = {"User-Agent": "IdleG"}

func get(url):
	return _request( HTTPClient.METHOD_GET, url, "" )

# TODO, form encode collections if desired
func post(url, body):
	return _request( HTTPClient.METHOD_POST, url, body)

func put(url, body):
	return _request( HTTPClient.METHOD_PUT, url, body)

func delete(url):
	return _request( HTTPClient.METHOD_DELETE, url, "" )

func resetHeaders():
	_headers = {}

func setHeaders(headerDict):
	for k in headerDict:
		setHeader(k, headerDict[k])

func setHeader(headerName, value):
	_headers[headerName] = value

func _request(method, url, body):
	var res = _connect()
	if( res.isError() ):
		return res
	else:
		var headers = PoolStringArray()  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		for h in _headers:
			headers.push_back(h + ": " + _headers[h])
		client.request( method, url, headers, body)
	
	res = _poll();
	client.close()
	
	return res

func _connect():
	client.connect_to_host(_host, _port)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	return _poll()

func _poll():
	var status = -1
	var current_status
	while(true):
		client.poll()
		current_status = client.get_status()
		if( status != current_status ):
			status = current_status
			if( status == HTTPClient.STATUS_RESOLVING ):
				continue
			if( status == HTTPClient.STATUS_REQUESTING ):
				continue
			if( status == HTTPClient.STATUS_CONNECTING ):
				continue
			if( status == HTTPClient.STATUS_CONNECTED ):
				return _respond(status)
			if( status == HTTPClient.STATUS_DISCONNECTED ):
				return _errorResponse("Disconnected from Host")
			if( status == HTTPClient.STATUS_CANT_RESOLVE ):
				return _errorResponse("Can't Resolve Host")
			if( status == HTTPClient.STATUS_CANT_CONNECT ):
				return _errorResponse("Can't Connect to Host")
			if( status == HTTPClient.STATUS_CONNECTION_ERROR ):
				return _errorResponse("Connection Error")
			if( status == HTTPClient.STATUS_BODY ):
				return _parseBody()

func _parseBody():
	var body = client.read_response_body_chunk().get_string_from_utf8()
	var response = _respond(body)
	if( response.getResponseCode() >= 400 ):
		print(response.getResponseCode())
		return
		
	return response
	
func _respond(body):
	var response = RPCResponse.new()
	response._body = body
	response._response_code = client.get_response_code()
	response._body_length = client.get_response_body_length()
	response._headers = client.get_response_headers_as_dictionary()
	return response

func _errorResponse(body):
	var response = _respond(body)
	return response

