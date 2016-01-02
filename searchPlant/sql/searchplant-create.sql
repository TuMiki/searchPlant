--
-- オリジナルには、以下の2箇所の誤りあり
-- １．2000行付近に2行に分割された箇所があり、レコードがずれている
-- ２．通番の１桁目が欠落して重複番号となっているレコードがある
-- ３．名前に半角空白（区切り文字）がある行がある
-- また、1行目に通番と名前、2行目に分類リストの2行組になっているため
-- vimで
-- :gloval /^ normal J
-- として2行を結合しておく
--
-- オリジナルとの変更点
-- 名前を半角文字から全角文字に変更
-- 文字コードをSJISからUTF-8に変更
--
-- cmd を使ってUTF-8を扱うには以下の手順で起動する
--    1.コマンドプロンプトを実行する
--    2.プロパティ ＞ フォント ＞ フォント で 【MSゴシック】を選択する
--    3.コードページをUTF-8に変更する
--      chcp 65001
--    ただ、これでもメッセージは英語になるしUTF-8は表示が化ける（ファイルに書き込めばエディタでは正しく表示される）。
--
-- テーブル作成 ＆ 初期データセット
-- cd C:\Users\Fitso\Desktop\searchPlant\sqlite3
-- sqlite3 searchPlant.sqlite3
-- .read searchplant-create.sql

drop table if exists wk_searchPlant;
create table if not exists wk_searchPlant (lno number, name varchar,
	col01 varchar,
	col02 varchar,
	col03 varchar,
	col04 varchar,
	col05 varchar,
	col06 varchar,
	col07 varchar,
	col08 varchar,
	col09 varchar,
	col10 varchar,
	col11 varchar,
	col12 varchar,
	col13 varchar,
	col14 varchar,
	col15 varchar,
	col16 varchar,
	col17 varchar,
	col18 varchar,
	col19 varchar,
	col20 varchar,
	col21 varchar,
	col22 varchar,
	col23 varchar,
	col24 varchar,
	col25 varchar,
	col26 varchar,
	col27 varchar,
	col28 varchar,
	col29 varchar,
	col30 varchar,
	col31 varchar,
	col32 varchar,
	col33 varchar,
	col34 varchar,
	col35 varchar,
	col36 varchar,
	col37 varchar,
	col38 varchar,
	col39 varchar,
	col40 varchar,
	col41 varchar,
	col42 varchar,
	col43 varchar,
	col44 varchar,
	col45 varchar,
	col46 varchar,
	col47 varchar,
	col48 varchar,
	col49 varchar,
	col50 varchar,
	col51 varchar,
	col52 varchar,
	col53 varchar,
	col54 varchar,
	col55 varchar,
	col56 varchar,
	col57 varchar,
	col58 varchar,
	col59 varchar,
	col60 varchar,
	col61 varchar,
	col62 varchar,
	col63 varchar,
	col64 varchar,
	col65 varchar,
	col66 varchar,
	col67 varchar,
	col68 varchar,
	col69 varchar,
	col70 varchar,
	col71 varchar,
	col72 varchar,
	col73 varchar,
	col74 varchar,
	col75 varchar,
	col76 varchar,
	col77 varchar,
	col78 varchar,
	col79 varchar,
	col80 varchar,
	col81 varchar,
	col82 varchar,
	col83 varchar,
	col84 varchar,
	col85 varchar,
	col86 varchar,
	col87 varchar,
	col88 varchar,
	col89 varchar,
	col90 varchar

);

-- データ取り込み
-- まずは、CSVの内容をそのまま取り込む
.separator ','
.import C:/Users/Fitso/Desktop/searchPlant/sqlite3/data-utf8.csv wk_searchPlant

-- テーブルを全部削除する
drop table if exists searchPlant_1;
create table if not exists searchPlant_1 (lno number primary key, name varchar, family varchar);

drop table if exists searchPlant_2;
create table if not exists searchPlant_2 (lno number not null, searchKey varchar not null, searchKey_1 varchar, searchKey_2 varchar, primary key(lno, searchKey) );

-- キーと名前を取り込む
insert  into searchplant_1 (lno, name) select  lno, name from wk_searchPlant;

-- 科名を取り込む
-- 項目を取り込んだ後でインデックスを張る
update searchplant_1 set family = (select b.searchkey from searchplant_2 b where searchplant_1.lno = b.lno and substr(b.searchkey, 1, 1) = '9');
create unique index ix_lno on searchplant_1(lno);

-- 検索条件の項目をCSVから取り込んだテーブルから正規化したテーブルに取り込む
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col01 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col02 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col03 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col04 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col05 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col06 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col07 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col08 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col09 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col10 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col11 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col12 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col13 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col14 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col15 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col16 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col17 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col18 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col19 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col20 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col21 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col22 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col23 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col24 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col25 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col26 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col27 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col28 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col29 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col30 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col31 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col32 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col33 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col34 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col35 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col36 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col37 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col38 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col39 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col40 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col41 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col42 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col43 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col44 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col45 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col46 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col47 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col48 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col49 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col50 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col51 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col52 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col53 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col54 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col55 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col56 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col57 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col58 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col59 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col60 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col61 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col62 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col63 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col64 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col65 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col66 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col67 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col68 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col69 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col70 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col71 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col72 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col73 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col74 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col75 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col76 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col77 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col78 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col79 from wk_searchPlant;
insert or ignore into searchPlant_2 (lno, searchKey) select lno, col80 from wk_searchPlant;

-- nullのレコードを削除する
delete  from searchplant_2 where searchkey is null;
delete from searchplant_2 where substr(searchkey, 1, 1) = '9';

-- 6行ある重複行を削除
-- LNO 	SEARCHKEY
-- 562	3304 連続重複
-- 1202	5701 連続重複
-- 835	1202 連続重複
-- 96	3305 連続ではないが葉脈は中央のみではないため、重複と判断
-- 1879	3501 連続重複
-- 1487	7102 連続重複

/*
select b.lno, a.name, b.searchkey from
searchplant_1 a
,searchplant_2 b
where
a.lno = b.lno
order by a.lno, b.searchkey
*/

-- 検索条件を部位と部位の特徴に分ける
update searchplant_2 set
searchKey_1 = substr(searchkey, 1, 2),
searchkey_2 = substr(searchkey, 3,2);

-- 変更が終わったのでインデックスを張る
create index ix_searchplant_2_1 on searchplant_2(searchKey_1, searchkey_2);

/*
select searchKey_1, max(cnt) from (
select  searchkey_1, count(*) cnt from searchplant_2 group by lno, searchkey_1
)
group by searchKey_1
order by searchkey_1;
*/

-- CSV取り込みに使ったテーブルは、不要なので削除
drop table if exists wk_searchPlant;

-- 検索条件をすべて用意したテーブルを作る
-- CSVでは、該当した条件のみの列挙されているが、ここでは、すべての条件項目を用意して、該当条件に値が入った項目を用意する
drop table if exists plant_trait;
create table if not exists plant_trait (
	lno number not null,
	-- 茎 > 形
	aaA varchar,
	aaB varchar,
	aaC varchar,
	aaD varchar,
	aaE varchar,
	aaF varchar,
	aaG varchar,
	-- 茎 > 表面
	abA varchar,
	abB varchar,
	abC varchar,
	abD varchar,
	-- 茎 > 切口
	acA varchar,
	acB varchar,
	acC varchar,
	acD varchar,
	acE varchar,
	-- 葉 > 形
	caA varchar,
	caB varchar,
	caC varchar,
	caD varchar,
	caE varchar,
	caF varchar,
	caG varchar,
	caH varchar,
	caI varchar,
	-- 葉 > 先
	cbA varchar,
	cbB varchar,
	cbC varchar,
	-- 葉 > もと
	ccA varchar,
	ccB varchar,
	ccC varchar,
	-- 葉 > ふち
	cdA varchar,
	cdB varchar,
	cdC varchar,
	cdD varchar,
	cdE varchar,
	cdF varchar,
	-- 葉 > 脈
	ceA varchar,
	ceB varchar,
	ceC varchar,
	ceD varchar,
	ceE varchar,
	-- 葉 > 柄
	cfA varchar,
	cfB varchar,
	cfC varchar,
	cfD varchar,
	cfE varchar,
	cfF varchar,
	cfG varchar,
	-- 葉 > 托葉
	cgA varchar,
	cgB varchar,
	cgC varchar,
	cgD varchar,
	-- 葉 > つき方
	chA varchar,
	chB varchar,
	chC varchar,
	chD varchar,
	chE varchar,
	chF varchar,
	-- 葉 > におい
	ciA varchar,
	-- 葉 > 冬の木の葉
	cjA varchar,
	cjB varchar,
	-- 葉 > 草の寿命
	ckA varchar,
	ckB varchar,
	ckC varchar,
	-- 花 > 色
	eaA varchar,
	eaB varchar,
	eaC varchar,
	eaD varchar,
	-- 花 > つき方
	ebA varchar,
	ebB varchar,
	ebC varchar,
	ebD varchar,
	ebE varchar,
	ebF varchar,
	ebG varchar,
	ebH varchar,
	ebI varchar,
	ebJ varchar,
	-- 花 > 形
	ecA varchar,
	ecB varchar,
	ecC varchar,
	ecD varchar,
	ecE varchar,
	-- 花 > 花びらの数
	edA varchar,
	edB varchar,
	edC varchar,
	edD varchar,
	edE varchar,
	edF varchar,
	edG varchar,
	-- 花 > がくの形
	eeA varchar,
	eeB varchar,
	eeC varchar,
	-- 花 > がくの数
	efA varchar,
	efB varchar,
	efC varchar,
	efD varchar,
	efE varchar,
	efF varchar,
	efG varchar,
	-- 花 > ほうがくの外側
	egA varchar,
	egB varchar,
	egC varchar,
	-- 花 > おしべの形
	ehA varchar,
	ehB varchar,
	ehC varchar,
	ehD varchar,
	ehE varchar,
	ehF varchar,
	ehG varchar,
	ehH varchar,
	ehI varchar,
	-- 花 > おしべの数
	eiA varchar,
	eiB varchar,
	eiC varchar,
	eiD varchar,
	eiE varchar,
	eiF varchar,
	eiG varchar,
	-- 花 > めしべの先
	ejA varchar,
	ejB varchar,
	ejC varchar,
	ejD varchar,
	ejE varchar,
	ejF varchar,
	ejG varchar,
	-- 花 > 子房の位置
	ekA varchar,
	ekB varchar,
	ekC varchar,
	-- 果実 > 熟した色
	gaA varchar,
	gaB varchar,
	gaC varchar,
	gaD varchar,
	gaE varchar,
	-- 果実 > 実の形
	gbA varchar,
	gbB varchar,
	gbC varchar,
	gbD varchar,
	gbE varchar,
	gbF varchar,
	gbG varchar,
	-- 花期・分布 > 花期
	haA varchar,
	haB varchar,
	haC varchar,
	haD varchar,
	-- 花期・分布 > 分布
	hbA varchar,
	hbB varchar,
	hbC varchar,
	hbD varchar,
	hbE varchar,
	hbF varchar,
	hbG varchar,
	hbH varchar,
	hbI varchar,
	-- 花期・分布 > 環境
	hcA varchar,
	hcB varchar,
	hcC varchar,
	hcD varchar,
	hcE varchar,
	-- 花期・分布 > 自生栽培
	hdA varchar,
	hdB varchar,
	hdC varchar,

	primary key(lno)
	);

insert into plant_trait
select a.lno
-- 茎 > 形
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '1001'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '1002'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '1003'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '1004'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '1005'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '1006'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '1007'), '')
-- 茎 > 表面
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '1101'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '1102'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '1103'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '1104'), '')
-- 茎 > 切口
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '1201'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '1202'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '1203'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '1204'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '1205'), '')
-- 葉 > 形
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3001'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '3002'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '3003'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '3004'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '3005'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '3006'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '3007'), '')
,ifnull((select 'H' from searchplant_2 b where b.lno = a.lno and searchkey = '3008'), '')
,ifnull((select 'I' from searchplant_2 b where b.lno = a.lno and searchkey = '3009'), '')
-- 葉 > 先
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3101'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '3102'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '3103'), '')
-- 葉 > もと
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3201'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '3202'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '3203'), '')
-- 葉 > ふち
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3301'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '3302'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '3303'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '3304'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '3305'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '3306'), '')
-- 葉 > 脈
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3401'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '3402'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '3403'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '3404'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '3405'), '')
-- 葉 > 柄
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3501'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '3502'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '3503'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '3504'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '3505'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '3506'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '3507'), '')
-- 葉 > 托葉
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3601'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '3602'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '3603'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '3604'), '')
-- 葉 > つき方
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3701'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '3702'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '3703'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '3704'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '3705'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '3706'), '')
-- 葉 > におい
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3801'), '')
-- 葉 > 冬の木の葉
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '3901'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '3902'), '')
-- 葉 > 草の寿命
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '4001'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '4002'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '4003'), '')
-- 花 > 色
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5001'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5002'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5003'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '5004'), '')
-- 花 > つき方
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5101'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5102'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5103'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '5104'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '5105'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '5106'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '5107'), '')
,ifnull((select 'H' from searchplant_2 b where b.lno = a.lno and searchkey = '5108'), '')
,ifnull((select 'I' from searchplant_2 b where b.lno = a.lno and searchkey = '5109'), '')
,ifnull((select 'J' from searchplant_2 b where b.lno = a.lno and searchkey = '5110'), '')
-- 花 > 形
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5201'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5202'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5203'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '5204'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '5205'), '')
-- 花 > 花びらの数
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5301'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5302'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5303'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '5304'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '5305'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '5306'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '5307'), '')
-- 花 > がくの形
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5401'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5402'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5403'), '')
-- 花 > がくの数
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5501'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5502'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5503'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '5504'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '5505'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '5506'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '5507'), '')
-- 花 > ほうがくの外側
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5601'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5602'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5603'), '')
-- 花 > おしべの形
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5701'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5702'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5703'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '5704'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '5705'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '5706'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '5707'), '')
,ifnull((select 'H' from searchplant_2 b where b.lno = a.lno and searchkey = '5708'), '')
,ifnull((select 'I' from searchplant_2 b where b.lno = a.lno and searchkey = '5709'), '')
-- 花 > おしべの数
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5801'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5802'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5803'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '5804'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '5805'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '5806'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '5807'), '')
-- 花 > めしべの先
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '5901'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '5902'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '5903'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '5904'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '5905'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '5906'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '5907'), '')
-- 花 > 子房の位置
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '1101'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '1102'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '1103'), '')
-- 果実 > 熟した色
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '7001'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '7002'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '7003'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '7004'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '7005'), '')
-- 果実 > 実の形
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '7101'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '7102'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '7103'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '7104'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '7105'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '7106'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '7107'), '')
-- 花期・分布 > 花期
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '8001'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '8002'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '8003'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '8004'), '')
-- 花期・分布 > 分布
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '8101'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '8102'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '8103'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '8104'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '8105'), '')
,ifnull((select 'F' from searchplant_2 b where b.lno = a.lno and searchkey = '8106'), '')
,ifnull((select 'G' from searchplant_2 b where b.lno = a.lno and searchkey = '8107'), '')
,ifnull((select 'H' from searchplant_2 b where b.lno = a.lno and searchkey = '8108'), '')
,ifnull((select 'I' from searchplant_2 b where b.lno = a.lno and searchkey = '8109'), '')
-- 花期・分布 > 環境
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '8201'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '8202'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '8203'), '')
,ifnull((select 'D' from searchplant_2 b where b.lno = a.lno and searchkey = '8204'), '')
,ifnull((select 'E' from searchplant_2 b where b.lno = a.lno and searchkey = '8205'), '')
-- 花期・分布 > 自生栽培
,ifnull((select 'A' from searchplant_2 b where b.lno = a.lno and searchkey = '8301'), '')
,ifnull((select 'B' from searchplant_2 b where b.lno = a.lno and searchkey = '8302'), '')
,ifnull((select 'C' from searchplant_2 b where b.lno = a.lno and searchkey = '8303'), '')
from searchplant_1 a;

--
作成終了したので、最後に空き領域を開放する
vacuum;













