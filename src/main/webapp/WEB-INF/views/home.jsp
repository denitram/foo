<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>springpad</title>
	<link href="<c:url value="/resources/form.css" />" rel="stylesheet"  type="text/css" />		
	<link href="<c:url value="/resources/jqueryui/1.8/themes/base/jquery.ui.all.css" />" rel="stylesheet" type="text/css"/>
</head>
<body>
<h1><a href="<c:url value="/" />">springpad</a></h1>
<p>Recommended: Using a Web Developer tool such a Firebug to inspect the client/server interaction</p>
<div id="tabs">
	<ul>
		<li><a href="#simple">Simple</a></li>
		<li><a href="#mapping">Mapping Requests</a></li>
    </ul>
    <div id="simple">
		<h2>Simple</h2>
		<p>
			See the <code>org.springframework.samples.mvc.simple</code> package for the @Controller code
		</p>
		<ul>
			<li>
				<a id="simpleLink" class="textLink" href="<c:url value="/simple" />">GET /simple</a>
			</li>
			<li>
				<a id="simpleRevisited" class="textLink" href="<c:url value="/simple/revisited" />">GET /simple/revisited</a>
			</li>
		</ul>
	</div>
	<div id="mapping">
		<h2>Mapping Requests</h2>
		<p>
			See the <code>org.springframework.samples.mvc.mapping</code> package for the @Controller code
		</p>
		<ul>
			<li>
				<a id="byPath" class="textLink" href="<c:url value="/mapping/path" />">By path</a>
			</li>
			<li>
				<a id="byPathPattern" class="textLink" href="<c:url value="/mapping/path/wildcard" />">By path pattern</a>
			</li>
			<li>
				<a id="byMethod" class="textLink" href="<c:url value="/mapping/method" />">By path and method</a>
			</li>
			<li>
				<a id="byParameter" class="textLink" href="<c:url value="/mapping/parameter?foo=bar" />">By path, method, and presence of parameter</a>
			</li>
			<li>
				<a id="byNotParameter" class="textLink" href="<c:url value="/mapping/parameter" />">By path, method, and not presence of parameter</a>
			</li>
			<li>
				<a id="byHeader" href="<c:url value="/mapping/header" />">By presence of header</a>
			</li>
			<li>
				<a id="byHeaderNegation" class="textLink" href="<c:url value="/mapping/header" />">By absence of header</a>
			</li>
			<li>
				<form id="byConsumes" class="readJsonForm" action="<c:url value="/mapping/consumes" />" method="post">
					<input id="byConsumesSubmit" type="submit" value="By consumes" />
				</form>
			</li>
			<li>
				<a id="byProduces" class="writeJsonLink" href="<c:url value="/mapping/produces" />">By produces</a>
			</li>
		</ul>
	</div>
</div>
<script type="text/javascript" src="<c:url value="/resources/jquery/1.6/jquery.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jqueryform/2.8/jquery.form.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jqueryui/1.8/jquery.ui.core.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jqueryui/1.8/jquery.ui.widget.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/jqueryui/1.8/jquery.ui.tabs.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/json2.js" />"></script>
<script>
	MvcUtil = {};
	MvcUtil.showSuccessResponse = function (text, element) {
		MvcUtil.showResponse("success", text, element);
	};
	MvcUtil.showErrorResponse = function showErrorResponse(text, element) {
		MvcUtil.showResponse("error", text, element);
	};
	MvcUtil.showResponse = function(type, text, element) {
		var responseElementId = element.attr("id") + "Response";
		var responseElement = $("#" + responseElementId);
		if (responseElement.length == 0) {
			responseElement = $('<span id="' + responseElementId + '" class="' + type + '" style="display:none">' + text + '</span>').insertAfter(element);
		} else {
			responseElement.replaceWith('<span id="' + responseElementId + '" class="' + type + '" style="display:none">' + text + '</span>');
			responseElement = $("#" + responseElementId);
		}
		responseElement.fadeIn("slow");
	};
</script>	
<script type="text/javascript">
$(document).ready(function() {
	$("#tabs").tabs();

	// Append '#' to the window location so "Back" returns to the selected tab
	// after a redirect or a full page refresh (e.g. Views tab).

	// However, note this general disclaimer about going back to previous tabs: 
	// http://docs.jquery.com/UI/API/1.8/Tabs#Back_button_and_bookmarking

	$("#tabs").bind("tabsselect", function(event, ui) { window.location.hash = ui.tab.hash; });

	$("a.textLink").click(function(){
		var link = $(this);
		$.ajax({ url: link.attr("href"), dataType: "text", success: function(text) { MvcUtil.showSuccessResponse(text, link); }, error: function(xhr) { MvcUtil.showErrorResponse(xhr.responseText, link); }});
		return false;
	});
	
	$("form.readJsonForm").submit(function() {
		var form = $(this);
		var button = form.children(":first");
		var data = form.hasClass("invalid") ?
				"{ \"foo\": \"bar\" }" : 
				"{ \"foo\": \"bar\", \"fruit\": \"apple\" }";
		$.ajax({ type: "POST", url: form.attr("action"), data: data, contentType: "application/json", dataType: "text", success: function(text) { MvcUtil.showSuccessResponse(text, button); }, error: function(xhr) { MvcUtil.showErrorResponse(xhr.responseText, button); }});
		return false;
	});

	$("a.writeJsonLink").click(function() {
		var link = $(this);
		$.ajax({ url: this.href, dataType: "json", success: function(json) { MvcUtil.showSuccessResponse(JSON.stringify(json), link); }, error: function(xhr) { MvcUtil.showErrorResponse(xhr.responseText, link); }});					
		return false;
	});
	
	$("#byHeader").click(function(){
		var link = $(this);
		$.ajax({ url: this.href, dataType: "text", beforeSend: function(req) { req.setRequestHeader("FooHeader", "foo"); }, success: function(form) { MvcUtil.showSuccessResponse(form, link); }, error: function(xhr) { MvcUtil.showErrorResponse(xhr.responseText, link); }});
		return false;
	});
});
</script>
</body>
</html>
