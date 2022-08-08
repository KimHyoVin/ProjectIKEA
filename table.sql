DROP SEQUENCE REVIEW_SEQ;
DROP SEQUENCE IMAGE_SEQ;
DROP SEQUENCE CART_SEQ;
DROP SEQUENCE WISHLIST_SEQ;
DROP SEQUENCE REFUND_SEQ;
DROP SEQUENCE ORDERS_SEQ;
DROP SEQUENCE MEMBER_SEQ;
DROP SEQUENCE PRODUCT_SEQ;

DROP TABLE PRODUCT_REVIEW;
DROP TABLE PRODUCT_IMAGE;
DROP TABLE CART;
DROP TABLE WISHLIST;
DROP TABLE REFUND;
DROP TABLE ORDERS;
DROP TABLE MEMBER;
DROP TABLE PRODUCT;

CREATE SEQUENCE REVIEW_SEQ          START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE SEQUENCE IMAGE_SEQ           START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE SEQUENCE CART_SEQ            START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE SEQUENCE WISHLIST_SEQ        START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE SEQUENCE REFUND_SEQ          START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE SEQUENCE ORDERS_SEQ          START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE SEQUENCE MEMBER_SEQ          START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 NOCYCLE NOCACHE;
CREATE SEQUENCE PRODUCT_SEQ         START WITH 1 MAXVALUE 999999999 INCREMENT BY 1 NOCYCLE NOCACHE;

CREATE TABLE PRODUCT (
    PRODUCT_IDX             NUMBER          DEFAULT PRODUCT_SEQ.NEXTVAL PRIMARY KEY,    -- 상품 인덱스
    PRODUCT_CATEGORY        VARCHAR2(20)    NOT NULL,   -- 최하위 카테고리
    PRODUCT_NAME            VARCHAR2(100)   UNIQUE NOT NULL,    -- 상품명
    PRODUCT_DESC            VARCHAR2(2000),   			-- 상품 설명
    PRODUCT_LENGTH          NUMBER,                     -- 상품 길이(cm)
    PRODUCT_WIDTH           NUMBER,                     -- 상품 너비(cm)
    PRODUCT_HEIGHT          NUMBER,                     -- 상품 높이(cm)
    PRODUCT_COLOR           VARCHAR2(50),               -- 상품 색상
    PRODUCT_PRICE           NUMBER          NOT NULL,
    PRODUCT_STOCK           NUMBER          NOT NULL,   -- 상품 재고
    PRODUCT_SALEQUANTITY    NUMBER          DEFAULT 0,  -- 상품 판매량
    PRODUCT_REGDATE         DATE            DEFAULT SYSDATE     -- 상품 등록일
);

CREATE TABLE MEMBER (
    MEMBER_IDX              NUMBER          DEFAULT MEMBER_SEQ.NEXTVAL PRIMARY KEY,     -- 고객 인덱스
    MEMBER_EMAIL            VARCHAR2(40)    NOT NULL,  -- ID 역할을  EMAIL이 대신함
    MEMBER_PW               VARCHAR2(20)    NOT NULL,
    MEMBER_NAME             VARCHAR2(20)    NOT NULL,
    MEMBER_BIRTH            DATE            NOT NULL,
    MEMBER_PNUM             VARCHAR2(20)    NOT NULL,   -- 전화번호
    MEMBER_ZIPCODE          VARCHAR2(20)    NOT NULL,   -- 우편번호
    MEMBER_ADDRESS          VARCHAR2(100)   NOT NULL,   -- 주소
    MEMBER_GENDER           CHAR(1)         CHECK(MEMBER_GENDER IN ('M', 'F', 'X')), -- 성별('M' = 남, 'F' = 여, 'X' = 응답거부) 
    MEMBER_REGDATE          DATE            DEFAULT SYSDATE,   -- 회원 가입일
    MEMBER_ISDELETED        NUMBER          CHECK(MEMBER_ISDELETED IN (1, 0))   --ISDELETED 즉, 삭제 하였지만 데이터에는 남아있다.
);

CREATE TABLE PRODUCT_REVIEW (
    REVIEW_IDX              NUMBER          DEFAULT REVIEW_SEQ.NEXTVAL PRIMARY KEY,     -- 상품 리뷰 인덱스
    REVIEW_PI               NUMBER          NOT NULL,   -- FK : 상품 인덱스
    PARENT_REVIEW           NUMBER          NOT NULL,   -- 상위 리뷰 인덱스(대댓글 구현을 위함). 상위 리뷰가 없을 시(최상위 리뷰일 시) -> 0
    REVIEW_WRITER           VARCHAR2(20)    NOT NULL,   -- 리뷰 작성자
    REVIEW_TITLE            VARCHAR2(50)    NOT NULL,	-- 리뷰 제목
    REVIEW_POINT_ASSEMBLY   NUMBER,   -- 평가 1 : 손쉬운 조립 / 설
    REVIEW_POINT_COSPER     NUMBER,   -- 평가 2 : 제품 가성비
    REVIEW_POINT_QUALITY    NUMBER,   -- 평가 3 : 제품 품질
    REVIEW_POINT_SHAPE      NUMBER,   -- 평가 4 : 제품 외관
    REVIEW_POINT_FUNCTION   NUMBER,   -- 평가 5 : 제품 기능
    REVIEW_CONTENT          VARCHAR2(2000)  NOT NULL,   -- 리뷰 내용
    REVIEW_RECOMMEND        CHAR(1)         CHECK(REVIEW_RECOMMEND IN ('Y', 'N', 'X')) NOT NULL,	-- 추천 하시겠습니까? ('Y' = 네, 'N' = 아니오, 'X' = 응답없음)
    REVIEW_REGDATE          DATE            DEFAULT SYSDATE,     -- 리뷰 작성일
    
    CONSTRAINT REVIEW_PRODUCT_FK FOREIGN KEY(REVIEW_PI) REFERENCES PRODUCT(PRODUCT_IDX) ON DELETE CASCADE
);

CREATE TABLE PRODUCT_IMAGE (
    IMAGE_IDX               NUMBER          DEFAULT IMAGE_SEQ.NEXTVAL PRIMARY KEY,  -- 상품 이미지 인덱스
    IMAGE_PI                NUMBER          NOT NULL,   -- FK : 상품 인덱스
    IMAGE_FILENAME          VARCHAR2(128)   NOT NULL,   -- 이미지 파일명 (SHA-512를 사용할 경우, 딱 128자)
    IMAGE_ISTHUMBNAIL1      CHAR(1)         CHECK(IMAGE_ISTHUMBNAIL1 IN ('Y', 'N')) NOT NULL,    -- 1번 대표 이미지인가? ('Y' OR 'N') 
    IMAGE_ISTHUMBNAIL2      CHAR(1)         CHECK(IMAGE_ISTHUMBNAIL2 IN ('Y', 'N')) NOT NULL,    -- 2번 대표 이미지인가? ('Y' OR 'N') (마우스 오버시 나타나는 대표 이미지)
    IMAGE_REGDATE           DATE            DEFAULT SYSDATE,     -- 이미지 등록일
    
    CONSTRAINT IMAGE_PRODUCT_FK FOREIGN KEY(IMAGE_PI) REFERENCES PRODUCT(PRODUCT_IDX) ON DELETE CASCADE
);

CREATE TABLE CART (
    CART_IDX                NUMBER          DEFAULT CART_SEQ.NEXTVAL PRIMARY KEY,   -- 카트(에 담은 상품) 인덱스
    CART_PI                 NUMBER          NOT NULL,   -- FK : 상품 인덱스
    CART_MI                 NUMBER          NOT NULL,   -- FK : 고객 인덱스
    CART_COUNT              NUMBER          NOT NULL,   -- 해당 상품 수량
    CART_REGDATE            DATE            DEFAULT SYSDATE,    -- 카트에 상품을 추가한 날
    
    CONSTRAINT CART_PRODUCT_FK FOREIGN KEY(CART_PI) REFERENCES PRODUCT(PRODUCT_IDX) ON DELETE CASCADE,
    CONSTRAINT CART_MEMBER_FK FOREIGN KEY(CART_MI) REFERENCES MEMBER(MEMBER_IDX) ON DELETE CASCADE
);

CREATE TABLE WISHLIST (
    WISHLIST_IDX            NUMBER          DEFAULT WISHLIST_SEQ.NEXTVAL PRIMARY KEY,   -- 위시리스트(에 담은 상품) 인덱스
    WISHLIST_PI             NUMBER          NOT NULL,   -- FK : 상품 인덱스
    WISHLIST_MI             NUMBER          NOT NULL,   -- FK : 고객 인덱스
    WISHLIST_COUNT          NUMBER          NOT NULL,   -- 해당 상품 수량
    WISHLIST_REGDATE        DATE            DEFAULT SYSDATE,    -- 위시리스트에 상품을 추가한 날
    
    CONSTRAINT WISHLIST_PRODUCT_FK FOREIGN KEY(WISHLIST_PI) REFERENCES PRODUCT(PRODUCT_IDX) ON DELETE CASCADE,
    CONSTRAINT WISHLIST_MEMBER_FK FOREIGN KEY(WISHLIST_MI) REFERENCES MEMBER(MEMBER_IDX) ON DELETE CASCADE
);

CREATE TABLE ORDERS (
    ORDERS_IDX              NUMBER          DEFAULT ORDERS_SEQ.NEXTVAL PRIMARY KEY,     -- 주문(된 상품) 인덱스
    ORDERS_PI               NUMBER          NOT NULL,   -- FK : 상품 인덱스
    ORDERS_MI               NUMBER          NOT NULL,   -- FK : 고객 인덱스
    ORDERS_QUANTITY         NUMBER          NOT NULL,   -- 해당 상품 주문 수량
    ORDERS_STATUS           VARCHAR2(50),               -- 주문상태
    ORDERS_REGDATE          DATE            DEFAULT SYSDATE,    -- 주문 날짜
    
    CONSTRAINT ORDERS_PRODUCT_FK FOREIGN KEY(ORDERS_PI) REFERENCES PRODUCT(PRODUCT_IDX) ON DELETE CASCADE,
    CONSTRAINT ORDERS_MEMBER_FK FOREIGN KEY(ORDERS_MI) REFERENCES MEMBER(MEMBER_IDX) ON DELETE CASCADE
);

CREATE TABLE REFUND (
    REFUND_IDX              NUMBER          DEFAULT REFUND_SEQ.NEXTVAL PRIMARY KEY,     -- 환불(신청된 상품) 인덱스
    REFUND_OI               NUMBER          NOT NULL,   -- FK : 주문(된 상품) 인덱스
    REFUND_REASON           VARCHAR2(2000)  NOT NULL,   -- 환불 사유
    REFUND_IMAGENAME        VARCHAR2(50),               -- 환불 신청 시 첨부한 이미지명
    REFUND_REGDATE          DATE            DEFAULT SYSDATE,    -- 환불 신청 날짜
    
    CONSTRAINT REFUND_ORDERS_FK FOREIGN KEY(REFUND_OI) REFERENCES ORDERS(ORDERS_IDX) ON DELETE CASCADE
);

COMMIT;

INSERT INTO MEMBER( MEMBER_EMAIL, MEMBER_PW, MEMBER_NAME, MEMBER_BIRTH,  MEMBER_PNUM, MEMBER_ZIPCODE, MEMBER_ADDRESS, MEMBER_GENDER, MEMBER_ISDELETED) VALUES ( 'dummy1@gmail.com', 'dummypw1', '김더미', '1990-03-09',  '01012345678', '48051', '부산시 수영구 남천동 A아파트 101-1101', 'M',0);
INSERT INTO MEMBER( MEMBER_EMAIL, MEMBER_PW, MEMBER_NAME, MEMBER_BIRTH,  MEMBER_PNUM, MEMBER_ZIPCODE, MEMBER_ADDRESS, MEMBER_GENDER, MEMBER_ISDELETED) VALUES ( 'dummy2@gmail.com', 'dummypw2', '박더미', '1993-01-22',  '01087654321', '56491', '부산시 해운구 재송동 B아파트 201-102', 'F', 0);
INSERT INTO MEMBER( MEMBER_EMAIL, MEMBER_PW, MEMBER_NAME, MEMBER_BIRTH,  MEMBER_PNUM, MEMBER_ZIPCODE, MEMBER_ADDRESS, MEMBER_GENDER, MEMBER_ISDELETED) VALUES ( 'dummy3@gmail.com', 'dummypw3', '이더미', '1995-06-19',  '01044434443', '1710021', '부산시 남구 전월동 C아파트 501-803', 'X', 0);
-- ISDELETED 

INSERT INTO PRODUCT(PRODUCT_CATEGORY, PRODUCT_NAME, PRODUCT_DESC, PRODUCT_LENGTH, PRODUCT_WIDTH, PRODUCT_HEIGHT, PRODUCT_COLOR, PRODUCT_PRICE, PRODUCT_STOCK, PRODUCT_SALEQUANTITY)
    VALUES('식물', 'HIMALAYAMIX 히말라위아믹스 식물', '살아 있는 화초로 자연을 집 안에 들이면 공간이 더 따뜻하고 아늑해지죠. 스트레스를 줄이고 창의력을 북돋아 건강한 생활을 하는 데도 도움이 돼요. 아주 완벽한 룸메이트죠!', '', '', '', '', 5500, 10, 10);
INSERT INTO PRODUCT(PRODUCT_CATEGORY, PRODUCT_NAME, PRODUCT_DESC, PRODUCT_LENGTH, PRODUCT_WIDTH, PRODUCT_HEIGHT, PRODUCT_COLOR, PRODUCT_PRICE, PRODUCT_STOCK, PRODUCT_SALEQUANTITY)
    VALUES('식물', 'SUCCULENT 수쿨렌트', '이 화초는 관리가 쉽고, 물 없이도 오랫동안 살아남을 수 있어요. 원예 솜씨가 뛰어나지 않아도 키울 수 있죠. 화초가 행복지수를 높여주고 집안 분위기를 더욱 활기 있게 해준다는 사실, 알고 계셨나요?', '', '', '', '', 2900, 10, 10);
INSERT INTO PRODUCT(PRODUCT_CATEGORY, PRODUCT_NAME, PRODUCT_DESC, PRODUCT_LENGTH, PRODUCT_WIDTH, PRODUCT_HEIGHT, PRODUCT_COLOR, PRODUCT_PRICE, PRODUCT_STOCK, PRODUCT_SALEQUANTITY)
    VALUES('식물', 'KALANCHOE 칼란쇼에', '살아 있는 화초가 집 안에 있으면 분위기가 금세 더 아늑하고 따뜻해져요. 스트레스를 줄이고 창의력을 북돋아 건강에도 유익하다는 사실, 알고 계셨나요? 녹색 식물에는 자연 치유 효과가 있답니다!', '', '', '', '', 3500, 10, 10);
INSERT INTO PRODUCT(PRODUCT_CATEGORY, PRODUCT_NAME, PRODUCT_DESC, PRODUCT_LENGTH, PRODUCT_WIDTH, PRODUCT_HEIGHT, PRODUCT_COLOR, PRODUCT_PRICE, PRODUCT_STOCK, PRODUCT_SALEQUANTITY)
    VALUES('식물', 'RADERMACHERA 라데르마셰라', '', '', '', '', '', 17900, 10, 10);
INSERT INTO PRODUCT(PRODUCT_CATEGORY, PRODUCT_NAME, PRODUCT_DESC, PRODUCT_LENGTH, PRODUCT_WIDTH, PRODUCT_HEIGHT, PRODUCT_COLOR, PRODUCT_PRICE, PRODUCT_STOCK, PRODUCT_SALEQUANTITY)
    VALUES('식물', 'SPATHIPHYLLUM 스파팁휠룸', '관리가 쉬운 이 화초의 잎이 떨어지면 물이 필요하다는 신호예요. 이해하기 쉽죠. 행복지수를 높이고 집안을 활기 있게 만드는 데도 도움을 줘요.', '', '', '', '', 5500, 10, 10);
INSERT INTO PRODUCT(PRODUCT_CATEGORY, PRODUCT_NAME, PRODUCT_DESC, PRODUCT_LENGTH, PRODUCT_WIDTH, PRODUCT_HEIGHT, PRODUCT_COLOR, PRODUCT_PRICE, PRODUCT_STOCK, PRODUCT_SALEQUANTITY)
    VALUES('식물', 'DRACAENA DEREMENSIS 드라카에나 데레멘시스', '', '', '', '', '', 39900, 10, 10);
INSERT INTO PRODUCT(PRODUCT_CATEGORY, PRODUCT_NAME, PRODUCT_DESC, PRODUCT_LENGTH, PRODUCT_WIDTH, PRODUCT_HEIGHT, PRODUCT_COLOR, PRODUCT_PRICE, PRODUCT_STOCK, PRODUCT_SALEQUANTITY)
    VALUES('식물', 'HEDERA HELIX 헤데라 헬릭스', '빠르게 자라는 이 덩굴 식물은 실내나 아주 춥지만 않다면 실외 어디에도 둘 수 있어요. 그런데, 화초가 행복지수를 높여주고 집안 분위기를 더욱 활기 있게 해준다는 사실, 알고 계셨나요?', '', '', '', '', 5500, 10, 10);
INSERT INTO PRODUCT(PRODUCT_CATEGORY, PRODUCT_NAME, PRODUCT_DESC, PRODUCT_LENGTH, PRODUCT_WIDTH, PRODUCT_HEIGHT, PRODUCT_COLOR, PRODUCT_PRICE, PRODUCT_STOCK, PRODUCT_SALEQUANTITY)
    VALUES('식물', 'FICUS ELASTICA 피쿠스 엘라스티카', '', '', '', '', '', 17900, 10, 10);
    
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (1, 'ImageToStl.com_himalayamix-potted-plant-assorted__0554646_pe659867_s5.jpg', 'Y', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (2, 'succulent-potted-plant-assorted__0523259_pe643699_s5.webp', 'Y', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (2, 'succulent-potted-plant-assorted__0900517_pe697508_s5.jpg', 'N', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (2, 'succulent-potted-plant-assorted__0900656_pe643698_s5.jpg', 'N', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (2, 'succulent-potted-plant-assorted__0900652_pe626419_s5.jpg', 'N', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (2, 'succulent-potted-plant-assorted__0554995_pe660076_s5.webp', 'N', 'Y');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (3, 'kalanchoe-potted-plant-flaming-katy-assorted__0554648_pe659869_s5.webp', 'Y', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (3, 'kalanchoe-potted-plant-flaming-katy-assorted__1138991_pe880185_s5.webp', 'N', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (3, 'kalanchoe-potted-plant-flaming-katy-assorted__0554667_pe659890_s5.webp', 'N', 'Y');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (4, 'radermachera-potted-plant-china-doll__0554652_pe659872_s5.webp', 'Y', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (5, 'spathiphyllum-potted-plant-peace-lily__0554657_pe659875_s5.webp', 'Y', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (5, 'spathiphyllum-potted-plant-peace-lily__0902416_pe643696_s5.webp', 'N', 'Y');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (6, 'dracaena-deremensis-potted-plant__0554638_pe659878_s5.webp', 'Y', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (6, 'dracaena-deremensis-potted-plant__0554664_pe659887_s5.webp', 'N', 'Y');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (7, 'hedera-helix-potted-plant-ivy-assorted__0554644_pe659866_s5.webp', 'Y', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (7, 'hedera-helix-potted-plant-ivy-assorted__67451_pe181292_s5.webp', 'N', 'N');
INSERT INTO PRODUCT_IMAGE(IMAGE_PI, IMAGE_FILENAME, IMAGE_ISTHUMBNAIL1, IMAGE_ISTHUMBNAIL2) VALUES (8, 'ficus-elastica-potted-plant-rubber-plant__0554641_pe659882_s5.webp', 'Y', 'N');    
    
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (1, 0, '김더미', '아직 키우는 중', 5, 4, 5, '처음 산 아이는 말려 죽여버려서.. ㅠㅠ 두번째 키우는 방법 찾아보고 아직까지 잘 있습니다 너무나 이쁜 아이 잘 키워보겠습니다', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (1, 0, '이더미', '신선한 히말라위아믹스', 4, 4, 4, '전 만족해요', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (1, 0, '박더미', '잘 크는중', 3, 3, 4, '아이들 관찰용으로 구매 일단 죽지 않고 있음', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (2, 0, '김더미', '키우기가 조금 까다로워요 ㅠ', 3, 2, 4, '한달도 안되 이별을 했어요.. 원예초보이시면 패스..ㅠ', 'N');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (2, 0, '이더미', '쪼매한귀요미', 5, 5, 5, '요즘 다육에 빠져있었는데 너무이쁩니다 쪼금씩자라고 있어 사랑스럽습니다', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (2, 0, '박더미', '귀엽고 이쁘네요^^', 5, 5, 5, '키우기도 쉽고 귀여우면서 이쁘네요~~~^^', 'N');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (3, 0, '김더미', '너무 이쁩니다.', 5, 5, 5, '너무 이쁩니다.', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (3, 0, '이더미', '이뿐꽃', 5, 5, 5, '이왕이면 쿼리티있는 화분에 담아서 판매햇으면', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (3, 0, '박더미', '잘자라고 있고', 4, 5, 5, '꽃이 예쁨', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (4, 0, '김더미', '아주만족..', 5, 5, 5, '엄마께서 구입하셨는데.. 주변분들도 보시고 이쁘고 특히 가격이 좋았다고..ㅋㅋ', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (4, 0, '이더미', '진딧물 많은 녹보수', 0, 0, 0, '"라데르마세라" 이름은 그럴싸하니 좋죠. 첫번째 구매후 죽어 내보내고, 이번에 두번째 구매입니다. 매장 조명에서는 확인 못했는데, 집에 가져와서 보니 잎 마다 좁쌀같이 작은 벌레먹은 자국이 무수했어요. 자세히 보니까 새 잎마다 "진딧물"이 가득. 지금까지 "비*킬"이란 약제값만 2만원 이상 들었고 많은 시간, 노력을 들여 진딧물과 전쟁 중입니다. 시중보다 약간 비싸도 이케아 브랜드의 품질관리를 신뢰했는데. 개불만입니다. 가성비 따지지 마세요. 차라리 일반 화원에서 살걸 그랬나. 비추천 !!', 'X');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (4, 0, '박더미', '실내 화분', 4, 5, 5, '실내화분으로 사이즈가 적당하니 좋아요 단점은 더 저렴한가격으로 공급해주세요', 'Y');
	
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (5, 0, '김더미', '아직 키우는 중', 5, 4, 5, '처음 산 아이는 말려 죽여버려서.. ㅠㅠ 두번째 키우는 방법 찾아보고 아직까지 잘 있습니다 너무나 이쁜 아이 잘 키워보겠습니다', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (5, 0, '이더미', '신선한 히말라위아믹스', 4, 4, 4, '전 만족해요', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (5, 0, '박더미', '잘 크는중', 3, 3, 4, '아이들 관찰용으로 구매 일단 죽지 않고 있음', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (6, 0, '김더미', '키우기가 조금 까다로워요 ㅠ', 3, 2, 4, '한달도 안되 이별을 했어요.. 원예초보이시면 패스..ㅠ', 'N');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (6, 0, '이더미', '쪼매한귀요미', 5, 5, 5, '요즘 다육에 빠져있었는데 너무이쁩니다 쪼금씩자라고 있어 사랑스럽습니다', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (6, 0, '박더미', '귀엽고 이쁘네요^^', 5, 5, 5, '키우기도 쉽고 귀여우면서 이쁘네요~~~^^', 'N');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (7, 0, '김더미', '너무 이쁩니다.', 5, 5, 5, '너무 이쁩니다.', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (7, 0, '이더미', '이뿐꽃', 5, 5, 5, '이왕이면 쿼리티있는 화분에 담아서 판매햇으면', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (7, 0, '박더미', '잘자라고 있고', 4, 5, 5, '꽃이 예쁨', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (8, 0, '김더미', '아주만족..', 5, 5, 5, '엄마께서 구입하셨는데.. 주변분들도 보시고 이쁘고 특히 가격이 좋았다고..ㅋㅋ', 'Y');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (8, 0, '이더미', '진딧물 많은 녹보수', 0, 0, 0, '"라데르마세라" 이름은 그럴싸하니 좋죠. 첫번째 구매후 죽어 내보내고, 이번에 두번째 구매입니다. 매장 조명에서는 확인 못했는데, 집에 가져와서 보니 잎 마다 좁쌀같이 작은 벌레먹은 자국이 무수했어요. 자세히 보니까 새 잎마다 "진딧물"이 가득. 지금까지 "비*킬"이란 약제값만 2만원 이상 들었고 많은 시간, 노력을 들여 진딧물과 전쟁 중입니다. 시중보다 약간 비싸도 이케아 브랜드의 품질관리를 신뢰했는데. 개불만입니다. 가성비 따지지 마세요. 차라리 일반 화원에서 살걸 그랬나. 비추천 !!', 'X');
INSERT INTO PRODUCT_REVIEW(REVIEW_PI, PARENT_REVIEW, REVIEW_WRITER, REVIEW_TITLE, REVIEW_POINT_COSPER, REVIEW_POINT_QUALITY, REVIEW_POINT_SHAPE, REVIEW_CONTENT, REVIEW_RECOMMEND) 
	VALUES (8, 0, '박더미', '실내 화분', 4, 5, 5, '실내화분으로 사이즈가 적당하니 좋아요 단점은 더 저렴한가격으로 공급해주세요', 'Y');
    
COMMIT;

SELECT PRODUCT.PRODUCT_NAME, PRODUCT_IMAGE.IMAGE_FILENAME AS FILENAME 
    FROM PRODUCT 
    JOIN PRODUCT_IMAGE 
    ON PRODUCT_IDX = IMAGE_PI;    
