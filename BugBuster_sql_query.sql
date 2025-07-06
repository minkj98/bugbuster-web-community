-- 회원 테이블
CREATE TABLE member
(
    user_id           varchar(50) primary key,
    user_password     varchar(100) DEFAULT NULL,
    user_name         varchar(100) DEFAULT NULL,
    zipcode           varchar(5)   DEFAULT NULL,
    address           varchar(100) DEFAULT NULL,
    user_email        varchar(100) DEFAULT NULL,
    user_phone_number varchar(20)  DEFAULT NULL,
    birth_date        DATE         DEFAULT NULL,
    detailAddress     varchar(100) DEFAULT NULL
);

-- 회원 테이블 조회
select  from member;

-- 프로필 파일 테이블
CREATE TABLE profile_attach (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id varchar(50),
    filename VARCHAR(40),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_profile_attach_user UNIQUE (user_id),
    CONSTRAINT fk_profile_attach_userID
        FOREIGN KEY (user_id)
        REFERENCES member(user_id)
        ON DELETE CASCADE
);

-- 회원 관심태그 테이블
CREATE TABLE member_interest (
    user_id VARCHAR(50),    -- 회원 ID
    interest varchar(20),
    PRIMARY KEY (user_id, interest), -- 복합 기본 키
    FOREIGN KEY (user_id) REFERENCES member(user_id) ON DELETE CASCADE
);

-- 게시글 테이블
CREATE TABLE board (
    postNum INT AUTO_INCREMENT PRIMARY KEY, -- 글 번호
    writer VARCHAR(50), -- 작성자
    title VARCHAR(100), -- 글 제목
    content TEXT, -- 글 내용
    codeContent TEXT, -- 코드
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 작성일자
    views INT NOT NULL DEFAULT 0,  -- 조회수
    programmingLanguage VARCHAR(50), -- 기술스택
    CONSTRAINT fk_board_writer
        FOREIGN KEY (writer)
        REFERENCES member(user_id)
        ON DELETE CASCADE
);

-- 첨부파일 테이블
CREATE TABLE board_attach (
    id INT AUTO_INCREMENT PRIMARY KEY,
    postNum INT,
    filename VARCHAR(40),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_board_attach_postnum
        FOREIGN KEY (postNum)
        REFERENCES board(postNum)
        ON DELETE CASCADE
);

-- 좋아요 테이블
CREATE TABLE likes (
    likeNum INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(50),
    postNum INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_likes_user
        FOREIGN KEY (user_id)
        REFERENCES member(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_likes_post
        FOREIGN KEY (postNum)
        REFERENCES board(postNum)
        ON DELETE CASCADE,
    UNIQUE KEY unique_user_post (user_id, postNum)
);

-- 댓글 대댓글 테이블
CREATE TABLE comment (
    commentId int AUTO_INCREMENT PRIMARY KEY,         -- 댓글대댓글 고유 ID
    postNum int NOT NULL,                             -- 소속 게시글 ID
    userId varchar(50) NOT NULL,                      -- 작성자 ID
    content text NOT NULL,                            -- 댓글 내용
    parentCommentId int DEFAULT NULL,                 -- 부모 댓글 ID (최상위 댓글이면 NULL)
    depth INT DEFAULT 0,                              -- 계층(0 댓글, 1 이상 대댓글)
    isDeleted BOOLEAN DEFAULT FALSE,                  -- 삭제 여부
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,     -- 작성 시각
    updateAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 수정 시각
   CONSTRAINT fk_comment_post
        FOREIGN KEY (postNum)
        REFERENCES board(postNum)
        ON DELETE CASCADE,
    CONSTRAINT fk_comment_user
        FOREIGN KEY (userId)
        REFERENCES member(user_id)
        ON DELETE CASCADE, -- 유저 삭제 시 댓글대댓글 삭제
    CONSTRAINT fk_comment_parent
        FOREIGN KEY (parentCommentId)
        REFERENCES comment(commentId)
        ON DELETE CASCADE
);

UPDATE comment SET depth = 0 WHERE depth IS NULL;

CREATE TABLE news (
    newsId INT AUTO_INCREMENT PRIMARY KEY, -- 뉴스 번호
    title TEXT NOT NULL,                   -- 뉴스 기사 제목
    originallink TEXT NOT NULL,            -- 뉴스 기사 원래 출처
    link TEXT NOT NULL,                    -- 네이버에서 제공하는 뉴스url
    description TEXT NOT NULL,             -- 뉴스 기사 본문
    pubDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 뉴스 기사가 게시된 날짜 및 시간
    query VARCHAR(50),                     -- 뉴스 데이터 가져올 때 사용된 검색 키워드
    category VARCHAR(50),                  -- 뉴스 기사의 주제 분류
    UNIQUE KEY unique_link (link(255))     -- 중복 방지 네이버 뉴스 URL 기준
);

-- 저장된 뉴스 총 갯수 조회
select count() from news;
select from news;



-- 프로그래밍 문제 테이블
CREATE TABLE problems (
    problemId INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    sampleInput TEXT,
    sampleOutput TEXT,
    difficulty VARCHAR(50),
    language VARCHAR(50), -- 새로 추가
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 사용자 제출 코드 테이블
CREATE TABLE submissions (
    submissionId INT AUTO_INCREMENT PRIMARY KEY,
    userId VARCHAR(50) NOT NULL,
    problemId INT NOT NULL,
    code TEXT NOT NULL,
    language VARCHAR(50), -- 새로 추가
    submittedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    isCorrect BOOLEAN DEFAULT FALSE,
    feedback TEXT,
    CONSTRAINT fk_submissions_user
        FOREIGN KEY (userId)
        REFERENCES member(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_submissions_problem
        FOREIGN KEY (problemId)
        REFERENCES problems(problemId)
        ON DELETE CASCADE
);


-- Python Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '두 수의 합',
    '두 정수 a와 b가 주어졌을 때, a와 b의 합을 반환하는 함수를 작성하세요.nn제약조건n- -1000 ≤ a, b ≤ 1000nn입력 두 정수 a, b가 공백으로 구분되어 입력됩니다.n출력 a와 b의 합을 정수로 반환합니다.',
    '3 5',
    '8',
    'Easy',
    'Python'
);
-- Python 2-50 (패턴화된 문제)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '두 수의 곱',
    '두 정수 a와 b가 주어졌을 때, a와 b의 곱을 반환하는 함수를 작성하세요.nn제약조건n- -1000 ≤ a, b ≤ 1000nn입력 두 정수 a, b가 공백으로 구분되어 입력됩니다.n출력 a와 b의 곱을 정수로 반환합니다.',
    '4 6',
    '24',
    'Easy',
    'Python'
);
-- ... (Python 문제 3-50은 유사한 패턴으로 작성, Easy 18개, Medium 20개, Hard 10개)

-- JavaScript Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '배열 뒤집기',
    '정수 배열이 주어졌을 때, 배열의 요소를 뒤집은 새 배열을 반환하는 함수를 작성하세요.nn제약조건n- 배열 길이는 1 이상 1000 이하입니다.n- 배열의 요소는 -1000 이상 1000 이하의 정수입니다.nn입력 정수 배열이 JSON 형식의 문자열로 주어집니다.n출력 뒤집힌 배열을 JSON 형식의 문자열로 반환합니다.',
    '[1, 2, 3, 4, 5]',
    '[5, 4, 3, 2, 1]',
    'Easy',
    'JavaScript'
);
-- ... (JavaScript 문제 2-50은 유사한 패턴으로 작성)

-- Java Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '두 수의 곱',
    '두 정수 a와 b가 주어졌을 때, a와 b의 곱을 반환하는 함수를 작성하세요.nn제약조건n- -1000 ≤ a, b ≤ 1000nn입력 두 정수 a, b가 공백으로 구분되어 입력됩니다.n출력 a와 b의 곱을 정수로 반환합니다.',
    '4 6',
    '24',
    'Easy',
    'Java'
);
-- ... (Java 문제 2-50은 유사한 패턴으로 작성)

-- C++ Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '두 수의 차',
    '두 정수 a와 b가 주어졌을 때, a와 b의 차(a-b)를 반환하는 함수를 작성하세요.nn제약조건n- -1000 ≤ a, b ≤ 1000nn입력 두 정수 a, b가 공백으로 구분되어 입력됩니다.n출력 a와 b의 차를 정수로 반환합니다.',
    '10 4',
    '6',
    'Easy',
    'C++'
);
-- ... (C++ 문제 2-50은 유사한 패턴으로 작성)

-- C Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '두 수의 합',
    '두 정수 a와 b가 주어졌을 때, a와 b의 합을 반환하는 함수를 작성하세요.nn제약조건n- -1000 ≤ a, b ≤ 1000nn입력 두 정수 a, b가 공백으로 구분되어 입력됩니다.n출력 a와 b의 합을 정수로 반환합니다.',
    '3 5',
    '8',
    'Easy',
    'C'
);
-- ... (C 문제 2-50은 유사한 패턴으로 작성)

-- C# Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '팰린드롬 확인',
    '문자열이 주어졌을 때, 해당 문자열이 팰린드롬인지 확인하는 함수를 작성하세요. 대소문자를 구분하지 않습니다.nn제약조건n- 문자열 길이는 1 이상 100 이하입니다.n- 문자열은 알파벳과 숫자로만 구성됩니다.nn입력 문자열n출력 팰린드롬이면 true, 아니면 false',
    'Racecar',
    'true',
    'Medium',
    'C#'
);
-- ... (C# 문제 2-50은 유사한 패턴으로 작성)

-- TypeScript Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '배열의 합',
    '정수 배열이 주어졌을 때, 배열의 모든 요소의 합을 구하는 함수를 작성하세요.nn제약조건n- 배열 길이는 1 이상 1000 이하입니다.n- 배열 요소는 -1000 이상 1000 이하입니다.nn입력 정수 배열 (JSON 형식 문자열)n출력 배열 요소의 합',
    '[1, 2, 3, 4, 5]',
    '15',
    'Easy',
    'TypeScript'
);
-- ... (TypeScript 문제 2-50은 유사한 패턴으로 작성)

-- Go Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '피보나치 수열',
    'n번째 피보나치 수를 구하는 함수를 작성하세요. 피보나치 수열은 F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2)로 정의됩니다.nn제약조건n- 0 ≤ n ≤ 30nn입력 정수 nn출력 n번째 피보나치 수',
    '7',
    '13',
    'Medium',
    'Go'
);
-- ... (Go 문제 2-50은 유사한 패턴으로 작성)

-- Rust Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '중복 제거',
    '정수 배열에서 중복된 요소를 제거한 새 배열을 반환하는 함수를 작성하세요.nn제약조건n- 배열 길이는 1 이상 1000 이하입니다.n- 배열 요소는 -1000 이상 1000 이하입니다.nn입력 정수 배열n출력 중복이 제거된 배열 (순서 유지)',
    '[1, 2, 2, 3, 3, 4]',
    '[1, 2, 3, 4]',
    'Medium',
    'Rust'
);
-- ... (Rust 문제 2-50은 유사한 패턴으로 작성)

-- Swift Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '소수 판별',
    '주어진 정수 n이 소수인지 판별하는 함수를 작성하세요. 소수는 1보다 큰 정수로, 1과 자신만을 약수로 가집니다.nn제약조건n- 1 ≤ n ≤ 1000000nn입력 정수 nn출력 소수이면 true, 아니면 false',
    '17',
    'true',
    'Easy',
    'Swift'
);
-- ... (Swift 문제 2-50은 유사한 패턴으로 작성)

-- Kotlin Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '문자열 분리',
    '문자열과 구분자를 입력받아 구분자로 문자열을 분리한 배열을 반환하는 함수를 작성하세요.nn제약조건n- 문자열 길이는 1 이상 100 이하입니다.n- 구분자는 단일 문자입니다.nn입력 문자열과 구분자 (공백으로 구분)n출력 분리된 문자열 배열 (JSON 형식)',
    'hello,world ,',
    '[hello, world]',
    'Medium',
    'Kotlin'
);
-- ... (Kotlin 문제 2-50은 유사한 패턴으로 작성)

-- PHP Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '배열의 최대값',
    '정수 배열이 주어졌을 때, 배열에서 가장 큰 값을 반환하는 함수를 작성하세요.nn제약조건n- 배열 길이는 1 이상 1000 이하입니다.n- 배열 요소는 -1000 이상 1000 이하입니다.nn입력 정수 배열 (공백으로 구분)n출력 최대값',
    '3 5 2 8 1',
    '8',
    'Easy',
    'PHP'
);
-- ... (PHP 문제 2-50은 유사한 패턴으로 작성)

-- Ruby Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '팩토리얼 계산',
    '정수 n이 주어졌을 때, n의 팩토리얼을 계산하는 함수를 작성하세요.nn제약조건n- 0 ≤ n ≤ 12nn입력 정수 nn출력 n의 팩토리얼',
    '5',
    '120',
    'Easy',
    'Ruby'
);
-- ... (Ruby 문제 2-50은 유사한 패턴으로 작성)

-- Dart Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '문자열 반복',
    '문자열과 반복 횟수 n을 입력받아 문자열을 n번 반복한 결과를 반환하는 함수를 작성하세요.nn제약조건n- 문자열 길이는 1 이상 100 이하입니다.n- 1 ≤ n ≤ 10nn입력 문자열과 정수 n (공백으로 구분)n출력 반복된 문자열',
    'abc 3',
    'abcabcabc',
    'Medium',
    'Dart'
);
-- ... (Dart 문제 2-50은 유사한 패턴으로 작성)

-- R Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '평균 계산',
    '정수 배열이 주어졌을 때, 배열 요소의 평균을 계산하는 함수를 작성하세요.nn제약조건n- 배열 길이는 1 이상 1000 이하입니다.n- 배열 요소는 -1000 이상 1000 이하입니다.nn입력 정수 배열 (공백으로 구분)n출력 평균값 (소수점 둘째 자리까지)',
    '1 2 3 4 5',
    '3.00',
    'Easy',
    'R'
);
-- ... (R 문제 2-50은 유사한 패턴으로 작성)

-- Julia Problems (50)
INSERT INTO problems (title, description, sampleInput, sampleOutput, difficulty, language)
VALUES (
    '삼각수 계산',
    'n번째 삼각수를 계산하는 함수를 작성하세요. 삼각수는 1부터 n까지의 합입니다.nn제약조건n- 1 ≤ n ≤ 1000nn입력 정수 nn출력 n번째 삼각수',
    '5',
    '15',
    'Medium',
    'Julia'
);


commit;
