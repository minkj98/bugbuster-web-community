<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/news.css">
<script src="https://use.fontawesome.com/releases/v5.15.4/js/all.js"
	defer></script>
</head>
<body>
	<div class="top-section">
        <%@ include file="../common/top.jsp"%>
    </div>
	<div class="news-container">
		<div class="news-wrapper">
			<div class="news-header">
				<h2 style="margin: 0; color: #333;">뉴스</h2>
			</div>

			<c:forEach var="news" items="${newsList}">
				<div class="news-item">
					<div class="news-title-row">
						<a class="news-title" href="${news.link}" target="_blank">${news.title}</a>
						<span class="news-date">${news.pubDate}</span> <span
							class="news-category">${news.category}</span>
					</div>
					<div class="news-description">${news.description}</div>
					<div>
						<a href="${news.originallink}" target="_blank"
							class="original-link">원문 보기</a>
					</div>
				</div>
			</c:forEach>

			<c:if test="${empty newsList}">
				<div class="no-news">
					<div class="loading">뉴스를 불러오는 중...</div>
				</div>
			</c:if>

			<!-- 페이징 -->
			<c:if test="${not empty paging}">
				<div class="pagination">
					<c:if test="${paging.page > 1}">
						<a
							href="${pageContext.request.contextPath}/itNews?page=${paging.page - 1}">이전</a>
					</c:if>
					<c:if test="${paging.page <= 1}">
						<span class="disabled">이전</span>
					</c:if>

					<c:forEach begin="${paging.startPage}" end="${paging.endPage}"
						var="i" step="1">
						<c:if test="${i > 0}">
							<c:choose>
								<c:when test="${i eq paging.page}">
									<span class="current">${i}</span>
								</c:when>
								<c:otherwise>
									<a href="${pageContext.request.contextPath}/itNews?page=${i}">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:forEach>

					<c:if test="${paging.page < paging.maxPage}">
						<a
							href="${pageContext.request.contextPath}/itNews?page=${paging.page + 1}">다음</a>
					</c:if>
					<c:if test="${paging.page >= paging.maxPage}">
						<span class="disabled">다음</span>
					</c:if>
				</div>
			</c:if>

			<!-- 검색창 -->
			<div class="search-container">
				<form action="${pageContext.request.contextPath}/searchNews"
					method="get" id="searchForm">
					<div class="searchArea">
						<select id="searchSelect" name="type" required>
							<option value="" selected="selected" disabled="disabled" hidden="hidden">검색 유형을 선택하세요</option>

							<option value="title" ${searchType eq 'title' ? 'selected' : ''}>제목</option>
							<option value="category"
								${searchType eq 'category' ? 'selected' : ''}>카테고리</option>
						</select> <input type="search" id="searchValue" name="keyword"
							placeholder="검색어를 입력하세요" onfocus="this.placeholder=''"
								onblur="this.placeholder='검색어를 입력하세요'" value="${searchKeyword}" required
							maxlength="100">
						<button type="submit" id="search">
							<i class="fas fa-search"></i> 검색
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script>
		// 페이지 로드 시 자동으로 뉴스 가져오기
		window.onload = function() {
			<c:if test="${empty newsList}">
			setTimeout(
					function() {
						window.location.href = '${pageContext.request.contextPath}/itNews?page=1';
					}, 1000);
			</c:if>
		};
	</script>
</body>
</html>